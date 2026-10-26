/**
 * Runtime refresh of the `data/` tree from a remote base URL (by default the
 * public GitHub repo), so documentation updates reach the server without a
 * redeploy.
 *
 * - The bundled `data/` stays the initial value and the fallback.
 * - Remote JSON is accepted only when its format version (`schema`, or
 *   `version` for figma-mapping.json) equals the bundled one, so a server
 *   built for format N never reads format N+1. Bump the number whenever the
 *   data format changes.
 * - The four JSON indexes reference each other (e.g. figma-mapping → component
 *   names), so they are replaced together or not at all. Markdown files are
 *   independent and are replaced one by one.
 * - Loaders in `./index.ts` / `./markdown.ts` stay synchronous — this module
 *   only swaps their caches.
 */
import type { RuntimeConfig } from "../config.js";
import { logDebug, logError } from "../logger.js";
import { sanitizeUrl } from "../redact.js";
import {
  readBundledJson,
  replaceJsonData,
  type JsonDataFile,
  type JsonDataFiles,
} from "./index.js";
import { replaceMarkdown } from "./markdown.js";

const FETCH_TIMEOUT_MS = 10_000;
// setInterval overflows past 2^31-1 ms (~24.8 days) and would fire immediately.
const MAX_INTERVAL_MS = 2_147_483_647;

type Validator = (value: Record<string, unknown>) => boolean;

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function isStringList(value: unknown): boolean {
  return Array.isArray(value) && value.every((s) => typeof s === "string");
}

/** `initializers`, `modifiers` and the like are rendered via `m.signature`. */
function isSignatureList(value: unknown): boolean {
  return Array.isArray(value) && value.every((m) => isObject(m) && typeof m.signature === "string");
}

function isOptional(value: unknown, check: (v: unknown) => boolean): boolean {
  return value === undefined || check(value);
}

/** `nestedTypes` entries as read by `get_component`, `list_tokens` and the Figma mapping. */
function isNestedTypeList(value: unknown): boolean {
  return (
    Array.isArray(value) &&
    value.every(
      (n) =>
        isObject(n) &&
        typeof n.name === "string" &&
        typeof n.kind === "string" &&
        isOptional(n.cases, isStringList) &&
        isOptional(n.caseSignatures, isStringList) &&
        isOptional(n.initializers, isSignatureList) &&
        isOptional(n.staticMethods, isSignatureList) &&
        isOptional(n.staticProperties, isSignatureList) &&
        isOptional(n.modifiers, isSignatureList),
    )
  );
}

function isComponentRecord(c: unknown): boolean {
  return (
    isObject(c) &&
    typeof c.slug === "string" &&
    typeof c.name === "string" &&
    isSignatureList(c.initializers) &&
    isOptional(c.modifiers, isSignatureList) &&
    isOptional(c.staticMembers, isSignatureList) &&
    isNestedTypeList(c.nestedTypes)
  );
}

/** A token entry may be `null` (category without a source file). */
function isTokenRecord(rec: unknown): boolean {
  if (rec === null) return true;
  return (
    isObject(rec) &&
    typeof rec.name === "string" &&
    typeof rec.kind === "string" &&
    Array.isArray(rec.sections) &&
    rec.sections.every((s) => isObject(s) && isStringList(s.identifiers)) &&
    isNestedTypeList(rec.nestedTypes)
  );
}

interface JsonSpec {
  /** Field carrying the format version, compared against the bundled copy. */
  versionField: "schema" | "version";
  validate: Validator;
}

const JSON_SPECS: { [K in JsonDataFile]: JsonSpec } = {
  "components.json": {
    versionField: "schema",
    validate: (v) =>
      Array.isArray(v.components) && v.components.length > 0 && v.components.every(isComponentRecord),
  },
  "tokens.json": {
    versionField: "schema",
    validate: (v) => isObject(v.tokens) && Object.values(v.tokens).every(isTokenRecord),
  },
  "icons.json": {
    versionField: "schema",
    validate: (v) => isStringList(v.icons) && (v.icons as unknown[]).length > 0,
  },
  "figma-mapping.json": {
    versionField: "version",
    validate: (v) => isObject(v.components) && isObject(v.tokens),
  },
};

const JSON_FILES = Object.keys(JSON_SPECS) as JsonDataFile[];

const MARKDOWN_FILES = [
  "coding-guidelines.md",
  "color-usage.md",
  "figma-to-swiftui-workflow.md",
  "getting-started.md",
] as const;

/** Remote paths relative to the data base URL, in a stable order. */
export const REMOTE_DATA_FILES: readonly string[] = [
  ...JSON_FILES,
  ...MARKDOWN_FILES.map((name) => `markdown/${name}`),
];

export interface RemoteDataStatus {
  /** `remote` once at least one file currently served came from the remote base URL. */
  source: "bundled" | "remote";
  /** `null` when remote loading is disabled (`MONTAGE_MCP_DATA_REFRESH_SEC=0`). */
  baseUrl: string | null;
  refreshIntervalSec: number;
  /** Last refresh in which every file was fetched, validated, and applied. */
  lastSuccessAt: string | null;
  lastAttemptAt: string | null;
  /** Files that failed in the last attempt (they keep their previous value). */
  failedFiles: string[];
  /**
   * JSON files that validated in the last attempt but were not applied because
   * another JSON file failed (the indexes are only replaced together).
   */
  heldBackFiles: string[];
}

export interface RefreshResult {
  updated: string[];
  failed: string[];
  heldBack: string[];
}

export interface RefreshOptions {
  fetchImpl?: typeof fetch;
  timeoutMs?: number;
}

const status: RemoteDataStatus = {
  source: "bundled",
  baseUrl: null,
  refreshIntervalSec: 0,
  lastSuccessAt: null,
  lastAttemptAt: null,
  failedFiles: [],
  heldBackFiles: [],
};

let refreshing = false;
const bundledVersions = new Map<JsonDataFile, unknown>();
/** Last failure cause logged per file — repeats drop to debug until the file recovers. */
const lastFailureCause = new Map<string, string>();

export function getRemoteDataStatus(): RemoteDataStatus {
  return {
    ...status,
    // health_check returns this to clients; drop query/fragment like the startup logs do.
    baseUrl: sanitizeUrl(status.baseUrl) ?? null,
    failedFiles: [...status.failedFiles],
    heldBackFiles: [...status.heldBackFiles],
  };
}

function bundledVersionOf(name: JsonDataFile): unknown {
  if (!bundledVersions.has(name)) {
    const bundled = readBundledJson(name) as unknown as Record<string, unknown>;
    bundledVersions.set(name, bundled[JSON_SPECS[name].versionField]);
  }
  return bundledVersions.get(name);
}

async function fetchText(
  url: string,
  fetchImpl: typeof fetch,
  timeoutMs: number,
): Promise<string> {
  const res = await fetchImpl(url, { signal: AbortSignal.timeout(timeoutMs) });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.text();
}

function parseJson(name: JsonDataFile, text: string): JsonDataFiles[JsonDataFile] {
  const value: unknown = JSON.parse(text);
  if (!isObject(value)) throw new Error("schema validation failed: not an object");
  const spec = JSON_SPECS[name];
  const bundled = bundledVersionOf(name);
  const remote = value[spec.versionField];
  // A bundled copy without a numeric version can't pin anything — refuse rather than guess.
  if (typeof bundled !== "number") {
    throw new Error(`bundled ${name} has no numeric ${spec.versionField} (${JSON.stringify(bundled)})`);
  }
  if (remote !== bundled) {
    throw new Error(
      `${spec.versionField} mismatch (bundled=${JSON.stringify(bundled)}, remote=${JSON.stringify(remote)})`,
    );
  }
  if (!spec.validate(value)) throw new Error("schema validation failed");
  return value as unknown as JsonDataFiles[JsonDataFile];
}

function parseMarkdown(text: string): string {
  if (text.trim().length === 0) throw new Error("empty markdown");
  return text;
}

function errorMessage(err: unknown): string {
  return err instanceof Error ? `${err.name}: ${err.message}` : String(err);
}

/** Log a file failure once per distinct cause; repeats go to debug (offline stdio stays quiet). */
function reportFailure(path: string, url: string, err: unknown): void {
  const cause = errorMessage(err);
  if (lastFailureCause.get(path) === cause) {
    logDebug("remote data file rejected again — keeping current value", { url, cause });
    return;
  }
  lastFailureCause.set(path, cause);
  logError("remote data file rejected — keeping current value", err, { url });
}

/**
 * Fetch every data file once and replace what validates (JSON as a group,
 * markdown per file). Never throws — failures are logged and reported.
 */
export async function refreshRemoteData(
  baseUrl: string,
  opts: RefreshOptions = {},
): Promise<RefreshResult> {
  if (refreshing) {
    logDebug("remote data refresh skipped — already refreshing");
    return { updated: [], failed: [], heldBack: [] };
  }
  refreshing = true;
  const fetchImpl = opts.fetchImpl ?? fetch;
  const timeoutMs = opts.timeoutMs ?? FETCH_TIMEOUT_MS;
  const updated: string[] = [];
  const failed: string[] = [];
  const heldBack: string[] = [];
  try {
    const parsedJson = new Map<JsonDataFile, JsonDataFiles[JsonDataFile]>();
    await Promise.all(
      REMOTE_DATA_FILES.map(async (path) => {
        const url = `${baseUrl}/${path}`;
        try {
          const text = await fetchText(url, fetchImpl, timeoutMs);
          if (path.startsWith("markdown/")) {
            replaceMarkdown(path.slice("markdown/".length), parseMarkdown(text));
            updated.push(path);
          } else {
            parsedJson.set(path as JsonDataFile, parseJson(path as JsonDataFile, text));
          }
          lastFailureCause.delete(path);
        } catch (err) {
          failed.push(path);
          reportFailure(path, url, err);
        }
      }),
    );

    if (parsedJson.size === JSON_FILES.length) {
      for (const [name, value] of parsedJson) {
        replaceJsonData(name, value as JsonDataFiles[typeof name]);
        updated.push(name);
      }
    } else if (parsedJson.size > 0) {
      heldBack.push(...parsedJson.keys());
      logDebug("remote JSON held back — the indexes are only replaced together", {
        valid: [...parsedJson.keys()],
        failed: failed.filter((p) => !p.startsWith("markdown/")),
      });
    }
  } finally {
    refreshing = false;
  }

  const now = new Date().toISOString();
  status.baseUrl = baseUrl;
  status.lastAttemptAt = now;
  status.failedFiles = REMOTE_DATA_FILES.filter((p) => failed.includes(p));
  status.heldBackFiles = REMOTE_DATA_FILES.filter((p) => heldBack.includes(p));
  if (updated.length > 0) status.source = "remote";
  if (failed.length === 0) status.lastSuccessAt = now;
  logDebug("remote data refresh done", { baseUrl, updated: updated.length, failed });
  return { updated, failed, heldBack };
}

export interface RemoteDataRefresher {
  stop(): void;
  /** Resolves when the initial refresh attempt finishes (immediately when disabled). */
  ready: Promise<void>;
}

/**
 * Start periodic refresh per config. The first attempt runs immediately in the
 * background so it never blocks server startup. `dataRefreshSec === 0` disables
 * remote loading entirely (no fetch is made).
 */
export function startRemoteDataRefresher(
  cfg: Pick<RuntimeConfig, "dataUrl" | "dataRefreshSec">,
  opts: RefreshOptions = {},
): RemoteDataRefresher {
  if (cfg.dataRefreshSec === 0) {
    logDebug("remote data disabled — serving bundled data only");
    return { stop: () => {}, ready: Promise.resolve() };
  }
  status.baseUrl = cfg.dataUrl;
  status.refreshIntervalSec = cfg.dataRefreshSec;
  const intervalMs = Math.min(cfg.dataRefreshSec * 1000, MAX_INTERVAL_MS);
  logDebug("remote data refresher start", { baseUrl: cfg.dataUrl, intervalMs });

  const ready = refreshRemoteData(cfg.dataUrl, opts).then(() => undefined);
  const timer = setInterval(() => {
    void refreshRemoteData(cfg.dataUrl, opts);
  }, intervalMs);
  if (typeof timer.unref === "function") timer.unref();
  return { stop: () => clearInterval(timer), ready };
}

/** Test helper — resets status. Pair with the loaders' cache reset helpers. */
export function _resetRemoteDataForTests(): void {
  status.source = "bundled";
  status.baseUrl = null;
  status.refreshIntervalSec = 0;
  status.lastSuccessAt = null;
  status.lastAttemptAt = null;
  status.failedFiles = [];
  status.heldBackFiles = [];
  refreshing = false;
  bundledVersions.clear();
  lastFailureCause.clear();
}
