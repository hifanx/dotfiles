import { test } from "node:test";
import assert from "node:assert/strict";
import harpoon, { activeIndex, parse } from "../harpoon.ts";
import stash from "../stash.ts";

function fake(model?: { provider: string; id: string }) {
  const s: any = { cmds: {}, keys: {}, on: {}, notes: [], level: "high", widget: undefined, text: "", model };
  const pi: any = {
    registerCommand: (n: string, o: any) => (s.cmds[n] = o),
    registerShortcut: (k: string, o: any) => (s.keys[k] = o),
    on: (e: string, h: any) => (s.on[e] = h),
    getThinkingLevel: () => s.level,
    setThinkingLevel: (l: string) => (s.level = l),
    setModel: async (m: any) => ((s.model = m), (s.level = "default"), m.provider !== "noauth"),
  };
  const ctx: any = {
    get model() { return s.model; },
    modelRegistry: { find: (provider: string, id: string) => (id === "missing" ? undefined : { provider, id }) },
    ui: {
      notify: (m: string, t: string) => s.notes.push([t, m]),
      select: async (_t: string, o: string[]) => ((s.options = o), o[s.pick ?? 0]),
      getEditorText: () => s.text,
      setEditorText: (t: string) => (s.text = t),
      setWidget: (_k: string, c: any) => (s.widget = c),
      theme: { fg: (_c: string, t: string) => t },
    },
  };
  return { s, pi, ctx };
}

test("parse", () => {
  assert.deepEqual(parse("claude-code/claude-opus-5-5:high"), { provider: "claude-code", id: "claude-opus-5-5", level: "high" });
  assert.deepEqual(parse("a/b"), { provider: "a", id: "b", level: undefined });
  assert.deepEqual(parse("or/x/y:free"), { provider: "or", id: "x/y:free", level: undefined });
  assert.equal(activeIndex(["a/b:low", "a/b"], "a", "b", "high"), 1);
});

test("no keys: command registered, no shortcuts", () => {
  const { s, pi } = fake();
  harpoon(pi, { harpoon: { models: ["a/b"] } });
  stash(pi, {});
  assert.ok(s.cmds.harpoon);
  assert.deepEqual(Object.keys(s.keys), []);
});

test("harpoon cycle wraps, jumps to first, resets/sets level", async () => {
  const { s, pi, ctx } = fake({ provider: "x", id: "y" });
  harpoon(pi, { harpoon: { models: ["a/b:low", "a/c"] }, keys: { "pi.harpoon.cycle": "ctrl+h" } });
  const cycle = () => s.keys["ctrl+h"].handler(ctx);
  await cycle(); assert.deepEqual([s.model.id, s.level], ["b", "low"]);
  await cycle(); assert.deepEqual([s.model.id, s.level], ["c", "default"]);
  await cycle(); assert.equal(s.model.id, "b");
});

test("harpoon errors and select marks active", async () => {
  const { s, pi, ctx } = fake({ provider: "a", id: "c" });
  harpoon(pi, { harpoon: { models: ["a/missing", "noauth/z", "a/c"] } });
  s.pick = 0; await s.cmds.harpoon.handler("", ctx);
  assert.deepEqual(s.options, ["  a/missing", "  noauth/z", "● a/c"]);
  s.pick = 1; await s.cmds.harpoon.handler("", ctx);
  assert.equal(s.notes.length, 2);
  assert.ok(s.notes.every(([t]: string[]) => t === "error"));
});

test("stash: stash, replace, restore, noop", () => {
  const { s, pi, ctx } = fake();
  stash(pi, { keys: { "pi.editor.stash": "ctrl+s" } });
  const press = () => s.keys["ctrl+s"].handler(ctx);
  press(); assert.equal(s.widget, undefined);
  s.text = "one"; press(); assert.deepEqual([s.text, s.widget], ["", ["stash"]]);
  s.text = "two"; press(); assert.equal(s.text, "");
  press(); assert.deepEqual([s.text, s.widget], ["two", undefined]);
});
