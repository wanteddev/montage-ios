import type { TrackAdapter, TrackEvent } from "../types.js";

/** Sink adapter — accepts all events without sending anywhere. Used when tracking is disabled. */
export class NoopAdapter implements TrackAdapter {
  async send(events: TrackEvent[]): Promise<{ accepted: number }> {
    return { accepted: events.length };
  }
}
