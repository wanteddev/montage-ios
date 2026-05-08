import { homedir } from "node:os";
import { join } from "node:path";

export const PACKAGE_NAME = "@wanteddev/montage-ios-mcp";
export const PACKAGE_VERSION = "0.3.0";
export const PLATFORM_TAG = "ios";

export interface RuntimeConfig {
  trackUrl: string | null;
  trackToken: string | null;
  trackDisabled: boolean;
  clientId: string | null;
  queuePath: string;
  debug: boolean;
  port: number;
}

const DEFAULT_QUEUE_FILENAME = "queue.jsonl";

function defaultQueuePath(): string {
  // Container/server scope can override via MONTAGE_MCP_QUEUE_PATH (e.g. /data/queue.jsonl).
  return join(homedir(), ".montage-mcp", DEFAULT_QUEUE_FILENAME);
}

function parsePort(raw: string | undefined): number {
  if (raw === undefined || raw.trim() === "") return 3000;
  const n = Number(raw);
  if (Number.isInteger(n) && n >= 1 && n <= 65535) return n;
  return 3000;
}

export function loadConfig(env: NodeJS.ProcessEnv = process.env): RuntimeConfig {
  const trackUrlRaw = env.MONTAGE_MCP_TRACK_URL?.trim();
  const trackTokenRaw = env.MONTAGE_MCP_TRACK_TOKEN?.trim();
  const clientIdRaw = env.MONTAGE_MCP_CLIENT_ID?.trim();
  const disabled = env.MONTAGE_MCP_TRACK_DISABLE === "1";

  const trackUrl = trackUrlRaw && trackUrlRaw.length > 0 ? trackUrlRaw : null;
  const clientId = clientIdRaw && clientIdRaw.length > 0 ? clientIdRaw : null;

  // Tracking on but no client id → fail fast so misconfigured installs don't
  // silently accumulate events the server will reject (HTTP 400 invalid client id).
  if (!disabled && trackUrl !== null && clientId === null) {
    throw new Error(
      "MONTAGE_MCP_TRACK_URL is set but MONTAGE_MCP_CLIENT_ID is missing. " +
        "Set MONTAGE_MCP_CLIENT_ID, or set MONTAGE_MCP_TRACK_DISABLE=1 to disable tracking.",
    );
  }

  return {
    trackUrl,
    trackToken: trackTokenRaw && trackTokenRaw.length > 0 ? trackTokenRaw : null,
    trackDisabled: disabled,
    clientId,
    queuePath: env.MONTAGE_MCP_QUEUE_PATH?.trim() || defaultQueuePath(),
    debug: env.MONTAGE_MCP_DEBUG === "1",
    port: parsePort(env.PORT),
  };
}

export function trackingEnabled(cfg: RuntimeConfig): boolean {
  return !cfg.trackDisabled && cfg.trackUrl !== null;
}
