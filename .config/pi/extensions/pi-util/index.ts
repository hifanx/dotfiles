import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { registerEditorStash } from "./editor-stash.ts";

// shortcut: mirrors Pi key syntax; use SDK validation if Pi exposes it.
const KEY_BINDING =
  /^(?:(?:ctrl|alt|shift|super)\+)*(?:[!#-~]|escape|esc|enter|return|tab|space|backspace|delete|insert|clear|home|end|pageup|pagedown|up|down|left|right|f(?:[1-9]|1[0-2]))$/i;

function readStashKey(): string | undefined {
  // shortcut: mirrors getAgentDir() for Node tests; use SDK if path rules change.
  const agentDir =
    process.env.PI_CODING_AGENT_DIR?.replace(/^~/, homedir()) ||
    join(homedir(), ".pi", "agent");
  try {
    const config = JSON.parse(readFileSync(join(agentDir, "pi-util.json"), "utf8"));
    const key = config?.keys?.["editor-stash"];
    return typeof key === "string" && KEY_BINDING.test(key) ? key : undefined;
  } catch {
    return undefined;
  }
}

export default function piUtil(pi: ExtensionAPI) {
  const key = readStashKey();
  registerEditorStash(
    pi,
    key as Parameters<ExtensionAPI["registerShortcut"]>[0] | undefined,
  );
}
