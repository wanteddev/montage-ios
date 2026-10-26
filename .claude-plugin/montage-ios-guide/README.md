# Montage iOS Guide

A Claude Code plugin that bundles the Montage (Wanted Design System) iOS MCP server and a SwiftUI skill.

[English](./README.md) | [한국어](./README.ko.md)

## Installation

```bash
/plugin marketplace add wanteddev/montage-ios
```

```bash
/plugin install montage-ios-guide@montage-ios
```

After installing, connect the `montage-ios` server from `/mcp` and a login window opens.

## Features

### MCP Server

> **Note:** Requires signing in with a @wantedlab.com Google account.

| Tool | Description |
| --- | --- |
| `montage_coding_guidelines` | Montage SwiftUI coding guidelines |
| `getting_started` | Installation and initial setup guide |
| `list_components` | Component list, grouped by category |
| `get_component` | Full component API (initializers, variant/size/color enums) |
| `list_tokens` | Design tokens (Color, Typography, Spacing, Shadow, Opacity) |
| `get_color_usage` | Color token usage guide |
| `list_icons` | Icon names (`Image.icon(.<name>)`) |
| `figma_to_swiftui_workflow` | Procedure for turning a Figma design into Montage SwiftUI code |
| `resolve_figma_component` | Maps a Figma component name to a Montage initializer |
| `resolve_figma_token` | Maps a Figma token name to a Montage Swift expression |
| `health_check` | Server status and where its data comes from |

The server reads the docs straight from this repository's `main` branch, so doc updates show up without reinstalling the plugin.

### Skill: montage-swiftui

Applied automatically when working on SwiftUI in an iOS project that uses Montage.

**Triggers:**

- Working in a project that does `import Montage`
- Creating or editing SwiftUI screens or components
- Using design tokens such as colors, typography, or spacing
- Using icons
- Turning a Figma design into SwiftUI code

**Workflow:**

1. Verify the MCP server connection
2. Read the coding guidelines and the component list (required)
3. Look up the exact API of each component you use
4. Apply design tokens and icons
5. Follow the Figma → SwiftUI procedure when a Figma link is given
