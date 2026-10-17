import assert from "node:assert/strict";
import { copyFileSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { after, afterEach, beforeEach, test } from "node:test";
import { pathToFileURL } from "node:url";
import type {
  ExtensionAPI,
  ExtensionContext,
  SessionShutdownEvent,
  SessionStartEvent,
} from "@earendil-works/pi-coding-agent";
import piUtil from "./index.ts";

const cacheHome = process.env.XDG_CACHE_HOME;
assert.ok(cacheHome, "Set XDG_CACHE_HOME for temporary test files");
const agentDir = mkdtempSync(join(cacheHome, "pi-util-test-"));
const previousAgentDir = process.env.PI_CODING_AGENT_DIR;
process.env.PI_CODING_AGENT_DIR = agentDir;
const configFile = join(agentDir, "pi-util.json");

type Shortcut = Parameters<ExtensionAPI["registerShortcut"]>[1]["handler"];
type Lifecycle = (
  event: SessionStartEvent | SessionShutdownEvent,
  ctx: ExtensionContext,
) => void | Promise<void>;

function createHost(factory = piUtil, mode: ExtensionContext["mode"] = "tui") {
  let text = "";
  const shortcuts = new Map<string, Shortcut>();
  const handlers = new Map<string, Lifecycle[]>();
  const ctx = {
    mode,
    hasUI: mode === "tui",
    ui: {
      getEditorText: () => text,
      setEditorText(value: string) {
        text = value;
      },
      notify() {
        assert.fail("Stash operations must remain silent");
      },
      setStatus() {
        assert.fail("Stash must not add a status badge");
      },
    },
  } as unknown as ExtensionContext;
  factory({
    registerShortcut(key: string, options: { handler: Shortcut }) {
      shortcuts.set(key, options.handler);
    },
    on(event: string, handler: Lifecycle) {
      const list = handlers.get(event) ?? [];
      list.push(handler);
      handlers.set(event, list);
      return () => {};
    },
  } as unknown as ExtensionAPI);

  async function emit(event: SessionStartEvent | SessionShutdownEvent) {
    for (const handler of handlers.get(event.type) ?? []) {
      await handler(event, ctx);
    }
  }

  const host = {
    get text() {
      return text;
    },
    set text(value: string) {
      text = value;
    },
    keys: () => [...shortcuts.keys()],
    start: (reason: SessionStartEvent["reason"] = "startup") =>
      emit({ type: "session_start", reason }),
    shutdown: (reason: SessionShutdownEvent["reason"]) =>
      emit({ type: "session_shutdown", reason }),
    async press(key = "ctrl+s") {
      const handler = shortcuts.get(key);
      assert.ok(handler, `Missing shortcut: ${key}`);
      await handler(ctx);
    },
  };
  cleanups.push(() => host.shutdown("quit"));
  return host;
}

const cleanups: (() => Promise<void>)[] = [];
let runtimeId = 0;

async function freshRuntime() {
  const dir = join(agentDir, `runtime-${++runtimeId}`);
  mkdirSync(dir);
  for (const file of ["index.ts", "editor-stash.ts"]) {
    copyFileSync(new URL(`./${file}`, import.meta.url), join(dir, file));
  }
  return (await import(pathToFileURL(join(dir, "index.ts")).href))
    .default as typeof piUtil;
}

beforeEach(() => {
  rmSync(configFile, { force: true });
  rmSync(join(agentDir, "settings.json"), { force: true });
});
afterEach(async () => {
  for (const cleanup of cleanups) await cleanup();
  cleanups.length = 0;
});
after(() => {
  if (previousAgentDir === undefined) delete process.env.PI_CODING_AGENT_DIR;
  else process.env.PI_CODING_AGENT_DIR = previousAgentDir;
  rmSync(agentDir, { recursive: true, force: true });
});

function configure(key: unknown = "ctrl+s") {
  writeFileSync(configFile, JSON.stringify({ keys: { "editor-stash": key } }));
}

test("configured shortcut stashes and restores exact draft text", async () => {
  configure();
  const host = createHost();
  await host.start();
  host.text = "  Draft\n\twith pasted text 👋\n";
  await host.press();
  assert.equal(host.text, "");
  await host.press();
  assert.equal(host.text, "  Draft\n\twith pasted text 👋\n");
});

test("stash survives a genuinely fresh extension runtime after reload", async () => {
  configure();
  const original = createHost();
  await original.start();
  original.text = "Draft before reload";
  await original.press();
  await original.shutdown("reload");
  const replacement = createHost(await freshRuntime());
  await replacement.start("reload");
  await replacement.press();
  assert.equal(replacement.text, "Draft before reload");
});

test("actual TUI quit discards stash before another TUI starts", async () => {
  configure();
  const original = createHost();
  await original.start();
  original.text = "Discard on quit";
  await original.press();
  await original.shutdown("quit");
  const replacement = createHost(await freshRuntime());
  await replacement.start();
  await replacement.press();
  assert.equal(replacement.text, "");
});

test("suspend/resume discards stash without disabling subsequent drafting", async () => {
  configure();
  const host = createHost();
  await host.start();
  host.text = "Discard on suspend";
  await host.press();
  process.emit("SIGCONT");
  await host.press();
  assert.equal(host.text, "");
  host.text = "Draft after fg";
  await host.press();
  await host.press();
  assert.equal(host.text, "Draft after fg");
});

test("non-TUI runtimes cannot change editor text or discard an active TUI stash", async () => {
  configure();
  const tui = createHost();
  await tui.start();
  tui.text = "Interactive draft";
  await tui.press();
  for (const mode of ["print", "json", "rpc"] as const) {
    const other = createHost(piUtil, mode);
    await other.start();
    other.text = "Non-TUI text";
    await other.press();
    assert.equal(other.text, "Non-TUI text");
    await other.shutdown("quit");
  }
  await tui.press();
  assert.equal(tui.text, "Interactive draft");
});

test("quit still discards stash when configuration disables the shortcut on reload", async () => {
  configure();
  const original = createHost();
  await original.start();
  original.text = "Disabled before quit";
  await original.press();
  await original.shutdown("reload");
  rmSync(configFile);
  const disabled = createHost(await freshRuntime());
  await disabled.start("reload");
  assert.deepEqual(disabled.keys(), []);
  await disabled.shutdown("quit");
  configure();
  const replacement = createHost(await freshRuntime());
  await replacement.start();
  await replacement.press();
  assert.equal(replacement.text, "");
});

test("missing or malformed configuration never enables a fallback shortcut", async () => {
  writeFileSync(
    join(agentDir, "settings.json"),
    JSON.stringify({ "pi-util": { keys: { "editor-stash": "ctrl+s" } } }),
  );
  const missing = createHost();
  await missing.start();
  assert.deepEqual(missing.keys(), []);
  for (const raw of [
    "{", "null", "[]", '"text"', '{}', '{"keys":null}',
    '{"keys":{"editor-stash":null}}', '{"keys":{"editor-stash":42}}',
    '{"keys":{"editor-stash":""}}', '{"keys":{"editor-stash":"  "}}',
  ]) {
    writeFileSync(configFile, raw);
    const host = createHost();
    await host.start();
    assert.deepEqual(host.keys(), [], raw);
  }
});

test("custom binding preserves even whitespace-only drafts", async () => {
  configure("alt+s");
  const host = createHost();
  await host.start();
  assert.deepEqual(host.keys(), ["alt+s"]);
  host.text = " \n\t";
  await host.press("alt+s");
  assert.equal(host.text, "");
  await host.press("alt+s");
  assert.equal(host.text, " \n\t");
});

test("replacement is silent, restoration consumes stash, and empty toggles do nothing", async () => {
  configure();
  const host = createHost();
  await host.start();
  await host.press();
  assert.equal(host.text, "");
  host.text = "Draft A";
  await host.press();
  host.text = "Draft B";
  await host.press();
  assert.equal(host.text, "");
  await host.press();
  assert.equal(host.text, "Draft B");
  host.text = "";
  await host.press();
  assert.equal(host.text, "");
});

test("session changes keep stash and one resume listener, quit removes that listener", async () => {
  configure();
  const listeners = process.listenerCount("SIGCONT");
  let host = createHost();
  await host.start();
  assert.equal(process.listenerCount("SIGCONT"), listeners + 1);
  for (const reason of ["new", "resume", "fork", "reload"] as const) {
    host.text = "Kept across session changes";
    await host.press();
    await host.shutdown(reason);
    host = createHost(await freshRuntime());
    await host.start(reason);
    assert.equal(process.listenerCount("SIGCONT"), listeners + 1);
    await host.press();
    assert.equal(host.text, "Kept across session changes");
  }
  host.text = "Discard after session changes";
  await host.press();
  process.emit("SIGCONT");
  await host.press();
  assert.equal(host.text, "");
  await host.shutdown("quit");
  assert.equal(process.listenerCount("SIGCONT"), listeners);
});

test("config reload can disable then rebind the shortcut without losing stash", async () => {
  configure();
  const original = createHost();
  await original.start();
  original.text = "Kept through config changes";
  await original.press();
  configure("alt+s");
  assert.deepEqual(original.keys(), ["ctrl+s"]);
  await original.shutdown("reload");
  rmSync(configFile);
  const disabled = createHost(await freshRuntime());
  await disabled.start("reload");
  assert.deepEqual(disabled.keys(), []);
  configure("alt+s");
  await disabled.shutdown("reload");
  const rebound = createHost(await freshRuntime());
  await rebound.start("reload");
  assert.deepEqual(rebound.keys(), ["alt+s"]);
  await rebound.press("alt+s");
  assert.equal(rebound.text, "Kept through config changes");
});

test("malformed key syntax cannot accidentally bind ordinary draft letters", async () => {
  for (const key of ["oops+s", "ctr+s", "ctrl+", "ctrl+not-a-key", " ctrl+s "]) {
    configure(key);
    const host = createHost();
    await host.start();
    assert.deepEqual(host.keys(), [], key);
  }
});

test("Pi named, function, symbol, and combined modifier key syntax remains configurable", () => {
  for (const key of ["f5", "ctrl+shift+enter", "super+k", "shift+ctrl+pageUp", "ctrl+;"]) {
    configure(key);
    assert.deepEqual(createHost().keys(), [key]);
  }
});
