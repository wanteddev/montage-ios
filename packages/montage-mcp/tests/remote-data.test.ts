import { describe, it, expect, beforeEach, afterEach, vi, type MockInstance } from "vitest";
import { loadConfig, DEFAULT_DATA_URL, DEFAULT_DATA_REFRESH_SEC } from "../src/core/config.js";
import {
  _resetJsonDataForTests,
  loadComponents,
  loadFigmaMapping,
  loadIcons,
  loadTokens,
} from "../src/core/data/index.js";
import { _resetMarkdownForTests, readMarkdown } from "../src/core/data/markdown.js";
import {
  REMOTE_DATA_FILES,
  _resetRemoteDataForTests,
  getRemoteDataStatus,
  refreshRemoteData,
  startRemoteDataRefresher,
} from "../src/core/data/remote.js";

const BASE = "https://example.test/data";

const REMOTE_COMPONENT = {
  slug: "remote-only",
  name: "RemoteOnly",
  category: "Remote",
  kind: "struct",
  declaration: "public struct RemoteOnly",
  summary: "from remote",
  initializers: [],
  nestedTypes: [],
};

/** Valid payloads for every remote file; individual tests override entries. */
function validPayloads(): Record<string, string> {
  return {
    "components.json": JSON.stringify({ schema: 1, components: [REMOTE_COMPONENT] }),
    "tokens.json": JSON.stringify({ schema: 1, tokens: { color: null } }),
    "icons.json": JSON.stringify({ schema: 1, count: 1, icons: ["remote.icon"] }),
    "figma-mapping.json": JSON.stringify({ version: 1, description: "", components: {}, tokens: {} }),
    "markdown/coding-guidelines.md": "# remote guidelines",
    "markdown/color-usage.md": "# remote color usage",
    "markdown/figma-to-swiftui-workflow.md": "# remote workflow",
    "markdown/getting-started.md": "# remote getting started",
  };
}

/** fetch mock that serves `payloads` by path; `null` → 404, `Error` → network failure. */
function fakeFetch(payloads: Record<string, string | null | Error>) {
  return vi.fn(async (input: string | URL | Request) => {
    const path = String(input).slice(BASE.length + 1);
    const body = payloads[path];
    if (body instanceof Error) throw body;
    if (body === undefined || body === null) return new Response("not found", { status: 404 });
    return new Response(body, { status: 200 });
  }) as unknown as typeof fetch & ReturnType<typeof vi.fn>;
}

function resetAll(): void {
  _resetJsonDataForTests();
  _resetMarkdownForTests();
  _resetRemoteDataForTests();
}

let stderr: MockInstance<typeof process.stderr.write>;

beforeEach(() => {
  resetAll();
  // Keep expected rejection logs out of the test output.
  stderr = vi.spyOn(process.stderr, "write").mockImplementation(() => true);
});

function stderrLines(): string[] {
  return stderr.mock.calls.map((c) => String(c[0]));
}

afterEach(() => {
  vi.restoreAllMocks();
  resetAll();
});

describe("remote data config", () => {
  it("defaults to the public GitHub data URL and a 600s refresh", () => {
    const cfg = loadConfig({});
    expect(cfg.dataUrl).toBe(DEFAULT_DATA_URL);
    expect(cfg.dataRefreshSec).toBe(DEFAULT_DATA_REFRESH_SEC);
  });

  it("accepts overrides and strips trailing slashes", () => {
    const cfg = loadConfig({
      MONTAGE_MCP_DATA_URL: "https://mirror.test/data/",
      MONTAGE_MCP_DATA_REFRESH_SEC: "0",
    } as NodeJS.ProcessEnv);
    expect(cfg.dataUrl).toBe("https://mirror.test/data");
    expect(cfg.dataRefreshSec).toBe(0);
  });

  it("falls back to defaults on invalid values", () => {
    const cfg = loadConfig({
      MONTAGE_MCP_DATA_URL: "not a url",
      MONTAGE_MCP_DATA_REFRESH_SEC: "-5",
    } as NodeJS.ProcessEnv);
    expect(cfg.dataUrl).toBe(DEFAULT_DATA_URL);
    expect(cfg.dataRefreshSec).toBe(DEFAULT_DATA_REFRESH_SEC);
    expect(loadConfig({ MONTAGE_MCP_DATA_REFRESH_SEC: "abc" } as NodeJS.ProcessEnv).dataRefreshSec).toBe(
      DEFAULT_DATA_REFRESH_SEC,
    );
    expect(loadConfig({ MONTAGE_MCP_DATA_URL: "ftp://x.test/data" } as NodeJS.ProcessEnv).dataUrl).toBe(
      DEFAULT_DATA_URL,
    );
  });

  it("only allows https, except plain http on loopback hosts", () => {
    const http = loadConfig({ MONTAGE_MCP_DATA_URL: "http://mirror.test/data" } as NodeJS.ProcessEnv);
    expect(http.dataUrl).toBe(DEFAULT_DATA_URL);
    expect(stderrLines().some((l) => l.includes("WARN") && l.includes("must use https"))).toBe(true);

    for (const local of ["http://localhost:8080/data", "http://127.0.0.1/data"]) {
      expect(loadConfig({ MONTAGE_MCP_DATA_URL: local } as NodeJS.ProcessEnv).dataUrl).toBe(local);
    }
  });
});

describe("refreshRemoteData", () => {
  it("replaces every cache when all files validate", async () => {
    const fetchImpl = fakeFetch(validPayloads());
    const result = await refreshRemoteData(BASE, { fetchImpl });

    expect(fetchImpl).toHaveBeenCalledTimes(REMOTE_DATA_FILES.length);
    expect(result.failed).toEqual([]);
    expect(result.updated.sort()).toEqual([...REMOTE_DATA_FILES].sort());
    expect(loadComponents().components.map((c) => c.name)).toEqual(["RemoteOnly"]);
    expect(loadIcons().icons).toEqual(["remote.icon"]);
    expect(readMarkdown("coding-guidelines.md")).toBe("# remote guidelines");

    const status = getRemoteDataStatus();
    expect(status.source).toBe("remote");
    expect(status.baseUrl).toBe(BASE);
    expect(status.lastSuccessAt).toMatch(/^\d{4}-\d{2}-\d{2}T/);
    expect(status.failedFiles).toEqual([]);
  });

  it("holds back every JSON index when one fails, but replaces valid markdown per file", async () => {
    const bundledComponents = loadComponents();
    const bundledTokens = loadTokens();
    const bundledIcons = loadIcons();
    const bundledGuidelines = readMarkdown("coding-guidelines.md");

    const fetchImpl = fakeFetch({
      ...validPayloads(),
      "tokens.json": "{ not json",
      "markdown/coding-guidelines.md": "   \n",
    });
    const result = await refreshRemoteData(BASE, { fetchImpl });

    expect(result.failed.sort()).toEqual(["markdown/coding-guidelines.md", "tokens.json"].sort());
    expect(result.heldBack.sort()).toEqual(["components.json", "figma-mapping.json", "icons.json"]);
    expect(getRemoteDataStatus().heldBackFiles).toEqual(["components.json", "icons.json", "figma-mapping.json"]);
    expect(result.updated.sort()).toEqual(
      ["markdown/color-usage.md", "markdown/figma-to-swiftui-workflow.md", "markdown/getting-started.md"],
    );
    // components/icons validated, but are held back with tokens.json.
    expect(loadComponents()).toBe(bundledComponents);
    expect(loadTokens()).toBe(bundledTokens);
    expect(loadIcons()).toBe(bundledIcons);
    expect(readMarkdown("coding-guidelines.md")).toBe(bundledGuidelines);
    expect(readMarkdown("color-usage.md")).toBe("# remote color usage");

    const status = getRemoteDataStatus();
    expect(status.source).toBe("remote");
    expect(status.lastSuccessAt).toBeNull();
    expect(status.failedFiles).toContain("tokens.json");
  });

  it("rejects JSON whose components array is missing", async () => {
    const bundledComponents = loadComponents();
    const result = await refreshRemoteData(BASE, {
      fetchImpl: fakeFetch({ ...validPayloads(), "components.json": JSON.stringify({ schema: 1 }) }),
    });
    expect(result.failed).toEqual(["components.json"]);
    expect(loadComponents()).toBe(bundledComponents);
  });

  it("rejects components missing fields that tools read", async () => {
    const bundledComponents = loadComponents();
    const { name: _name, ...noName } = REMOTE_COMPONENT;
    for (const broken of [
      noName,
      { ...REMOTE_COMPONENT, nestedTypes: [{ kind: "enum" }] },
      { ...REMOTE_COMPONENT, initializers: [null] },
      { ...REMOTE_COMPONENT, nestedTypes: [{ name: "X.Size", kind: "enum", caseSignatures: {} }] },
    ]) {
      const result = await refreshRemoteData(BASE, {
        fetchImpl: fakeFetch({
          ...validPayloads(),
          "components.json": JSON.stringify({ schema: 1, components: [broken] }),
        }),
      });
      expect(result.failed).toEqual(["components.json"]);
      expect(loadComponents()).toBe(bundledComponents);
    }
  });

  it("rejects incomplete token records but accepts null ones", async () => {
    const bundledTokens = loadTokens();
    const result = await refreshRemoteData(BASE, {
      fetchImpl: fakeFetch({ ...validPayloads(), "tokens.json": JSON.stringify({ schema: 1, tokens: { color: {} } }) }),
    });
    expect(result.failed).toEqual(["tokens.json"]);
    expect(loadTokens()).toBe(bundledTokens);
  });

  it("rejects icons that are not strings", async () => {
    const bundledIcons = loadIcons();
    const result = await refreshRemoteData(BASE, {
      fetchImpl: fakeFetch({ ...validPayloads(), "icons.json": JSON.stringify({ schema: 1, icons: ["ok", null] }) }),
    });
    expect(result.failed).toEqual(["icons.json"]);
    expect(loadIcons()).toBe(bundledIcons);
  });

  it("strips query and fragment from the reported base URL", async () => {
    await refreshRemoteData(`${BASE}?token=secret#x`, { fetchImpl: fakeFetch(validPayloads()) });
    expect(getRemoteDataStatus().baseUrl).toBe(BASE);
  });

  it("rejects JSON whose schema/version differs from the bundled copy and logs both values", async () => {
    const bundledComponents = loadComponents();
    const bundledMapping = loadFigmaMapping();
    for (const [file, body] of [
      ["components.json", JSON.stringify({ schema: 2, components: [REMOTE_COMPONENT] })],
      ["figma-mapping.json", JSON.stringify({ version: 2, description: "", components: {}, tokens: {} })],
    ] as const) {
      resetAll();
      const result = await refreshRemoteData(BASE, {
        fetchImpl: fakeFetch({ ...validPayloads(), [file]: body }),
      });
      expect(result.failed).toEqual([file]);
      const field = file === "components.json" ? "schema" : "version";
      const line = stderrLines().find((l) => l.includes(`${BASE}/${file}`));
      expect(line).toContain(`${field} mismatch (bundled=1, remote=2)`);
    }
    expect(loadComponents()).toEqual(bundledComponents);
    expect(loadFigmaMapping()).toEqual(bundledMapping);
  });

  it("logs a repeated failure cause once, and again after recovery", async () => {
    const offline: Record<string, Error> = {};
    for (const path of REMOTE_DATA_FILES) offline[path] = new TypeError("fetch failed");
    const errorsFor = (file: string) =>
      stderrLines().filter((l) => l.includes(" ERROR ") && l.includes(`${BASE}/${file}`)).length;

    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(offline) });
    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(offline) });
    expect(errorsFor("icons.json")).toBe(1);

    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(validPayloads()) });
    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(offline) });
    expect(errorsFor("icons.json")).toBe(2);
  });

  it("keeps the bundled data when the network fails", async () => {
    const bundledComponents = loadComponents();
    const bundledIcons = loadIcons();
    const payloads: Record<string, Error | null> = {};
    for (const path of REMOTE_DATA_FILES) payloads[path] = new TypeError("fetch failed");
    payloads["icons.json"] = null; // HTTP 404

    const result = await refreshRemoteData(BASE, { fetchImpl: fakeFetch(payloads) });

    expect(result.updated).toEqual([]);
    expect(result.failed).toHaveLength(REMOTE_DATA_FILES.length);
    expect(loadComponents()).toBe(bundledComponents);
    expect(loadIcons()).toBe(bundledIcons);
    const status = getRemoteDataStatus();
    expect(status.source).toBe("bundled");
    expect(status.lastSuccessAt).toBeNull();
    expect(status.lastAttemptAt).not.toBeNull();
  });

  it("keeps the last remote value when a later refresh fails", async () => {
    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(validPayloads()) });
    const firstSuccess = getRemoteDataStatus().lastSuccessAt;

    const failing: Record<string, Error> = {};
    for (const path of REMOTE_DATA_FILES) failing[path] = new TypeError("fetch failed");
    await refreshRemoteData(BASE, { fetchImpl: fakeFetch(failing) });

    expect(loadComponents().components.map((c) => c.name)).toEqual(["RemoteOnly"]);
    expect(getRemoteDataStatus().lastSuccessAt).toBe(firstSuccess);
  });
});

describe("startRemoteDataRefresher", () => {
  it("does not fetch when the refresh interval is 0", async () => {
    const fetchImpl = fakeFetch(validPayloads());
    const refresher = startRemoteDataRefresher({ dataUrl: BASE, dataRefreshSec: 0 }, { fetchImpl });
    await refresher.ready;
    refresher.stop();

    expect(fetchImpl).not.toHaveBeenCalled();
    const status = getRemoteDataStatus();
    expect(status.source).toBe("bundled");
    expect(status.baseUrl).toBeNull();
  });

  it("refreshes once immediately, then on every interval", async () => {
    vi.useFakeTimers();
    try {
      const fetchImpl = fakeFetch(validPayloads());
      const refresher = startRemoteDataRefresher({ dataUrl: BASE, dataRefreshSec: 60 }, { fetchImpl });
      await refresher.ready;
      expect(fetchImpl).toHaveBeenCalledTimes(REMOTE_DATA_FILES.length);

      await vi.advanceTimersByTimeAsync(60_000);
      expect(fetchImpl).toHaveBeenCalledTimes(REMOTE_DATA_FILES.length * 2);

      refresher.stop();
      await vi.advanceTimersByTimeAsync(60_000);
      expect(fetchImpl).toHaveBeenCalledTimes(REMOTE_DATA_FILES.length * 2);
      expect(getRemoteDataStatus().refreshIntervalSec).toBe(60);
    } finally {
      vi.useRealTimers();
    }
  });
});
