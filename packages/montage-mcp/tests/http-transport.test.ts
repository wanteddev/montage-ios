import { describe, it, expect, beforeAll, afterAll } from "vitest";
import type { AddressInfo } from "node:net";
import type { Server } from "node:http";
import { createApp } from "../src/http-app.js";
import { loadConfig, PACKAGE_NAME } from "../src/core/config.js";

const PROTOCOL_VERSION = "2025-06-18";
const JSON_AND_SSE = "application/json, text/event-stream";

let server: Server;
let baseUrl: string;

/**
 * A Streamable HTTP POST answers with either a plain JSON body or a short-lived
 * SSE stream (the SDK prefers SSE). Normalize both into the JSON-RPC payload.
 */
async function readJsonRpc(res: Response): Promise<Record<string, unknown>> {
  const text = await res.text();
  const contentType = res.headers.get("content-type") ?? "";
  if (contentType.includes("text/event-stream")) {
    const dataLine = text
      .split("\n")
      .map((line) => line.trim())
      .find((line) => line.startsWith("data:"));
    expect(dataLine, `no SSE data frame in response: ${text}`).toBeDefined();
    return JSON.parse(dataLine!.slice("data:".length).trim());
  }
  return JSON.parse(text);
}

function post(body: unknown, sessionId?: string): Promise<Response> {
  return fetch(`${baseUrl}/mcp`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      accept: JSON_AND_SSE,
      ...(sessionId ? { "mcp-session-id": sessionId } : {}),
    },
    body: JSON.stringify(body),
  });
}

beforeAll(async () => {
  const config = loadConfig({ MONTAGE_MCP_TRACK_DISABLE: "1" } as NodeJS.ProcessEnv);
  const app = createApp(config);
  server = await new Promise<Server>((resolve) => {
    const s = app.listen(0, () => resolve(s));
  });
  baseUrl = `http://127.0.0.1:${(server.address() as AddressInfo).port}`;
});

afterAll(async () => {
  await new Promise<void>((resolve) => server.close(() => resolve()));
});

describe("Streamable HTTP transport (POST/GET/DELETE /mcp)", () => {
  it("completes initialize → tools/list → tools/call and terminates the session", async () => {
    // initialize
    const initRes = await post({
      jsonrpc: "2.0",
      id: 1,
      method: "initialize",
      params: {
        protocolVersion: PROTOCOL_VERSION,
        capabilities: {},
        clientInfo: { name: "vitest", version: "0.0.0" },
      },
    });
    expect(initRes.status).toBe(200);
    const sessionId = initRes.headers.get("mcp-session-id");
    expect(sessionId).toBeTruthy();
    const initBody = await readJsonRpc(initRes);
    expect((initBody.result as Record<string, any>).serverInfo.name).toBe(PACKAGE_NAME);

    // notifications/initialized — required before regular requests
    const notifyRes = await post(
      { jsonrpc: "2.0", method: "notifications/initialized" },
      sessionId!,
    );
    expect(notifyRes.status).toBe(202);
    await notifyRes.text();

    // tools/list
    const listRes = await post({ jsonrpc: "2.0", id: 2, method: "tools/list" }, sessionId!);
    expect(listRes.status).toBe(200);
    const listBody = await readJsonRpc(listRes);
    const toolNames = (listBody.result as Record<string, any>).tools.map(
      (t: { name: string }) => t.name,
    );
    expect(toolNames).toContain("health_check");
    expect(toolNames).toContain("list_components");

    // tools/call
    const callRes = await post(
      {
        jsonrpc: "2.0",
        id: 3,
        method: "tools/call",
        params: { name: "health_check", arguments: {} },
      },
      sessionId!,
    );
    expect(callRes.status).toBe(200);
    const callBody = await readJsonRpc(callRes);
    const result = callBody.result as Record<string, any>;
    expect(result.isError).toBeFalsy();
    expect(JSON.parse(result.content[0].text).status).toBe("ok");

    // DELETE terminates the session, and the id stops resolving afterwards
    const deleteRes = await fetch(`${baseUrl}/mcp`, {
      method: "DELETE",
      headers: { "mcp-session-id": sessionId! },
    });
    expect(deleteRes.status).toBeLessThan(300);
    await deleteRes.text();

    const afterDelete = await post({ jsonrpc: "2.0", id: 4, method: "tools/list" }, sessionId!);
    expect(afterDelete.status).toBe(404);
    await afterDelete.text();
  });

  it("rejects a non-initialize POST without a session id", async () => {
    const res = await post({ jsonrpc: "2.0", id: 1, method: "tools/list" });
    expect(res.status).toBe(400);
    const body = await readJsonRpc(res);
    expect(body.error).toBeDefined();
  });

  it("rejects a POST carrying an unknown session id", async () => {
    const res = await post({ jsonrpc: "2.0", id: 1, method: "tools/list" }, "does-not-exist");
    expect(res.status).toBe(404);
    await res.text();
  });

  it("answers a malformed JSON body with a JSON-RPC parse error", async () => {
    const res = await fetch(`${baseUrl}/mcp`, {
      method: "POST",
      headers: { "content-type": "application/json", accept: JSON_AND_SSE },
      body: '{"jsonrpc":"2.0",',
    });
    expect(res.status).toBe(400);
    const body = await readJsonRpc(res);
    expect((body.error as Record<string, unknown>).code).toBe(-32700);
  });

  it("rejects GET /mcp without a session id", async () => {
    const res = await fetch(`${baseUrl}/mcp`, {
      method: "GET",
      headers: { accept: "text/event-stream" },
    });
    expect(res.status).toBe(400);
    await res.text();
  });
});

describe("legacy SSE transport (regression)", () => {
  it("serves the endpoint handshake on GET /sse", async () => {
    const controller = new AbortController();
    const res = await fetch(`${baseUrl}/sse`, {
      headers: { accept: "text/event-stream" },
      signal: controller.signal,
    });
    expect(res.status).toBe(200);
    expect(res.headers.get("content-type")).toContain("text/event-stream");

    const reader = res.body!.getReader();
    const { value } = await reader.read();
    const chunk = new TextDecoder().decode(value);
    expect(chunk).toContain("event: endpoint");
    expect(chunk).toContain("/messages?sessionId=");

    await reader.cancel();
    controller.abort();
  });

  it("rejects POST /messages without a sessionId", async () => {
    const res = await fetch(`${baseUrl}/messages`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ jsonrpc: "2.0", id: 1, method: "tools/list" }),
    });
    expect(res.status).toBe(400);
    await res.text();
  });
});

describe("service endpoints", () => {
  it("serves /healthz", async () => {
    const res = await fetch(`${baseUrl}/healthz`);
    expect(res.status).toBe(200);
    const body = (await res.json()) as Record<string, unknown>;
    expect(body.status).toBe("ok");
    expect(body.name).toBe(PACKAGE_NAME);
  });

  it("advertises the Streamable HTTP endpoint on the index page", async () => {
    const res = await fetch(`${baseUrl}/`);
    expect(res.status).toBe(200);
    const html = await res.text();
    expect(html).toContain("/mcp");
    expect(html).toContain("--transport http");
  });
});
