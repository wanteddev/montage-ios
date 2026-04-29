export interface TrackEvent {
  ts: string; // ISO 8601
  tool: string;
  argsHash: string; // 16 hex chars (sha256 prefix)
  durationMs: number;
  ok: boolean;
  errorClass?: string;
  version: string;
  platform: "ios";
  clientId: string;
}

export interface TrackAdapter {
  /** Send a batch. Resolve with the count accepted, or throw to leave the batch in queue. */
  send(events: TrackEvent[]): Promise<{ accepted: number }>;
}
