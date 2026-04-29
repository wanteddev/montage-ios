import type { TrackAdapter, TrackEvent } from "../types.js";

/**
 * Generic HTTP/JSON adapter that POSTs `{events: [...]}` with a Bearer token.
 *
 * NOTE: The exact wire format expected by the Wanted Track server is being finalized by the
 * Montage team. When the spec lands, either:
 *   - replace this body shape, OR
 *   - add a sibling adapter (e.g. `WantedTrackAdapter`) and switch in src/core/tracker/index.ts.
 *
 * This adapter throws on any non-2xx so the WAL queue keeps the batch and retries later.
 */
export class HttpJsonAdapter implements TrackAdapter {
  constructor(
    private readonly url: string,
    private readonly token: string,
    private readonly fetchImpl: typeof fetch = fetch,
    private readonly timeoutMs: number = 5000,
  ) {}

  async send(events: TrackEvent[]): Promise<{ accepted: number }> {
    if (events.length === 0) return { accepted: 0 };
    const ctrl = new AbortController();
    const timer = setTimeout(() => ctrl.abort(), this.timeoutMs);
    try {
      const res = await this.fetchImpl(this.url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${this.token}`,
        },
        body: JSON.stringify({ events }),
        signal: ctrl.signal,
      });
      if (!res.ok) {
        throw new Error(`Track server responded ${res.status}`);
      }
      return { accepted: events.length };
    } finally {
      clearTimeout(timer);
    }
  }
}
