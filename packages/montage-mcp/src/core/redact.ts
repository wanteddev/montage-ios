/**
 * Logging redaction helpers.
 *
 * Logs may be aggregated (Backyard, Loki, etc.) where stderr is durable.
 * Sensitive identifiers and credentials must be masked before they leave the
 * process. These helpers are intentionally conservative — false positives are
 * cheaper than leaks.
 */

const SENSITIVE_KEY_RE = /(token|secret|password|api[-_]?key|authorization|cookie|email|phone|ssn)/i;

const REDACTED = "***REDACTED***";

export function redactObject(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(redactObject);
  if (!value || typeof value !== "object") return value;
  const obj = value as Record<string, unknown>;
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(obj)) {
    out[k] = SENSITIVE_KEY_RE.test(k) ? REDACTED : redactObject(v);
  }
  return out;
}

/** Strip query string and fragment from a URL — origin + path only. */
export function sanitizeUrl(url: string | null | undefined): string | undefined {
  if (!url) return undefined;
  return url.replace(/[?#].*$/, "");
}

/** Mask a client identifier — keep first 8 chars (or 4 for very short ids) + ellipsis. */
export function maskClientId(id: string | null | undefined): string | undefined {
  if (!id) return undefined;
  if (id.length <= 8) return id.slice(0, 4) + "…";
  return id.slice(0, 8) + "…";
}
