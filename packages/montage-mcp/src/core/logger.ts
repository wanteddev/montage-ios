import { PACKAGE_NAME } from "./config.js";

/**
 * Stderr logger gated by `MONTAGE_MCP_DEBUG=1`.
 *
 * - `logDebug` is silent unless debug is enabled (call `configureLogger` once at boot).
 * - `logError` always emits, regardless of debug — tracking must surface failures.
 *
 * All writes go to stderr so stdio MCP transport (stdout) stays clean.
 */

let debugEnabled = false;

export function configureLogger(opts: { debug: boolean }): void {
  debugEnabled = opts.debug;
}

export function isDebugEnabled(): boolean {
  return debugEnabled;
}

function format(meta: Record<string, unknown> | undefined): string {
  if (!meta) return "";
  try {
    return " " + JSON.stringify(meta);
  } catch {
    return "";
  }
}

export function logDebug(msg: string, meta?: Record<string, unknown>): void {
  if (!debugEnabled) return;
  process.stderr.write(`[${PACKAGE_NAME}] ${msg}${format(meta)}\n`);
}

export function logError(msg: string, err?: unknown, meta?: Record<string, unknown>): void {
  let detail = "";
  if (err instanceof Error) {
    detail = ` — ${err.name}: ${err.message}`;
  } else if (err !== undefined) {
    detail = ` — ${String(err)}`;
  }
  process.stderr.write(`[${PACKAGE_NAME}] ERROR ${msg}${detail}${format(meta)}\n`);
}
