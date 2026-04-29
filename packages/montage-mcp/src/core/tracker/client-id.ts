import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { randomUUID } from "node:crypto";

/**
 * Persistent anonymous client identifier. Lives next to the WAL queue.
 * One UUID per machine/install — no PII, used only for cohort statistics on the Track server.
 */
export function getOrCreateClientId(queuePath: string): string {
  const dir = dirname(queuePath);
  const idPath = join(dir, "client-id");
  try {
    if (existsSync(idPath)) {
      const existing = readFileSync(idPath, "utf-8").trim();
      if (existing) return existing;
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
