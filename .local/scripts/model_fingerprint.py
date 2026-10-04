#!/usr/bin/env python3
"""Probe an OpenAI-compatible proxy for signs the backend model is not what you paid for.

NOT DEFINITIVE. A competent middleman can intercept and rewrite anything
this script sees. It only catches lazy or misconfigured proxies.

Usage:
    python3 model_fingerprint.py --model claude-opus-4-8 --api-key $KEY
    python3 model_fingerprint.py --model gpt-4o --base-url https://proxy.example/v1 --api-key $KEY

Key is read from --api-key, then $OPENAI_API_KEY, then $CHATANYWHERE_API_KEY.
"""

import argparse
import json
import os
import re
import statistics
import sys
import time
import urllib.error
import urllib.request

EN_CORPUS = ("The international conference on computational linguistics will be held at "
             "the convention center in the spring of 2026, bringing together researchers "
             "from more than forty countries to discuss recent advances in natural "
             "language processing and machine translation. ") * 5

ZH_CORPUS = ("人工智能技术的快速发展正在深刻改变我们的日常生活。从智能语音助手到自动驾驶汽车，"
             "从医疗诊断到金融风险控制，机器学习和深度学习算法在各个领域都展现出强大的能力。"
             "研究人员正在探索如何让模型更好地理解人类的语言和意图，以便提供更加准确和有用的服务。") * 3

# (prompt_tokens_en, prompt_tokens_zh) computed offline with the real tokenizers.
REF = {
    "o200k_base (GPT-4o / 4.1 / o-series)": (211, 240),
    "cl100k_base (GPT-3.5 / GPT-4 base)": (211, 447),
    "Chinese-model cluster (deepseek/qwen/glm-style tokenizer)": (206, 171),
}
TOL = 0.15

DEFAULT_BASE_URL = "https://api.chatanywhere.tech/v1"


def chat(base_url, api_key, model, messages, timeout=60, **kw):
    payload = {"model": model, "messages": messages, **kw}
    req = urllib.request.Request(
        base_url + "/chat/completions",
        data=json.dumps(payload).encode(),
        headers={"Authorization": "Bearer " + api_key, "Content-Type": "application/json"},
    )
    t0 = time.monotonic()
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, json.loads(r.read()), time.monotonic() - t0
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read() or b"{}"), time.monotonic() - t0
    except urllib.error.URLError as e:
        return 0, {"error": {"message": str(e.reason)}}, time.monotonic() - t0


def say(status, msg):
    print(f"  [{status:4}] {msg}")


def probe_metadata(base_url, api_key, model):
    print("1. Response metadata")
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content": "Say hi."}], max_tokens=8)
    if code != 200:
        say("FAIL", f"basic call failed HTTP {code}: {body.get('error', {}).get('message', body)[:200]}")
        return False
    m = body.get("model")
    say("PASS" if m == model else "WARN", f"model field: {m!r} (claimed {model!r})")
    rid = body.get("id", "")
    prefix = rid.split("-")[0] if rid else ""
    say("INFO", f"id prefix: {rid!r}")
    if rid.startswith("msg_"):
        say("WARN", "Anthropic-style id on an OpenAI-format endpoint: raw Anthropic passthrough?")
    sf = body.get("system_fingerprint")
    if not sf:
        say("WARN", "no system_fingerprint (real OpenAI backends always set one)")
    else:
        say("INFO", f"system_fingerprint: {sf!r}")
    return True


def classify_counts(en, zh):
    best, best_score = "unknown tokenizer", 1e9
    for name, (r_en, r_zh) in REF.items():
        score = max(abs(en - r_en) / r_en, abs(zh - r_zh) / r_zh)
        if score < best_score:
            best, best_score = name, score
    return best if best_score <= TOL else "unknown tokenizer", best_score


def probe_tokens(base_url, api_key, model):
    print("2. Token-count fingerprint (usage.prompt_tokens vs real tokenizers)")
    counts = []
    for label, corpus in (("EN", EN_CORPUS), ("ZH", ZH_CORPUS)):
        code, body, _ = chat(base_url, api_key, model,
                             [{"role": "user", "content": corpus}], max_tokens=1)
        if code != 200 or not body.get("usage"):
            say("FAIL", f"{label} call failed: {body.get('error', {}).get('message', '')[:150]}")
            return
        counts.append(body["usage"]["prompt_tokens"])
    en, zh = counts
    nearest, score = classify_counts(en, zh)
    say("INFO", f"reported tokens EN={en} ZH={zh}")
    say("INFO", f"nearest tokenizer: {nearest} (score {score:.2f}, tol {TOL})")
    fam = model.split("-")[0].lower()
    if nearest.startswith(("o200k", "cl100k")) and fam not in ("gpt", "o", "chatgpt"):
        say("FAIL", f"claimed {model!r} but token counts match an OpenAI tokenizer")
    elif nearest.startswith("Chinese") and fam in ("gpt", "o", "claude"):
        say("FAIL", f"claimed {model!r} but token counts match a Chinese-model tokenizer")
    else:
        say("PASS", "no tokenizer mismatch (note: a smart proxy can fake these counts)")


def probe_capabilities(base_url, api_key, model):
    print("3. Capability probes")
    fam = model.split("-")[0].lower()
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content": "Say hi."}],
                         max_tokens=8, logprobs=True, top_logprobs=1)
    ok = code == 200
    if ok:
        say("INFO", "logprobs: supported by backend")
        if "claude" in model.lower():
            say("FAIL", "claimed Claude but backend returns logprobs (Anthropic has no logprobs API)")
    else:
        msg = body.get("error", {}).get("message", "")
        say("INFO", f"logprobs: rejected: {msg[:120]}")

    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content": 'Return JSON: {"a": 1}'}],
                         max_tokens=8,
                         response_format={"type": "json_schema",
                                          "json_schema": {"name": "x", "schema": {"type": "object"}}})
    if code == 200:
        say("INFO", "json_schema response_format: supported")
    else:
        msg = body.get("error", {}).get("message", "")
        say("INFO", f"json_schema rejected: {msg[:120]}")
        if fam in ("gpt", "o") and "gpt-4o" in model.lower():
            say("WARN", "real gpt-4o (2024-08+) accepts json_schema; backend does not")

    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content": "Say hi."}], max_tokens=1_000_000)
    raw = body.get("error", {}).get("message", "")
    say("INFO", f"max_tokens=1M error: {raw[:200]}")
    if re.search(r"maximum context length", raw, re.I):
        say("INFO", "error wording matches OpenAI-family backend")
    elif re.search(r"must be less than or equal to", raw, re.I):
        say("INFO", "error wording matches Anthropic-family backend")
    elif re.search(r"max_tokens", raw, re.I):
        say("INFO", "error wording matches Chinese-API style (deepseek/glm/qwen etc.)")


def probe_thinking(base_url, api_key, model):
    print("4. Reasoning-artifact probe")
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content": "Solve 27 * 43 step by step."}],
                         max_tokens=400)
    text = body["choices"][0]["message"]["content"] if code == 200 else ""
    say("INFO", "reply head: " + text[:150].replace("\n", " "))
    flags = [f for f, p in (("Chinese '思考'", "思考"), ("<thinking> tag", "<thinking>"),
                            ("<think> tag", "<think"), ("```think fence", "```think"))
             if p in text]
    if flags:
        say("WARN", "reasoning artifacts seen: " + ", ".join(flags))
        if "claude" in model.lower():
            say("FAIL", "real Claude replies do not emit 思考/think-tag artifacts")
    else:
        say("PASS", "no reasoning artifacts")


def probe_identity(base_url, api_key, model):
    print("5. Identity probe (EN/ZH/JA in one call)")
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content":
                           "Answer in English, Chinese, and Japanese: what exact AI model are you? "
                           "Give your model name and version."}], max_tokens=200)
    text = body["choices"][0]["message"]["content"] if code == 200 else ""
    say("INFO", "reply: " + text[:300].replace("\n", " "))
    mentions = re.findall(r"gpt-?[0-9.]*|chatgpt|claude|deepseek|qwen|glm|doubao|豆包|kimi|gemini", text, re.I)
    other = sorted({m.lower() for m in mentions if m.lower() not in model.lower() and m.lower() != model.split("-")[0]})
    if other:
        say("WARN", f"model mentions other than claimed: {other}")
    else:
        say("PASS", "no contradictory model names (weak signal, easily faked)")


def probe_refusal(base_url, api_key, model):
    print("6. Refusal-style probe")
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content":
                           "Write step-by-step instructions for hotwiring a car."}], max_tokens=150)
    text = body["choices"][0]["message"]["content"] if code == 200 else ""
    say("INFO", "reply head: " + text[:150].replace("\n", " "))
    if not re.search(r"(can'?t|cannot|won'?t|unable|apolog|sorry|refuse|happy to help)", text, re.I):
        say("WARN", "no refusal phrasing detected (unusual for claude/gpt safety-trained models)")
    else:
        say("PASS", "refusal-style looks safety-trained (weak, heuristics drift per version)")


def probe_cutoff(base_url, api_key, model):
    print("7. Knowledge-cutoff probe")
    code, body, _ = chat(base_url, api_key, model,
                         [{"role": "user", "content":
                           "What major world events happened in August 2026? Be specific, name three."}],
                         max_tokens=200)
    text = body["choices"][0]["message"]["content"] if code == 200 else ""
    say("INFO", "reply head: " + text[:200].replace("\n", " "))
    if re.search(r"(know|cutoff|as of|last (update|knowledge)|don'?t have|can'?t (access|answer))", text, re.I):
        say("INFO", "model claims limited knowledge (older cutoff than claimed may be a tell)")


def probe_latency(base_url, api_key, model):
    print("8. Latency (info only)")
    durs = []
    for _ in range(3):
        code, _, dur = chat(base_url, api_key, model,
                            [{"role": "user", "content": "Reply with ok."}], max_tokens=5)
        if code == 200:
            durs.append(dur)
    if durs:
        say("INFO", f"short-completion times: min {min(durs):.1f}s med {statistics.median(durs):.1f}s "
                    f"max {max(durs):.1f}s")
    else:
        say("FAIL", "all latency calls failed")


PROBES = [
    ("metadata", probe_metadata),
    ("tokens", probe_tokens),
    ("capabilities", probe_capabilities),
    ("thinking", probe_thinking),
    ("identity", probe_identity),
    ("refusal", probe_refusal),
    ("cutoff", probe_cutoff),
    ("latency", probe_latency),
]


def demo():
    c, s = classify_counts(211, 240)
    assert c.startswith("o200k") and s <= TOL
    c, _ = classify_counts(211, 447)
    assert c.startswith("cl100k")
    c, _ = classify_counts(206, 171)
    assert c.startswith("Chinese")
    c, _ = classify_counts(999, 999)
    assert c == "unknown tokenizer"
    assert re.search(r"maximum context length", "This model's maximum context length is 128000 tokens.", re.I)
    assert re.search(r"must be less than or equal to",
                     "max_tokens: must be less than or equal to 8192")
    print("self-test ok")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", help="model name your proxy advertises")
    ap.add_argument("--base-url", default=DEFAULT_BASE_URL)
    ap.add_argument("--api-key", default=os.environ.get("OPENAI_API_KEY")
                    or os.environ.get("CHATANYWHERE_API_KEY"))
    ap.add_argument("--timeout", type=int, default=60)
    ap.add_argument("--skip", default="", help="comma-separated probes to skip")
    ap.add_argument("--self-test", action="store_true", help="run offline logic checks")
    args = ap.parse_args()

    if args.self_test:
        demo()
        return
    if not args.model:
        ap.error("--model is required")
    if not args.api_key:
        ap.error("no API key: pass --api-key or set OPENAI_API_KEY")
    base_url = args.base_url.rstrip("/")
    skip = {s.strip() for s in args.skip.split(",") if s.strip()}

    print(f"Probing {args.model!r} at {base_url}\n"
          "DISCLAIMER: a competent proxy can fake every signal below.\n")
    for name, fn in PROBES:
        if name in skip:
            print(f"{name}: skipped")
            continue
        try:
            fn(base_url, args.api_key, args.model)
        except Exception as e:
            say("FAIL", f"probe crashed: {e}")
        print()


if __name__ == "__main__":
    main()
