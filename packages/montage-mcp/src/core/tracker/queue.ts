import { existsSync, mkdirSync, statSync } from "node:fs";
import { appendFile, readFile, writeFile } from "node:fs/promises";
import { dirname } from "node:path";
import type { TrackEvent } from "./types.js";
import { logError } from "../logger.js";

const MAX_FILE_BYTES = 10 * 1024 * 1024; // 10 MB cap before FIFO eviction

export class WalQueue {
  private writeChain: Promise<void> = Promise.resolve();
  constructor(private readonly path: string) {
    const dir = dirname(this.path);
    if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
  }

  /** Append a single event durably. Serialized via an internal promise chain. */
  async append(event: TrackEvent): Promise<void> {
    const line = JSON.stringify(event) + "\n";
    this.writeChain = this.writeChain.then(() =>
      appendFile(this.path, line, "utf-8").catch((err) => {
        // Disk error — drop event but surface for debugging; tracking must never break tool calls.
        logError("queue.append failed", err, { path: this.path });
      }),
    );
    return this.writeChain;
  }

  /** Read up to `limit` events. Returns empty array if file missing/unreadable. */
  async readBatch(limit = 100): Promise<TrackEvent[]> {
    try {
      const text = await readFile(this.path, "utf-8");
      const lines = text.split("\n").filter(Boolean);
      const out: TrackEvent[] = [];
      for (const ln of lines) {
        try {
          out.push(JSON.parse(ln) as TrackEvent);
          if (out.length >= limit) break;
        } catch {
          // skip malformed
        }
      }
      return out;
    } catch {
      return [];
    }
  }

  /** Drop the first `count` lines from the file (assumes those were sent successfully). */
  async truncateFirst(count: number): Promise<void> {
    if (count <= 0) return;
    this.writeChain = this.writeChain.then(async () => {
      try {
        const text = await readFile(this.path, "utf-8");
        const lines = text.split("\n");
        const remainder = lines.slice(count).join("\n");
        await writeFile(this.path, remainder, "utf-8");
      } catch {
        // ignore
      }
    });
    return this.writeChain;
  }

  /** FIFO-evict oldest half if file exceeds the size cap. */
  async enforceCap(): Promise<void> {
    this.writeChain = this.writeChain.then(async () => {
      try {
        const s = statSync(this.path);
        if (s.size <= MAX_FILE_BYTES) return;
        const text = await readFile(this.path, "utf-8");
        const lines = text.split("\n").filter(Boolean);
        const keep = lines.slice(Math.floor(lines.length / 2));
        await writeFile(this.path, keep.join("\n") + (keep.length ? "\n" : ""), "utf-8");
      } catch {
        // ignore
      }
    });
    return this.writeChain;
  }
}
