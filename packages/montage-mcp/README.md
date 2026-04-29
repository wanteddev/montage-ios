# `@wanteddev/montage-ios-mcp`

Model Context Protocol (MCP) server for the [Montage iOS Design System](https://github.com/wanteddev/montage-ios) by Wanted Lab.

Provides AI coding assistants with access to Montage component documentation, design tokens, icons, and Figma → SwiftUI mapping helpers used by the `figma-to-swiftui` workflow.

> Status: Phase 1 scaffolding. APIs and tools below are subject to change before `0.1.0` is published.

## Available Tools (planned MVP)

| Tool | Description |
|---|---|
| `health_check` | Server liveness + version |
| `getting_started` | Installation & initial setup guide |
| `montage_coding_guidelines` | SwiftUI/Montage authoring rules |
| `list_components` | List all Montage components by category |
| `get_component` | Get full API spec (initializers, enums, examples) for a component |
| `list_tokens` | List all design tokens (Color, Typography, Spacing, Shadow, Opacity) |
| `get_color_usage` | Color token usage guidelines |
| `list_icons` | List icons (with optional query filter) |
| `resolve_figma_component` | Resolve a Figma component name + variants to a Montage Swift snippet |
| `resolve_figma_token` | Resolve a Figma token name to a Montage Swift expression |

## Usage

### A. As a remote MCP

```bash
claude mcp add --transport sse montage-ios https://<your-host>/sse
```

Wanted Lab employees: see the internal Confluence/Slack for the official endpoint URL. External users should self-host (option C below).

### B. As a local stdio process (`npx`)

```bash
claude mcp add montage-ios -- npx -y @wanteddev/montage-ios-mcp@latest
```

### C. Self-hosted (any host)

```bash
git clone https://github.com/wanteddev/montage-ios
cd montage-ios/packages/montage-mcp
npm install
npm run build
npm run start:http   # listens on PORT (default 3000), exposes /sse
```

Then add it as a remote MCP using your own URL.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `3000` | HTTP port (Express server) |
| `MONTAGE_MCP_TRACK_URL` | (unset) | Telemetry ingest endpoint. Tracking disabled if unset |
| `MONTAGE_MCP_TRACK_TOKEN` | (unset) | Bearer token for telemetry. Required when URL is set |
| `MONTAGE_MCP_TRACK_DISABLE` | (unset) | `1` to force-disable tracking |
| `MONTAGE_MCP_QUEUE_PATH` | scope-default | Local WAL queue file path |
| `MONTAGE_MCP_DEBUG` | (unset) | `1` for stderr debug logging |

See [`.omc/plans/montage-mcp.md`](../../.omc/plans/montage-mcp.md) for the full design plan.
