# Montage iOS Guide

Montage(Wanted Design System) iOS MCP 서버와 SwiftUI skill이 포함된 Claude Code 플러그인입니다.

[English](./README.md) | [한국어](./README.ko.md)

## 설치

```bash
/plugin marketplace add wanteddev/montage-ios
```

```bash
/plugin install montage-ios-guide@montage-ios
```

설치 후 `/mcp`에서 `montage-ios` 서버에 연결하면 로그인 창이 열립니다.

## 기능

### MCP 서버

> **Note:** @wantedlab.com 구글 계정 로그인이 필요합니다.

| 도구 | 설명 |
| --- | --- |
| `montage_coding_guidelines` | Montage SwiftUI 코딩 가이드라인 조회 |
| `getting_started` | 설치와 초기 설정 가이드 조회 |
| `list_components` | 컴포넌트 목록 조회 (카테고리별) |
| `get_component` | 컴포넌트 상세 API 조회 (initializer, variant/size/color enum) |
| `list_tokens` | 디자인 토큰 목록 조회 (Color, Typography, Spacing, Shadow, Opacity) |
| `get_color_usage` | 색상 토큰 사용법 조회 |
| `list_icons` | 아이콘 목록 조회 (`Image.icon(.<name>)`) |
| `figma_to_swiftui_workflow` | Figma 디자인을 Montage SwiftUI 코드로 옮기는 절차 조회 |
| `resolve_figma_component` | Figma 컴포넌트 이름을 Montage initializer로 변환 |
| `resolve_figma_token` | Figma 토큰 이름을 Montage Swift 표현식으로 변환 |
| `health_check` | MCP 서버 상태와 데이터 출처 확인 |

문서는 이 레포의 `main` 브랜치에서 서버가 직접 받아오므로, 문서가 바뀌면 플러그인을 다시 설치하지 않아도 반영됩니다.

### Skill: montage-swiftui

Montage를 쓰는 iOS 프로젝트에서 SwiftUI 작업을 할 때 자동으로 적용되는 skill입니다.

**자동 트리거 조건:**

- `import Montage`를 쓰는 프로젝트에서 작업할 때
- SwiftUI 화면이나 컴포넌트를 만들거나 고칠 때
- 색상, 타이포그래피, 간격 같은 디자인 토큰을 쓸 때
- 아이콘을 쓸 때
- Figma 디자인을 SwiftUI 코드로 옮길 때

**워크플로우:**

1. MCP 서버 연결 확인
2. 코딩 가이드라인과 컴포넌트 목록 확인 (필수)
3. 쓸 컴포넌트의 정확한 API 확인
4. 디자인 토큰과 아이콘 적용
5. Figma 링크가 있으면 Figma → SwiftUI 절차를 따름
