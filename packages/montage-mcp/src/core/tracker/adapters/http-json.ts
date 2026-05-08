import type { TrackAdapter, TrackEvent } from "../types.js";

/**
 * Wanted Track HTTP adapter.
 *
 * Wire format (per Track API spec):
 *   POST <trackUrl>
 *   Content-Type: application/json
 *   Body: a single TrackEvent JSON object (one POST per event).
 *
 * Behavior:
 *   - Iterates events in order; on the first non-2xx, returns the partial
 *     `accepted` count so the WAL queue keeps the *unsent remainder* for retry.
 *   - `accepted` is the count of events that returned 2xx before any failure;
 *     the caller (`flushNow`) truncates exactly that many leading entries.
 *     Returning (rather than throwing) the partial count prevents duplicate
 *     re-sends of already-acknowledged events on subsequent retries.
 *   - Bearer Authorization is added only when `token` is non-null/non-empty.
 *     The current spec does not require auth, so token may be `null`.
 */
export class HttpJsonAdapter implements TrackAdapter {
  constructor(
    private readonly url: string,
    private readonly token: string | null,
    private readonly fetchImpl: typeof fetch = fetch,
    private readonly timeoutMs: number = 5000,
  ) {}

  async send(events: TrackEvent[]): Promise<{ accepted: number }> {
    if (events.length === 0) return { accepted: 0 };
    let accepted = 0;
    for (const event of events) {
      const ctrl = new AbortController();
      const timer = setTimeout(() => ctrl.abort(), this.timeoutMs);
      try {
        const headers: Record<string, string> = {
          "Content-Type": "application/json",
        };
        if (this.token) headers.Authorization = `Bearer ${this.token}`;
        const res = await this.fetchImpl(this.url, {
          method: "POST",
          headers,
          body: JSON.stringify(event),
          signal: ctrl.signal,
        });
        if (!res.ok) {
          return { accepted };
        }
        accepted++;
      } finally {
        clearTimeout(timer);
      }
    }
    return { accepted };
  }
}
