import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type StashKey = Parameters<ExtensionAPI["registerShortcut"]>[0];
interface StashState {
  text?: string;
  onContinue?: () => void;
}

// Reload and session changes replace modules, but keep this process memory.
const stateKey = Symbol.for("pi-util.editor-stash");
const globals = globalThis as typeof globalThis & { [stateKey]?: StashState };

export function registerEditorStash(pi: ExtensionAPI, key?: StashKey) {
  if (!key && !globals[stateKey]?.onContinue) return;
  const state = (globals[stateKey] ??= {});
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui" || state.onContinue) return;
    state.onContinue = () => {
      state.text = undefined;
    };
    // shortcut: any SIGCONT clears stash; track suspension if unsolicited signals matter.
    process.on("SIGCONT", state.onContinue);
  });
  pi.on("session_shutdown", (event, ctx) => {
    if (ctx.mode !== "tui" || event.reason !== "quit") return;
    state.text = undefined;
    if (state.onContinue) {
      process.off("SIGCONT", state.onContinue);
      state.onContinue = undefined;
    }
  });
  if (!key) return;
  pi.registerShortcut(key, {
    description: "Stash or restore editor draft",
    handler(ctx) {
      if (ctx.mode !== "tui") return;
      const text = ctx.ui.getEditorText();
      if (text !== "") {
        state.text = text;
        ctx.ui.setEditorText("");
      } else if (state.text !== undefined) {
        ctx.ui.setEditorText(state.text);
        state.text = undefined;
      }
    },
  });
}
