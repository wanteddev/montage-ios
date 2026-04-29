import { createHash } from "node:crypto";
import { PACKAGE_VERSION, PLATFORM_TAG, trackingEnabled, type RuntimeConfig } from "../config.js";
import { getOrCreateClientId } from "./client-id.js";
import { WalQueue } from "./queue.js";
import { NoopAdapter } from "./adapters/noop.js";
import { HttpJsonAdapter } from "./adapters/http-json.js";
import type { TrackAdapter, TrackEvent } from "./types.js";

const FLUSH_INTERVAL_MS = 5_000;
const FLUSH_BATCH_SIZE = 100;

export interface Tracker {
  track(input: {
    tool: string;
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

function argsHashOf(args: unknown): string {
  let json: string;
  try {
    json = JSON.stringify(args ?? {});
  } catch {
    json = "[unserializable]";
  }
  return createHash("sha256").update(json).digest("hex").slice(0, 16);
}

function selectAdapter(cfg: RuntimeConfig): TrackAdapter {
  if (!trackingEnabled(cfg)) return new NoopAdapter();
  return new HttpJsonAdapter(cfg.trackUrl!, cfg.trackToken!);
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
    this.clientId = getOrCreateClientId(cfg.queuePath);
  }

  track(input: {
    tool: string;
    args: unknown;
    durationMs: number;
    ok: boolean;
    errorClass?: string;
  }): void {
    if (!trackingEnabled(this.cfg)) return; // skip even queueing when disabled
    const event: TrackEvent = {
      ts: new Date().toISOString(),
      tool: input.tool,
      argsHash: argsHashOf(input.args),
      durationMs: Math.max(0, Math.round(input.durationMs)),
      ok: input.ok,
      version: PACKAGE_VERSION,
      platform: PLATFORM_TAG,
      clientId: this.clientId,
    };
    if (input.errorClass) event.errorClass = input.errorClass;
    // fire-and-forget
    void this.queue.append(event);
  }

  start(): void {
    if (!trackingEnabled(this.cfg)) return;
    if (this.timer) return;
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
    if (this.flushing) return { sent: 0, remaining: -1 };
    this.flushing = true;
    try {
      await this.queue.enforceCap();
      const batch = await this.queue.readBatch(FLUSH_BATCH_SIZE);
      if (batch.length === 0) return { sent: 0, remaining: 0 };
      const { accepted } = await this.adapter.send(batch);
      if (accepted > 0) await this.queue.truncateFirst(accepted);
      const remaining = (await this.queue.readBatch(FLUSH_BATCH_SIZE)).length;
      return { sent: accepted, remaining };
    } catch {
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

export type { TrackAdapter, TrackEvent };
export { WalQueue, NoopAdapter, HttpJsonAdapter };
