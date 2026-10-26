---
name: montage-swiftui
description: Guide for building SwiftUI UI with Montage (Wanted Design System for iOS). Triggers on SwiftUI screen/component work, design tokens (color, typography, spacing, shadow, opacity), icons, and Figma-to-SwiftUI conversion in projects that import Montage.
---

# montage-swiftui

Applied automatically when building SwiftUI UI with Montage, the Wanted Design System for iOS.

## When to use

Apply this skill when any of the following is true:

- The project imports `Montage` (SwiftUI)
- Creating, editing, or looking up SwiftUI screens or components
- Styling with colors, typography, spacing, shadows, or opacity
- Finding or using icons
- Implementing a Figma design as SwiftUI code
- Answering questions about Montage iOS

## Instructions

The `montage-ios` MCP server is the single source of truth for the Montage API. Do not write Montage code from memory or by guessing: initializer labels, enum cases, and token names change between versions.

### 0. Verify the MCP server connection (required, first)

Call the `health_check` tool of the `montage-ios` MCP server.

- **Tool not found** (server not connected): tell the user and suggest running `/mcp` to connect `montage-ios`.
- **Authentication error**: tell the user that login is required. Running `/mcp` starts the login flow (@wantedlab.com Google account).
- **Other errors**: tell the user the server is unreachable and suggest retrying later.

If the check fails, stop and wait for the user.

### 1. Gather context in parallel

Always call, in parallel:

- `montage_coding_guidelines`: rules for SwiftUI code that uses Montage
- `list_components`: available components

Add in parallel when needed:

- `getting_started`: when adding Montage to a project for the first time
- `list_tokens`: when styling
- `get_color_usage`: when choosing colors
- `list_icons`: when icons are needed (pass `query` to narrow the list)

### 2. Use Montage components

- Prefer a Montage component over a standard SwiftUI view whenever one exists.
- Before writing a component, call `get_component` and use the exact initializer signature and enum cases it returns.
- Follow `montage_coding_guidelines`, especially the `Color` namespace rule: annotate SwiftUI color values as `SwiftUI.Color` in type positions.

### 3. Use design tokens, never hard-coded values

- No literal colors, font sizes, paddings, or shadow radii. Use the token expressions from `list_tokens` / `get_color_usage`.
- Icons go through `Image.icon(.<name>)` with names from `list_icons`.

### 4. Figma → SwiftUI

When the user gives a Figma URL or asks to convert a Figma design, call `figma_to_swiftui_workflow` first and follow the procedure it returns. It drives `resolve_figma_component`, `resolve_figma_token`, and `get_component` in the right order.
