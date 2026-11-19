import { readFileSync } from "node:fs";
import { join } from "node:path";
import { type ExtensionAPI, getAgentDir } from "@earendil-works/pi-coding-agent";
import harpoon from "./harpoon.ts";
import stash from "./stash.ts";

export type Config = { harpoon?: { models?: string[] }; keys?: Record<string, string> };

export default function (pi: ExtensionAPI) {
  const path = join(getAgentDir(), "pi-utils.json");
  let cfg: Config = {};
  try {
    cfg = JSON.parse(readFileSync(path, "utf8"));
  } catch (e) {
    let warned = false;
    pi.on("session_start", (_e, ctx) => {
      if (!warned) ctx.ui.notify(`pi-utils: cannot load ${path}: ${(e as Error).message}`, "warning");
      warned = true;
    });
  }
  harpoon(pi, cfg);
  stash(pi, cfg);
}
