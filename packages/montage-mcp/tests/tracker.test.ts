import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { mkdtempSync, rmSync, existsSync, readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  WalQueue,
  HttpJsonAdapter,
  NoopAdapter,
  type TrackEvent,
  type TrackAdapter,
} from "../src/core/tracker/index.js";

let tmp: string;
let queuePath: string;

beforeEach(() => {
  tmp = mkdtempSync(join(tmpdir(), "montage-mcp-test-"));
  queuePath = join(tmp, "queue.jsonl");
});
afterEach(() => {
  rmSync(tmp, { recursive: true, force: true });
});

function ev(tool: string, ok = true): TrackEvent {
  return {
    ts: new Date().toISOString(),
    tool,
    argsHash: "0".repeat(16),
    durationMs: 1,
    ok,
    version: "0.1.0",
    platform: "ios",
    clientId: "test-client",
  };
}

describe("WalQueue", () => {
  it("appends and reads back NDJSON events", async () => {
    const q = new WalQueue(queuePath);
    await q.append(ev("a"));
    await q.append(ev("b"));
    const batch = await q.readBatch(10);
    expect(batch.map((e) => e.tool)).toEqual(["a", "b"]);
  });

  it("truncateFirst drops the leading N events", async () => {
    const q = new WalQueue(queuePath);
    await q.append(ev("a"));
    await q.append(ev("b"));
    await q.append(ev("c"));
    await q.truncateFirst(2);
    const batch = await q.readBatch(10);
    expect(batch.map((e) => e.tool)).toEqual(["c"]);
  });

  it("returns empty when file is missing", async () => {
    const q = new WalQueue(queuePath);
    const batch = await q.readBatch(10);
    expect(batch).toEqual([]);
  });
});

describe("NoopAdapter", () => {
  it("accepts everything", async () => {
    const a = new NoopAdapter();
    const r = await a.send([ev("x"), ev("y")]);
    expect(r.accepted).toBe(2);
  });
});

describe("HttpJsonAdapter", () => {
  it("POSTs JSON body with Bearer token and returns accepted count on 2xx", async () => {
    const captured: { url: string; init: RequestInit } = {
      url: "",
      init: {} as RequestInit,
    };
    const fakeFetch = (async (url: string, init?: RequestInit) => {
      captured.url = String(url);
      captured.init = init ?? ({} as RequestInit);
      return new Response("{}", { status: 200 });
    }) as unknown as typeof fetch;
    const a = new HttpJsonAdapter("https://example/track", "tok-123", fakeFetch);
    const r = await a.send([ev("a"), ev("b")]);
    expect(r.accepted).toBe(2);
    expect(captured.url).toBe("https://example/track");
    expect((captured.init?.headers as Record<string, string>)["Authorization"]).toBe("Bearer tok-123");
    const body = JSON.parse(String(captured.init?.body));
    expect(body.events).toHaveLength(2);
    expect(body.events[0].tool).toBe("a");
  });

  it("throws on non-2xx so the queue retains the batch", async () => {
    const fakeFetch = (async () => new Response("nope", { status: 500 })) as unknown as typeof fetch;
    const a = new HttpJsonAdapter("https://example/track", "tok", fakeFetch);
    await expect(a.send([ev("a")])).rejects.toThrow(/500/);
  });
});

describe("Tracker integration (with mock adapter)", () => {
  it("flushes events and truncates the queue on success", async () => {
    const q = new WalQueue(queuePath);
    await q.append(ev("a"));
    await q.append(ev("b"));

    const sent: TrackEvent[][] = [];
    const adapter: TrackAdapter = {
      async send(events) {
        sent.push(events);
        return { accepted: events.length };
      },
    };

    const batch = await q.readBatch(100);
    const r = await adapter.send(batch);
    if (r.accepted > 0) await q.truncateFirst(r.accepted);

    expect(sent).toHaveLength(1);
    expect(sent[0]).toHaveLength(2);
    const remaining = await q.readBatch(100);
    expect(remaining).toEqual([]);
    if (existsSync(queuePath)) {
      expect(readFileSync(queuePath, "utf-8")).toBe("");
    }
  });
});
