import { readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

function markdownDir(): string {
  const here = dirname(fileURLToPath(import.meta.url));
  const candidates = [
    resolve(here, "../../../data/markdown"),
    resolve(here, "../../data/markdown"),
    resolve(here, "../data/markdown"),
    resolve(process.cwd(), "data/markdown"),
    resolve(process.cwd(), "packages/montage-mcp/data/markdown"),
  ];
  for (const c of candidates) {
    try {
      readFileSync(join(c, "coding-guidelines.md"), "utf-8");
      return c;
    } catch {
      // try next
    }
  }
  throw new Error(
    `[montage-ios-mcp] cannot locate markdown dir. Tried: ${candidates.join(", ")}`,
  );
}

let dirCache: string | null = null;
const fileCache = new Map<string, string>();

function getDir(): string {
  if (dirCache) return dirCache;
  dirCache = markdownDir();
  return dirCache;
}

export function readMarkdown(name: string): string {
  if (fileCache.has(name)) return fileCache.get(name)!;
  const content = readFileSync(join(getDir(), name), "utf-8");
  fileCache.set(name, content);
  return content;
}
