import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { mkdtempSync, rmSync, existsSync, readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  WalQueue,
  HttpJsonAdapter,
  NoopAdapter,
  sanitizeParams,
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
    name: "tool_call",
    toolName: tool,
    transport: "stdio",
    platform: "ios",
    clientId: "test-client",
    timestamp: new Date().toISOString(),
    metadata: {
      duration_ms: 1,
      status: ok ? "success" : "error",
      version: "0.1.0",
    },
  };
}

describe("WalQueue", () => {
  it("appends and reads back NDJSON events", async () => {
    const q = new WalQueue(queuePath);
    await q.append(ev("a"));
    await q.append(ev("b"));
    const batch = await q.readBatch(10);
    expect(batch.map((e) => e.toolName)).toEqual(["a", "b"]);
  });

  it("truncateFirst drops the leading N events", async () => {
    const q = new WalQueue(queuePath);
    await q.append(ev("a"));
    await q.append(ev("b"));
    await q.append(ev("c"));
    await q.truncateFirst(2);
    const batch = await q.readBatch(10);
    expect(batch.map((e) => e.toolName)).toEqual(["c"]);
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

describe("HttpJsonAdapter (Track API spec)", () => {
  it("POSTs one JSON event per call and returns accepted count on 2xx", async () => {
    const captured: Array<{ url: string; init: RequestInit }> = [];
    const fakeFetch = (async (url: string, init?: RequestInit) => {
      captured.push({ url: String(url), init: init ?? ({} as RequestInit) });
      return new Response("{}", { status: 200 });
    }) as unknown as typeof fetch;
    const a = new HttpJsonAdapter("https://example/track", null, fakeFetch);
    const r = await a.send([ev("a"), ev("b")]);
    expect(r.accepted).toBe(2);
    expect(captured).toHaveLength(2);
    expect(captured[0]!.url).toBe("https://example/track");
    const body = JSON.parse(String(captured[0]!.init?.body));
    expect(body.name).toBe("tool_call");
    expect(body.toolName).toBe("a");
    expect(body.platform).toBe("ios");
    expect(body.transport).toBe("stdio");
    expect(body.metadata.status).toBe("success");
    // No Bearer header when token is null.
    expect((captured[0]!.init?.headers as Record<string, string>)["Authorization"]).toBeUndefined();
  });

  it("attaches Bearer Authorization when token is provided", async () => {
    let captured: Record<string, string> | undefined;
    const fakeFetch = (async (_url: string, init?: RequestInit) => {
      captured = (init?.headers as Record<string, string>) ?? {};
      return new Response("{}", { status: 200 });
    }) as unknown as typeof fetch;
    const a = new HttpJsonAdapter("https://example/track", "tok-123", fakeFetch);
    await a.send([ev("a")]);
    expect(captured?.["Authorization"]).toBe("Bearer tok-123");
  });

  it("stops on first non-2xx; returns partial accepted so caller can truncate", async () => {
    let calls = 0;
    const fakeFetch = (async () => {
      calls++;
      return calls === 2 ? new Response("nope", { status: 500 }) : new Response("{}", { status: 200 });
    }) as unknown as typeof fetch;
    const a = new HttpJsonAdapter("https://example/track", null, fakeFetch);
    const result = await a.send([ev("a"), ev("b"), ev("c")]);
    expect(result.accepted).toBe(1);
    expect(calls).toBe(2);
  });
});

describe("sanitizeParams", () => {
  it("returns undefined for empty/null input", () => {
    expect(sanitizeParams(undefined)).toBeUndefined();
    expect(sanitizeParams(null)).toBeUndefined();
    expect(sanitizeParams({})).toBeUndefined();
  });

  it("strips _meta and any underscore-prefixed Claude Code metadata", () => {
    const out = sanitizeParams({
      componentName: "Button",
      _meta: { progressToken: "abc" },
      _internal: 1,
    });
    expect(out).toEqual({ componentName: "Button" });
  });

  it("returns undefined when only metadata fields exist", () => {
    expect(sanitizeParams({ _meta: { x: 1 } })).toBeUndefined();
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
