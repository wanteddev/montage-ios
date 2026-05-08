/**
 * Track API event shape — matches the Wanted Track server spec:
 * POST /track  Content-Type: application/json
 * {
 *   "name": "tool_call",
 *   "toolName": "...",
 *   "transport": "http" | "stdio",
 *   "platform": "ios",
 *   "clientId": "...",
 *   "timestamp": "2026-04-30T10:00:00.000Z",
 *   "params": { ... },          // omitted when the tool call had no params
 *   "metadata": { ... }         // duration_ms, status, error_class, version, etc.
 * }
 */
export interface TrackEvent {
  name: "tool_call";
  toolName: string;
  transport: "stdio" | "http";
  platform: "ios";
  clientId: string;
  timestamp: string;
  params?: Record<string, unknown>;
  metadata: {
    duration_ms: number;
    status: "success" | "error";
    error_class?: string;
    version: string;
  };
}

export interface TrackAdapter {
  /** Send a batch. Resolve with the count accepted, or throw to leave the batch in queue. */
  send(events: TrackEvent[]): Promise<{ accepted: number }>;
}
