import assert from "node:assert/strict";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { after, beforeEach, test } from "node:test";
import type {
  ExtensionAPI,
  ExtensionCommandContext,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import piHarpoon from "./index.ts";

const cacheHome = process.env.XDG_CACHE_HOME;
assert.ok(cacheHome, "Set XDG_CACHE_HOME for temporary test files");
const agentDir = mkdtempSync(join(cacheHome, "pi-harpoon-test-"));
const previousAgentDir = process.env.PI_CODING_AGENT_DIR;
process.env.PI_CODING_AGENT_DIR = agentDir;

after(() => {
  if (previousAgentDir === undefined) delete process.env.PI_CODING_AGENT_DIR;
  else process.env.PI_CODING_AGENT_DIR = previousAgentDir;
  rmSync(agentDir, { recursive: true, force: true });
});

beforeEach(() => {
  rmSync(join(agentDir, "pi-harpoon.json"), { force: true });
  rmSync(join(agentDir, "settings.json"), { force: true });
});

function shortcutKeys(): string[] {
  const keys: string[] = [];
  piHarpoon({
    registerCommand() {},
    registerShortcut(key) {
      keys.push(key);
    },
    on() {},
  } as ExtensionAPI);
  return keys;
}

test("dedicated flat-root config supplies shortcut keys", () => {
  writeFileSync(join(agentDir, "settings.json"), "{invalid settings");
  writeFileSync(
    join(agentDir, "pi-harpoon.json"),
    JSON.stringify({
      models: ["test/model:high"],
      keys: {
        "pi.harpoon.cycle": "ctrl+alt+h",
        "pi.harpoon.select": "ctrl+alt+j",
      },
    }),
  );
  assert.deepEqual(shortcutKeys(), ["ctrl+alt+h", "ctrl+alt+j"]);
});

test("Harpoon list comes from dedicated config in configured order", async () => {
  writeFileSync(
    join(agentDir, "pi-harpoon.json"),
    JSON.stringify({ models: ["test/first:high", "test/second:off"] }),
  );
  writeFileSync(
    join(agentDir, "settings.json"),
    JSON.stringify({ "pi-harpoon": { models: ["legacy/model:low"] } }),
  );

  type Command = Parameters<ExtensionAPI["registerCommand"]>[1];
  type StartHandler = (
    event: { type: "session_start" },
    ctx: ExtensionContext,
  ) => void | Promise<void>;
  let command: Command | undefined;
  let start: StartHandler | undefined;
  piHarpoon({
    registerCommand(_name: string, registration: Command) {
      command = registration;
    },
    registerShortcut() {},
    on(_event: string, handler: StartHandler) {
      start = handler;
    },
  } as unknown as ExtensionAPI);

  const choices: string[] = [];
  const ctx = {
    modelRegistry: { find: () => ({}) },
    ui: {
      async select(_title: string, labels: string[]) {
        choices.push(...labels);
        return undefined;
      },
      notify(message: string) {
        assert.fail(message);
      },
    },
  } as unknown as ExtensionCommandContext;
  assert.ok(start);
  assert.ok(command);
  await start({ type: "session_start" }, ctx);
  await command.handler("", ctx);
  assert.deepEqual(choices, ["test/first (high)", "test/second (off)"]);
});

test("missing dedicated config does not fall back to settings", () => {
  writeFileSync(
    join(agentDir, "settings.json"),
    JSON.stringify({
      "pi-harpoon": {
        models: ["legacy/model"],
        keys: { "pi.harpoon.cycle": "ctrl+alt+h" },
      },
    }),
  );
  assert.deepEqual(shortcutKeys(), ["ctrl+shift+h"]);
});

test("flat-root config retains default cycle key and optional select key", () => {
  writeFileSync(
    join(agentDir, "pi-harpoon.json"),
    JSON.stringify({ models: ["test/model"] }),
  );
  assert.deepEqual(shortcutKeys(), ["ctrl+shift+h"]);
});

test("malformed JSON and invalid roots retain default shortcut", () => {
  for (const raw of ["{", "null", '"text"', "[]"]) {
    writeFileSync(join(agentDir, "pi-harpoon.json"), raw);
    assert.deepEqual(shortcutKeys(), ["ctrl+shift+h"], raw);
  }
});
