# `@wanteddev/montage-ios-mcp`

Model Context Protocol (MCP) server for the [Montage iOS Design System](https://github.com/wanteddev/montage-ios) by Wanted Lab.

Provides AI coding assistants with access to Montage component documentation, design tokens, icons, and Figma → SwiftUI mapping helpers used by the `figma-to-swiftui` workflow.

## Available Tools

| Tool | Description |
|---|---|
| `health_check` | Server liveness + version |
| `getting_started` | Installation & initial setup guide |
| `montage_coding_guidelines` | SwiftUI/Montage authoring rules |
| `list_components` | List all Montage components by category |
| `get_component` | Full API spec (initializers, enums, examples) for a component |
| `list_tokens` | List all design tokens (Color, Typography, Spacing, Shadow, Opacity) |
| `get_color_usage` | Color token usage guidelines |
| `list_icons` | List icons (with optional query filter) |
| `resolve_figma_component` | Resolve a Figma component name + variants to a Montage Swift snippet |
| `resolve_figma_token` | Resolve a Figma token name to a Montage Swift expression |
| `figma_to_swiftui_workflow` | Latest Figma → SwiftUI conversion procedure |

## Usage

### A. As a remote MCP

```bash
claude mcp add --transport sse montage-ios https://<your-host>/sse
```

Wanted Lab employees: see the internal Confluence/Slack for the official endpoint URL. External users should self-host (option B below).

### B. Self-hosted (local stdio)

Clone the repo, build once, and register the absolute path of `dist/stdio.js`.

```bash
git clone https://github.com/wanteddev/montage-ios.git
cd montage-ios/packages/montage-mcp
npm install
npm run build

# Register with Claude Code (use the absolute path)
claude mcp add montage-ios -- node /absolute/path/to/montage-ios/packages/montage-mcp/dist/stdio.js
```

> Re-run `npm run build` after pulling new changes. For live-reload during development use `npm run dev:stdio`.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `3000` | HTTP port (only used by `start:http`) |
| `MONTAGE_MCP_TRACK_URL` | (unset) | Telemetry ingest endpoint. Tracking disabled when unset |
| `MONTAGE_MCP_CLIENT_ID` | (unset) | Client identifier sent to the Track API. Required when `TRACK_URL` is set |
| `MONTAGE_MCP_TRACK_DISABLE` | (unset) | `1` to force-disable tracking |
| `MONTAGE_MCP_QUEUE_PATH` | scope-default | Local WAL queue file path for failed track events |
| `MONTAGE_MCP_DEBUG` | (unset) | `1` for stderr debug logging |

## Track API Specification

When `MONTAGE_MCP_TRACK_URL` is configured, every tool call is queued (WAL-backed) and flushed every 5 seconds via `POST` to that URL. The receiving endpoint must accept the following payload and respond with `202 Accepted`.

```http
POST <MONTAGE_MCP_TRACK_URL>
Content-Type: application/json
```

```json
{
  "name": "tool_call",
  "toolName": "get_component",
  "transport": "stdio",
  "platform": "ios",
  "clientId": "<MONTAGE_MCP_CLIENT_ID>",
  "timestamp": "2026-05-08T10:00:00.000Z",
  "params": { "componentName": "Button" },
  "metadata": {
    "duration_ms": 123,
    "status": "success",
    "version": "0.3.0",
    "error_class": null
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `name` | string | Always `"tool_call"` |
| `toolName` | string | Invoked MCP tool name |
| `transport` | `"stdio"` \| `"http"` | Active server transport |
| `platform` | string | Always `"ios"` |
| `clientId` | string | From `MONTAGE_MCP_CLIENT_ID`; used for auth on the Track side |
| `timestamp` | string | ISO 8601 |
| `params` | object | Caller arguments. Keys with `_` prefix (e.g. `_meta`) are stripped |
| `metadata.duration_ms` | number | Tool execution time |
| `metadata.status` | `"success"` \| `"error"` | |
| `metadata.version` | string | Server `package.json` version |
| `metadata.error_class` | string \| null | Present only when `status === "error"` |

Authentication is performed via `clientId`; no separate Bearer token is required.
