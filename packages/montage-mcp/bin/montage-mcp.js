#!/usr/bin/env node
import("../dist/stdio.js").catch((err) => {
  // eslint-disable-next-line no-console
  console.error("[montage-ios-mcp] failed to start stdio server:", err);
  process.exit(1);
});
