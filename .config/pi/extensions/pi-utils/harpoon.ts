import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { Config } from "./index.ts";

const LEVELS = ["off", "minimal", "low", "medium", "high", "xhigh", "max"];

// "provider/model[:level]" — model ids may contain "/" or ":", so split on the first "/" and a trailing known level.
export function parse(entry: string) {
  const slash = entry.indexOf("/");
  const colon = entry.lastIndexOf(":");
  const level = colon > slash && LEVELS.includes(entry.slice(colon + 1)) ? entry.slice(colon + 1) : undefined;
  const rest = level ? entry.slice(0, colon) : entry;
  return { provider: rest.slice(0, slash), id: rest.slice(slash + 1), level };
}

export function activeIndex(entries: string[], provider?: string, id?: string, level?: string) {
  return entries.findIndex((e) => {
    const p = parse(e);
    return p.provider === provider && p.id === id && (!p.level || p.level === level);
  });
}

export default function (pi: ExtensionAPI, cfg: Config) {
  const entries = cfg.harpoon?.models ?? [];
  const current = (ctx: ExtensionContext) =>
    activeIndex(entries, ctx.model?.provider, ctx.model?.id, pi.getThinkingLevel());

  async function apply(entry: string, ctx: ExtensionContext) {
    const { provider, id, level } = parse(entry);
    const model = ctx.modelRegistry.find(provider, id);
    try {
      if (!model || !(await pi.setModel(model))) throw new Error(model ? "no auth" : "model not found");
    } catch (e) {
      return ctx.ui.notify(`harpoon: ${entry}: ${(e as Error).message}`, "error");
    }
    if (level) pi.setThinkingLevel(level as any);
  }

  pi.registerCommand("harpoon", {
    description: "Select a harpooned model",
    handler: async (_args, ctx) => {
      if (!entries.length) return ctx.ui.notify("harpoon: no models configured", "warning");
      const active = current(ctx);
      const options = entries.map((e, i) => `${i === active ? "●" : " "} ${e}`);
      const choice = await ctx.ui.select("Harpoon", options);
      if (choice !== undefined) await apply(entries[options.indexOf(choice)], ctx);
    },
  });

  const key = cfg.keys?.["pi.harpoon.cycle"];
  if (key && entries.length)
    pi.registerShortcut(key as any, {
      description: "Cycle harpooned models",
      handler: (ctx) => apply(entries[(current(ctx) + 1) % entries.length], ctx),
    });
}
