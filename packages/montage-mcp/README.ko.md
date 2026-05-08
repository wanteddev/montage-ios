# `@wanteddev/montage-ios-mcp`

Wanted Lab의 [Montage iOS 디자인 시스템](https://github.com/wanteddev/montage-ios)을 위한 MCP(Model Context Protocol) 서버.

`figma-to-swiftui` 워크플로우에서 사용하는 Montage 컴포넌트 문서, 디자인 토큰, 아이콘, Figma → SwiftUI 매핑 헬퍼를 AI 코딩 어시스턴트에 제공합니다.

## 제공 도구

| 도구 | 설명 |
|---|---|
| `health_check` | 서버 헬스체크 + 버전 |
| `getting_started` | 설치 · 초기 셋업 가이드 |
| `montage_coding_guidelines` | SwiftUI/Montage 작성 규칙 |
| `list_components` | 카테고리별 Montage 컴포넌트 목록 |
| `get_component` | 컴포넌트의 전체 API 스펙(이니셜라이저, enum, 예제) |
| `list_tokens` | 디자인 토큰 목록 (Color, Typography, Spacing, Shadow, Opacity) |
| `get_color_usage` | 컬러 토큰 사용 가이드 |
| `list_icons` | 아이콘 목록 (검색어 필터 지원) |
| `resolve_figma_component` | Figma 컴포넌트명 + variants → Montage Swift 스니펫 |
| `resolve_figma_token` | Figma 토큰명 → Montage Swift 표현식 |
| `figma_to_swiftui_workflow` | 최신 Figma → SwiftUI 변환 절차서 |

## 사용 방법

### A. 원격 MCP로 사용

```bash
claude mcp add --transport sse montage-ios https://<your-host>/sse
```

Wanted Lab 구성원은 사내 Confluence/Slack에서 공식 엔드포인트 URL을 확인하세요. 외부 사용자는 아래 B 옵션으로 self-host 하세요.

### B. Self-hosted (로컬 stdio)

레포를 clone해 1회 빌드한 뒤 `dist/stdio.js`의 절대 경로로 등록합니다.

```bash
git clone https://github.com/wanteddev/montage-ios.git
cd montage-ios/packages/montage-mcp
npm install
npm run build

# Claude Code에 등록 (절대 경로 사용)
claude mcp add montage-ios -- node /절대경로/montage-ios/packages/montage-mcp/dist/stdio.js
```

> 코드 변경 후에는 `npm run build`를 다시 실행해야 반영됩니다. 개발 중 실시간 반영이 필요하면 `npm run dev:stdio`를 사용하세요.

## 환경변수

| 변수 | 기본값 | 설명 |
|---|---|---|
| `PORT` | `3000` | HTTP 포트 (`start:http`에서만 사용) |
| `MONTAGE_MCP_TRACK_URL` | (unset) | 텔레메트리 수집 엔드포인트. 미설정 시 트래킹 비활성화 |
| `MONTAGE_MCP_CLIENT_ID` | (unset) | Track API에 전송하는 클라이언트 식별자. `TRACK_URL` 설정 시 필수 |
| `MONTAGE_MCP_TRACK_DISABLE` | (unset) | `1`이면 트래킹 강제 비활성화 |
| `MONTAGE_MCP_QUEUE_PATH` | scope-default | 트래킹 실패 이벤트 보존용 로컬 WAL 큐 경로 |
| `MONTAGE_MCP_DEBUG` | (unset) | `1`이면 stderr 디버그 로그 활성화 |

## Track API 스펙

`MONTAGE_MCP_TRACK_URL`이 설정되면 모든 도구 호출은 WAL 큐에 적재된 뒤 5초마다 일괄로 해당 URL에 `POST`됩니다. 수신 엔드포인트는 다음 페이로드를 받아 `202 Accepted`로 응답해야 합니다.

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

| 필드 | 타입 | 비고 |
|---|---|---|
| `name` | string | 항상 `"tool_call"` |
| `toolName` | string | 호출된 MCP 도구명 |
| `transport` | `"stdio"` \| `"http"` | 현재 서버 전송 방식 |
| `platform` | string | 항상 `"ios"` |
| `clientId` | string | `MONTAGE_MCP_CLIENT_ID` 값. Track 서버 측 인증 식별자 |
| `timestamp` | string | ISO 8601 |
| `params` | object | 호출 인자. `_` prefix 키(예: `_meta`)는 자동 제거 |
| `metadata.duration_ms` | number | 도구 실행 시간 |
| `metadata.status` | `"success"` \| `"error"` | |
| `metadata.version` | string | 서버 `package.json` 버전 |
| `metadata.error_class` | string \| null | `status === "error"` 일 때만 포함 |

인증은 `clientId`로 수행되며 별도 Bearer 토큰은 필요하지 않습니다.
