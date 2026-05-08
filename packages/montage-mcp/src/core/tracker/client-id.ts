import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { randomUUID } from "node:crypto";

const UUID_V4_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

/**
 * Persistent anonymous client identifier. Lives next to the WAL queue.
 * One UUID per machine/install — no PII, used only for cohort statistics on the Track server.
 * Corrupted/non-UUID files are regenerated rather than reused (server rejects malformed ids).
 */
export function getOrCreateClientId(queuePath: string): string {
  const dir = dirname(queuePath);
  const idPath = join(dir, "client-id");
  try {
    if (existsSync(idPath)) {
      const existing = readFileSync(idPath, "utf-8").trim();
      if (UUID_V4_RE.test(existing)) return existing;
    }
  } catch {
    // fall through, regenerate
  }
  try {
    if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
    const id = randomUUID();
    writeFileSync(idPath, id + "\n", { mode: 0o600 });
    return id;
  } catch {
    // Filesystem refused — fall back to in-memory ephemeral id (lost on restart).
    return randomUUID();
  }
  // Unreachable — appease TS
  void homedir;
}
