import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { Config } from "./index.ts";

// shortcut: collapsed "[paste #n]" blocks restore expanded; exact restore needs editor internals.
export default function (pi: ExtensionAPI, cfg: Config) {
  const key = cfg.keys?.["pi.editor.stash"];
  if (!key) return;
  let stashed: string | undefined; // in memory only: survives /new /resume /fork, not /reload

  const show = (ctx: ExtensionContext) =>
    ctx.ui.setWidget("pi-utils.stash", stashed === undefined ? undefined : [ctx.ui.theme.fg("dim", "stash")], {
      placement: "belowEditor",
    });

  pi.on("session_start", (_e, ctx) => show(ctx));
  pi.registerShortcut(key as any, {
    description: "Stash / restore editor text",
    handler: (ctx) => {
      const text = ctx.ui.getEditorText();
      if (text) {
        stashed = text;
        ctx.ui.setEditorText("");
      } else if (stashed !== undefined) {
        ctx.ui.setEditorText(stashed);
        stashed = undefined;
      } else return;
      show(ctx);
    },
  });
}
