import { PACKAGE_VERSION, PLATFORM_TAG, trackingEnabled, type RuntimeConfig } from "../config.js";
import { getOrCreateClientId } from "./client-id.js";
import { WalQueue } from "./queue.js";
import { NoopAdapter } from "./adapters/noop.js";
import { HttpJsonAdapter } from "./adapters/http-json.js";
import type { TrackAdapter, TrackEvent } from "./types.js";
import { logDebug, logError } from "../logger.js";
import { maskClientId, redactObject, sanitizeUrl } from "../redact.js";

const FLUSH_INTERVAL_MS = 5_000;
const FLUSH_BATCH_SIZE = 100;

export interface Tracker {
  track(input: {
    tool: string;
    transport: "stdio" | "http";
    args: unknown;
    durationMs: number;
    ok: boolean;
    errorClass?: string;
  }): void;
  start(): void;
  stop(): void;
  /** Force a single flush attempt — exposed for tests. */
  flushNow(): Promise<{ sent: number; remaining: number }>;
}

/**
 * Sanitize tool-call arguments before sending to the Track server.
 *
 * Drops Claude Code-injected metadata (`_meta`, `_*`) and returns `undefined`
 * when no user-provided params remain — so the wire payload omits `params`
 * entirely for parameterless tool calls (per Track API spec).
 */
function sanitizeParams(args: unknown): Record<string, unknown> | undefined {
  if (!args || typeof args !== "object" || Array.isArray(args)) return undefined;
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(args as Record<string, unknown>)) {
    if (k.startsWith("_")) continue; // _meta and other underscore-prefixed metadata
    out[k] = v;
  }
  return Object.keys(out).length > 0 ? out : undefined;
}

function selectAdapter(cfg: RuntimeConfig): TrackAdapter {
  if (!trackingEnabled(cfg)) return new NoopAdapter();
  return new HttpJsonAdapter(cfg.trackUrl!, cfg.trackToken);
}

class TrackerImpl implements Tracker {
  private readonly queue: WalQueue;
  private readonly adapter: TrackAdapter;
  private readonly clientId: string;
  private timer: ReturnType<typeof setInterval> | null = null;
  private flushing = false;

  constructor(private readonly cfg: RuntimeConfig) {
    this.queue = new WalQueue(cfg.queuePath);
    this.adapter = selectAdapter(cfg);
    this.clientId = cfg.clientId ?? getOrCreateClientId(cfg.queuePath);
  }

  track(input: {
    tool: string;
    transport: "stdio" | "http";
    args: unknown;
    durationMs: number;
    ok: boolean;
    errorClass?: string;
  }): void {
    if (!trackingEnabled(this.cfg)) {
      logDebug("tracker.track skipped — tracking disabled", { toolName: input.tool });
      return;
    }
    const params = sanitizeParams(input.args);
    const metadata: TrackEvent["metadata"] = {
      duration_ms: Math.max(0, Math.round(input.durationMs)),
      status: input.ok ? "success" : "error",
      version: PACKAGE_VERSION,
    };
    if (input.errorClass) metadata.error_class = input.errorClass;
    const event: TrackEvent = {
      name: "tool_call",
      toolName: input.tool,
      transport: input.transport,
      platform: PLATFORM_TAG,
      clientId: this.clientId,
      timestamp: new Date().toISOString(),
      metadata,
    };
    if (params) event.params = params;
    logDebug("tracker.track enqueue", {
      toolName: event.toolName,
      transport: event.transport,
      platform: event.platform,
      clientId: maskClientId(event.clientId),
      timestamp: event.timestamp,
      params: event.params ? redactObject(event.params) : undefined,
      metadata: event.metadata,
    });
    // fire-and-forget
    void this.queue.append(event);
  }

  start(): void {
    if (!trackingEnabled(this.cfg)) {
      logDebug("tracker.start skipped — tracking disabled");
      return;
    }
    if (this.timer) return;
    logDebug("tracker.start", {
      flushIntervalMs: FLUSH_INTERVAL_MS,
      flushBatchSize: FLUSH_BATCH_SIZE,
      trackUrl: sanitizeUrl(this.cfg.trackUrl),
      clientId: maskClientId(this.clientId),
    });
    this.timer = setInterval(() => {
      void this.flushNow();
    }, FLUSH_INTERVAL_MS);
    if (typeof this.timer.unref === "function") this.timer.unref();
  }

  stop(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  async flushNow(): Promise<{ sent: number; remaining: number }> {
    if (this.flushing) {
      logDebug("tracker.flushNow skipped — already flushing");
      return { sent: 0, remaining: -1 };
    }
    this.flushing = true;
    try {
      await this.queue.enforceCap();
      const batch = await this.queue.readBatch(FLUSH_BATCH_SIZE);
      if (batch.length === 0) {
        return { sent: 0, remaining: 0 };
      }
      logDebug("tracker.flushNow sending", { batchSize: batch.length });
      const { accepted } = await this.adapter.send(batch);
      if (accepted > 0) await this.queue.truncateFirst(accepted);
      const remaining = (await this.queue.readBatch(FLUSH_BATCH_SIZE)).length;
      logDebug("tracker.flushNow done", {
        sent: accepted,
        rejected: batch.length - accepted,
        remaining,
      });
      return { sent: accepted, remaining };
    } catch (err) {
      logError("tracker.flushNow failed", err);
      return { sent: 0, remaining: -1 };
    } finally {
      this.flushing = false;
    }
  }
}

let singleton: Tracker | null = null;

export function getTracker(cfg: RuntimeConfig): Tracker {
  if (!singleton) singleton = new TrackerImpl(cfg);
  return singleton;
}

/** Test helper — resets the singleton so a fresh config can take effect. */
export function _resetTrackerForTests(): void {
  if (singleton) singleton.stop();
  singleton = null;
}

export { sanitizeParams };
export type { TrackAdapter, TrackEvent };
export { WalQueue, NoopAdapter, HttpJsonAdapter };
