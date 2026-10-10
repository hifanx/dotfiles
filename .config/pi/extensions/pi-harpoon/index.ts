/**
 * pi-harpoon — cycle/select a curated list of model+thinking-level entries.
 *
 * Config in <agent-dir>/pi-harpoon.json:
 *
 *   {
 *     "models": ["anthropic/claude-sonnet-4-5:high", "opencode-go/glm-5.3:medium"],
 *     "keys": { "pi.harpoon.cycle": "ctrl+shift+h", "pi.harpoon.select": "ctrl+shift+j" }
 *   }
 *
 * Entry format: "provider/model[:level]". Invalid entries are excluded and
 * reported once at startup. Successful switches are silent.
 *
 * Only `import type` from the pi package (stripped at runtime), so tests load
 * this extension under plain Node: `node --test extensions/pi-harpoon/test.ts`.
 */

import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

// ---------------------------------------------------------------------------
// Pure helpers
// ---------------------------------------------------------------------------

export const LEVELS = [
  "off",
  "minimal",
  "low",
  "medium",
  "high",
  "xhigh",
  "max",
] as const;
export type Level = (typeof LEVELS)[number];

export interface Entry {
  provider: string;
  model: string;
  level?: Level;
}

export function parseEntry(raw: string): Entry | { error: string } {
  const entry = raw.trim();
  const [ref, ...rest] = entry.split(":");
  if (rest.length > 1) return { error: `too many ':' in "${raw}"` };

  const slash = ref.indexOf("/");
  if (slash <= 0 || slash === ref.length - 1) {
    return { error: `"${raw}" must be "provider/model[:level]"` };
  }
  const provider = ref.slice(0, slash);
  const model = ref.slice(slash + 1);
  const levelStr = rest[0];

  if (levelStr === undefined) return { provider, model };
  if (!(LEVELS as readonly string[]).includes(levelStr)) {
    return {
      error: `"${raw}" has unknown level "${levelStr}" (valid: ${LEVELS.join("|")})`,
    };
  }
  return { provider, model, level: levelStr as Level };
}

/** Index of next entry after the first entry matching `modelId` (level ignored); 0 when no match. */
export function nextEntryIndex(entries: Entry[], modelId: string): number {
  const current = entries.findIndex((e) => e.model === modelId);
  if (current === -1) return 0;
  return (current + 1) % entries.length;
}

export function label(entry: Entry): string {
  return `${entry.provider}/${entry.model}${entry.level ? ` (${entry.level})` : ""}`;
}

// ---------------------------------------------------------------------------
// pi wiring
// ---------------------------------------------------------------------------

const DEFAULT_CYCLE_KEY = "ctrl+shift+h";

interface HarpoonConfig {
  models: string[];
  cycleKey: string;
  selectKey?: string;
}

// shortcut: mirrors getAgentDir() for plain-Node tests; use SDK if path rules drift.
function configPath(): string {
  const dir =
    process.env.PI_CODING_AGENT_DIR?.replace(/^~/, homedir()) ??
    join(homedir(), ".pi", "agent");
  return join(dir, "pi-harpoon.json");
}

function readConfig(): HarpoonConfig | undefined {
  const path = configPath();
  if (!existsSync(path)) return undefined;
  try {
    const config = JSON.parse(readFileSync(path, "utf-8"));
    if (!config || typeof config !== "object" || Array.isArray(config)) {
      return undefined;
    }
    const keys = config.keys ?? {};
    return {
      models: Array.isArray(config.models)
        ? config.models.filter((m: unknown) => typeof m === "string")
        : [],
      cycleKey:
        typeof keys["pi.harpoon.cycle"] === "string"
          ? keys["pi.harpoon.cycle"]
          : DEFAULT_CYCLE_KEY,
      selectKey:
        typeof keys["pi.harpoon.select"] === "string"
          ? keys["pi.harpoon.select"]
          : undefined,
    };
  } catch {
    return undefined;
  }
}

export default function piHarpoon(pi: ExtensionAPI) {
  const config = readConfig();
  const cycleKey = config?.cycleKey ?? DEFAULT_CYCLE_KEY;
  let entries: Entry[] = [];

  function ready(ctx: ExtensionContext): boolean {
    if (entries.length > 0) return true;
    ctx.ui.notify(
      config
        ? "harpoon: no valid models in pi-harpoon.json — fix the entries reported at startup"
        : "harpoon: no readable pi-harpoon.json — add one to list models",
      "warning",
    );
    return false;
  }

  async function apply(entry: Entry, ctx: ExtensionContext): Promise<void> {
    const model = ctx.modelRegistry.find(entry.provider, entry.model);
    if (!model) {
      ctx.ui.notify(
        `harpoon: ${entry.provider}/${entry.model} not found`,
        "error",
      );
      return;
    }
    if (!(await pi.setModel(model))) {
      ctx.ui.notify(
        `harpoon: no auth for ${entry.provider}/${entry.model}`,
        "error",
      );
      return;
    }
    if (entry.level) {
      pi.setThinkingLevel(entry.level);
      const effective = pi.getThinkingLevel();
      if (effective !== entry.level) {
        ctx.ui.notify(
          `harpoon: level "${entry.level}" clamped to "${effective}" by ${entry.model}`,
          "warning",
        );
      }
    }
  }

  async function select(ctx: ExtensionContext): Promise<void> {
    if (!ready(ctx)) return;
    const labels = entries.map(label);
    const choice = await ctx.ui.select("Harpoon model:", labels);
    if (!choice) return;
    await apply(entries[labels.indexOf(choice)], ctx);
  }

  async function cycle(ctx: ExtensionContext): Promise<void> {
    if (!ready(ctx)) return;
    await apply(entries[nextEntryIndex(entries, ctx.model?.id ?? "")], ctx);
  }

  pi.registerCommand("harpoon-select", {
    description: "Select a harpoon model entry",
    handler: async (_args, ctx) => select(ctx),
  });

  pi.registerShortcut(cycleKey as Parameters<typeof pi.registerShortcut>[0], {
    description: "Cycle harpoon models",
    handler: (ctx) => cycle(ctx),
  });
  if (config?.selectKey) {
    pi.registerShortcut(config.selectKey, {
      description: "Select harpoon model",
      handler: (ctx) => select(ctx),
    });
  }

  pi.on("session_start", async (_event, ctx) => {
    entries = [];
    if (!config) return;

    const invalid: string[] = [];
    for (const raw of config.models) {
      const parsed = parseEntry(raw);
      if ("error" in parsed) {
        invalid.push(`harpoon: ignored "${raw}" — ${parsed.error}`);
        continue;
      }
      if (!ctx.modelRegistry.find(parsed.provider, parsed.model)) {
        invalid.push(`harpoon: ignored "${raw}" — model not found`);
        continue;
      }
      entries.push(parsed);
    }
    if (invalid.length > 0) ctx.ui.notify(invalid.join("\n"), "warning");
  });
}
