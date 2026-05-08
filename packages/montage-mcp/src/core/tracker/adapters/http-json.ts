import type { TrackAdapter, TrackEvent } from "../types.js";
import { logDebug, logError } from "../../logger.js";
import { maskClientId, redactObject, sanitizeUrl } from "../../redact.js";

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
    const safeUrl = sanitizeUrl(this.url);
    for (const event of events) {
      const ctrl = new AbortController();
      const timer = setTimeout(() => ctrl.abort(), this.timeoutMs);
      try {
        // Serialize inside try so BigInt/circular-reference exceptions return
        // the partial `accepted` count instead of propagating — without this,
        // already-acknowledged events would be re-sent on retry.
        const body = JSON.stringify(event);
        const debugEvent = {
          ...event,
          clientId: maskClientId(event.clientId),
          params: event.params ? redactObject(event.params) : undefined,
        };
        logDebug("track POST request", {
          url: safeUrl,
          authorization: this.token ? "Bearer ***" : "(none)",
          payload: debugEvent,
        });
        const headers: Record<string, string> = {
          "Content-Type": "application/json",
        };
        if (this.token) headers.Authorization = `Bearer ${this.token}`;
        const res = await this.fetchImpl(this.url, {
          method: "POST",
          headers,
          body,
          signal: ctrl.signal,
        });
        if (!res.ok) {
          let bodyText = "";
          try {
            bodyText = (await res.text()).slice(0, 1000);
          } catch {
            // ignore body read errors
          }
          // Always-emit logError keeps minimal fields only — full (redacted) payload
          // is at logDebug so it's gated by MONTAGE_MCP_DEBUG=1.
          logError("track POST non-2xx", undefined, {
            url: safeUrl,
            status: res.status,
            toolName: event.toolName,
            transport: event.transport,
            response_body: bodyText,
          });
          logDebug("track POST non-2xx payload", {
            payload: {
              ...event,
              clientId: maskClientId(event.clientId),
              params: event.params ? redactObject(event.params) : undefined,
            },
          });
          return { accepted };
        }
        logDebug("track POST ok", {
          url: safeUrl,
          status: res.status,
          toolName: event.toolName,
        });
        accepted++;
      } catch (err) {
        logError("track POST threw", err, {
          url: safeUrl,
          toolName: event.toolName,
          transport: event.transport,
        });
        logDebug("track POST threw payload", {
          payload: {
            ...event,
            clientId: maskClientId(event.clientId),
            params: event.params ? redactObject(event.params) : undefined,
          },
        });
        return { accepted };
      } finally {
        clearTimeout(timer);
      }
    }
    return { accepted };
  }
}
