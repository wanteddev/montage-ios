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
claude mcp add --transport http montage-ios https://<your-host>/mcp
```

The legacy HTTP+SSE transport (`--transport sse`, `https://<your-host>/sse`) is still served for backward compatibility, but it is deprecated in the MCP spec and unsupported by some clients — prefer Streamable HTTP for new setups.

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
| `MONTAGE_MCP_DATA_URL` | `https://raw.githubusercontent.com/wanteddev/montage-ios/main/packages/montage-mcp/data` | Base URL of the `data/` tree fetched at runtime. `https` only (plain `http://localhost` and `http://127.0.0.1` are allowed for testing). Other values log a warning and fall back to the default |
| `MONTAGE_MCP_DATA_REFRESH_SEC` | `600` | Remote data refresh interval in seconds. `0` disables remote loading (bundled data only). Invalid values fall back to the default |
| `MONTAGE_MCP_AUTH` | (unset) | `google` enables Google OAuth on the HTTP transport. See [Authentication](#authentication-http-opt-in) |

### Remote data

The server starts from the `data/` bundled with the package, then fetches `components.json`, `tokens.json`, `icons.json`, `figma-mapping.json`, and `markdown/*.md` from `MONTAGE_MCP_DATA_URL` once right after startup and every `MONTAGE_MCP_DATA_REFRESH_SEC` afterwards. Startup does not wait for it.

- JSON is replaced only after it passes parsing, a minimal schema check, and a format version check. The format version is the `schema` field (`version` for `figma-mapping.json`) and must equal the bundled value exactly. On a mismatch the file is not replaced, and the file name with the bundled/remote values is logged.
- The four JSON files reference each other, so they are replaced together only when all four pass. If any fails, all JSON keeps its current value. Markdown is replaced per file; only the failing file keeps its current value.
- When the same failure cause repeats, only the first occurrence is logged as an error and later ones drop to debug. The count resets once the file recovers.
- Documentation changes reach the server on the next refresh without a redeploy. Commits that only touch `data/` do not trigger the deploy workflow.
- The `data` field of the `health_check` response shows the source (`bundled`/`remote`), base URL, last success time (`lastSuccessAt`, when all 8 files succeeded), the files that failed in the last attempt (`failedFiles`), and the files that validated but were held back because another JSON file failed (`heldBackFiles`).

> **Bump the schema number when you change the data format.** A PR that changes the structure of the JSON produced by `scripts/build_mcp_data.js` (adding, removing, or changing the meaning of fields) increments that file's `schema` (`version` for `figma-mapping.json`). With a different number, already-deployed servers ignore the new format and keep serving bundled data until the new code is deployed. Without the bump, older servers would read a format they don't understand.

### Authentication (HTTP, opt-in)

With `MONTAGE_MCP_AUTH=google` the server adds Google OAuth the same way the montage-web MCP does. It acts as the MCP OAuth authorization server, delegates login to Google (`wantedlab.com` accounts only), and verifies the issued Firebase ID token as the Bearer token. Client registrations and refresh tokens are stored in Firestore (`clients`, `refreshTokens` collections).

- Protected: `/mcp` (POST/GET/DELETE), `/sse`, `/messages`. `/` and `/healthz` stay public.
- Added routes: `/.well-known/oauth-authorization-server`, `/.well-known/oauth-protected-resource`, `/authorize`, `/token`, `/register`, `/oauth/consent`, `/oauth/google/callback`.
- `/authorize` does not redirect straight to Google. It first shows a consent page with the client name and redirect URI (host highlighted). Approving continues to Google sign-in; denying returns `error=access_denied` to the redirect URI. The approve/deny POST must come from the same origin (`Origin`/`Referer`, `Sec-Fetch-Site`) and carry the `SameSite=Strict` cookie (`__Host-mcp_consent`) the consent page set in the browser.
- Token checks: email ends with `@wantedlab.com`, `email_verified` is true, and the token was issued through Google sign-in. Token exchanges also require the Google ID token's `hd` to be `wantedlab.com`.
- MCP sessions (Streamable HTTP and SSE) are bound to the user who opened them. Another user presenting the same session id gets 404.
- The authenticated email (lowercased) is sent as the Track event's `deviceId`.
- Startup fails with an error when any required variable is missing or `MONTAGE_MCP_AUTH` is anything other than `google`.
- Not applied to the stdio transport.
- `firebase-admin` is an `optionalDependencies` entry. If auth is on but the module is missing (e.g. `npm install --omit=optional`), startup fails with an error.
- At startup the server writes one `INFO startup` line to stderr with auth and remote data on/off, regardless of `MONTAGE_MCP_DEBUG`.

| Variable | Required | Description |
|---|---|---|
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | Yes | Google OAuth client. Register `<MONTAGE_MCP_PUBLIC_URL>/oauth/google/callback` as an authorized redirect URI |
| `FIREBASE_API_KEY` | Yes | Web API key used to exchange the Google ID token for a Firebase ID token |
| `FIREBASE_PROJECT_ID` / `FIREBASE_CLIENT_EMAIL` / `FIREBASE_PRIVATE_KEY` | Yes | Firebase Admin service account. Literal `\n` in the private key is converted to newlines |
| `MONTAGE_MCP_PUBLIC_URL` | Yes | Public URL of the server (e.g. `https://montage-ios-mcp.example.com`). Base for the OAuth issuer and callback URL. Must be `https` unless localhost. Must match the host users actually open in the browser (the consent page's CSP and Origin check are based on it) |
| `FIREBASE_DATABASE_ID` | No | Firestore database ID. Defaults to `montage-storage` |
| `MONTAGE_MCP_TRUST_PROXY` | No | Express `trust proxy` hop count. Defaults to `1`. Match your ingress so the per-IP rate limit on OAuth endpoints keys on the real client IP. Startup fails on a non-integer or negative value |

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
| `deviceId` | string | Authenticated user email (lowercased). Present only on HTTP requests with `MONTAGE_MCP_AUTH=google` |
| `timestamp` | string | ISO 8601 |
| `params` | object | Caller arguments. Keys with `_` prefix (e.g. `_meta`) are stripped |
| `metadata.duration_ms` | number | Tool execution time |
| `metadata.status` | `"success"` \| `"error"` | |
| `metadata.version` | string | Server `package.json` version |
| `metadata.error_class` | string \| null | Present only when `status === "error"` |

Authentication is performed via `clientId`; no separate Bearer token is required.
