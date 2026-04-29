import { homedir } from "node:os";
import { join } from "node:path";

export const PACKAGE_NAME = "@wanteddev/montage-ios-mcp";
export const PACKAGE_VERSION = "0.1.0";
export const PLATFORM_TAG = "ios";

export interface RuntimeConfig {
  trackUrl: string | null;
  trackToken: string | null;
  trackDisabled: boolean;
  queuePath: string;
  debug: boolean;
  port: number;
}

const DEFAULT_QUEUE_FILENAME = "queue.jsonl";

function defaultQueuePath(): string {
  // Container/server scope can override via MONTAGE_MCP_QUEUE_PATH (e.g. /data/queue.jsonl).
  return join(homedir(), ".montage-mcp", DEFAULT_QUEUE_FILENAME);
}

export function loadConfig(env: NodeJS.ProcessEnv = process.env): RuntimeConfig {
  const trackUrlRaw = env.MONTAGE_MCP_TRACK_URL?.trim();
  const trackTokenRaw = env.MONTAGE_MCP_TRACK_TOKEN?.trim();
  const disabled = env.MONTAGE_MCP_TRACK_DISABLE === "1";

  return {
    trackUrl: trackUrlRaw && trackUrlRaw.length > 0 ? trackUrlRaw : null,
    trackToken: trackTokenRaw && trackTokenRaw.length > 0 ? trackTokenRaw : null,
    trackDisabled: disabled,
    queuePath: env.MONTAGE_MCP_QUEUE_PATH?.trim() || defaultQueuePath(),
    debug: env.MONTAGE_MCP_DEBUG === "1",
    port: Number(env.PORT ?? 3000) || 3000,
  };
}

export function trackingEnabled(cfg: RuntimeConfig): boolean {
  return !cfg.trackDisabled && cfg.trackUrl !== null && cfg.trackToken !== null;
}
