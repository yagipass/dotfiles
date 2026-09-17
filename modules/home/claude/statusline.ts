#!/usr/bin/env bun

const RED = "\x1b[31m";
const GREEN = "\x1b[32m";
const YELLOW = "\x1b[33m";
const BLUE = "\x1b[34m";
const MAGENTA = "\x1b[35m";
const CYAN = "\x1b[36m";
const GRAY = "\x1b[90m";
const BOLD_PURPLE = "\x1b[1;35m";
const BOLD_CYAN = "\x1b[1;36m";
const RESET = "\x1b[0m";

interface StatuslineInput {
  model?: { display_name?: string };
  workspace?: { current_dir?: string; project_dir?: string };
  cwd?: string;
  context_window?: {
    context_window_size?: number;
    current_usage?: {
      input_tokens?: number;
      cache_creation_input_tokens?: number;
      cache_read_input_tokens?: number;
    } | null;
  };
  rate_limits?: {
    five_hour?: { used_percentage?: number };
    seven_day?: { used_percentage?: number };
  };
  cost?: { total_cost_usd?: number };
}

function usageColor(pct: number, base: string = CYAN): string {
  if (pct >= 80) return RED;
  if (pct >= 50) return YELLOW;
  return base;
}

function gauge(pct: number): string {
  const chars = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"];
  return chars[Math.min(Math.floor((pct * 8) / 100), 7)];
}

function shortenPath(path: string): string {
  const home = process.env.HOME;
  if (home && path.startsWith(home)) {
    path = `~${path.slice(home.length)}`;
  }
  const parts = path.split("/");
  return parts
    .map((part, i) => {
      if (i === parts.length - 1 || part === "" || part === "~") return part;
      return part.startsWith(".") ? part.slice(0, 2) : part.slice(0, 1);
    })
    .join("/");
}

function vscodeProjectUrl(path: string): string {
  const encoded = path.split("/").map(encodeURIComponent).join("/");
  return `vscode://file${encoded.endsWith("/") ? encoded : `${encoded}/`}`;
}

function osc8Link(url: string, label: string): string {
  return `\x1b]8;;${url}\x07${label}\x1b]8;;\x07`;
}

function usageSegment(label: string, pct: number, base?: string): string {
  const color = usageColor(pct, base);
  return `${GRAY}${label}${RESET} ${color}${gauge(pct)} ${pct}%${RESET}`;
}

function gitBranch(): string {
  try {
    const result = Bun.spawnSync(["git", "branch", "--show-current"], {
      stderr: "ignore",
    });
    return result.stdout.toString().trim();
  } catch {
    return "";
  }
}

const input: StatuslineInput = await Bun.stdin.json();
const segments: string[] = [];

function modelColor(name: string): string {
  if (name.includes("Fable")) return MAGENTA;
  if (name.includes("Opus")) return YELLOW;
  if (name.includes("Sonnet")) return BLUE;
  return "";
}

const model = input.model?.display_name;
if (model) {
  const color = modelColor(model);
  segments.push(color ? `${color}${model}${RESET}` : model);
}

const dir = input.workspace?.current_dir ?? input.cwd;
const projectDir = input.workspace?.project_dir ?? dir;
if (dir) {
  const label = `${BOLD_CYAN}${shortenPath(dir)}${RESET}`;
  segments.push(
    projectDir ? osc8Link(vscodeProjectUrl(projectDir), label) : label,
  );
}

const branch = gitBranch();
if (branch) segments.push(`${BOLD_PURPLE} ${branch}${RESET}`);

const usage = input.context_window?.current_usage;
const windowSize = input.context_window?.context_window_size;
if (usage && windowSize) {
  const current =
    (usage.input_tokens ?? 0) +
    (usage.cache_creation_input_tokens ?? 0) +
    (usage.cache_read_input_tokens ?? 0);
  segments.push(
    usageSegment("ctx", Math.round((current / windowSize) * 100), GREEN),
  );
}

const fiveHour = input.rate_limits?.five_hour?.used_percentage;
if (fiveHour != null) segments.push(usageSegment("5h", Math.round(fiveHour)));
const sevenDay = input.rate_limits?.seven_day?.used_percentage;
if (sevenDay != null) segments.push(usageSegment("7d", Math.round(sevenDay)));

const cost = input.cost?.total_cost_usd;
if (cost != null) segments.push(`$${cost.toFixed(2)}`);

console.log(segments.join(` ${GRAY}│${RESET} `));
