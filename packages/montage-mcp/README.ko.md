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
claude mcp add --transport http montage-ios https://<your-host>/mcp
```

레거시 HTTP+SSE 전송(`--transport sse`, `https://<your-host>/sse`)도 하위 호환을 위해 계속 제공되지만, MCP 스펙에서 폐기됐고 일부 클라이언트는 지원하지 않습니다. 새로 설정할 때는 Streamable HTTP를 사용하세요.

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
| `MONTAGE_MCP_DATA_URL` | `https://raw.githubusercontent.com/wanteddev/montage-ios/main/packages/montage-mcp/data` | 런타임에 받아올 `data/` 디렉터리의 base URL. `https`만 허용(테스트용 `http://localhost`, `http://127.0.0.1`은 예외). 그 밖의 값이면 경고 로그를 남기고 기본값 사용 |
| `MONTAGE_MCP_DATA_REFRESH_SEC` | `600` | 원격 데이터 갱신 주기(초). `0`이면 원격 로딩을 끄고 번들 데이터만 사용. 잘못된 값이면 기본값 사용 |
| `MONTAGE_MCP_AUTH` | (unset) | `google`이면 HTTP 전송에 Google OAuth 인증 적용. 아래 [인증](#인증-http-옵트인) 참고 |

### 원격 데이터

서버는 패키지에 번들된 `data/`로 시작하고, 기동 직후 1회와 이후 `MONTAGE_MCP_DATA_REFRESH_SEC`마다 `MONTAGE_MCP_DATA_URL`에서 `components.json`, `tokens.json`, `icons.json`, `figma-mapping.json`, `markdown/*.md`를 받아옵니다. 기동은 이 요청을 기다리지 않습니다.

- JSON은 파싱, 최소 스키마 검사, 포맷 버전 검사를 모두 통과해야 교체합니다. 포맷 버전은 `schema` 필드(`figma-mapping.json`은 `version`)이고, 번들된 값과 정확히 같아야 합니다. 다르면 교체하지 않고 파일명과 번들/원격 값을 로그로 남깁니다.
- JSON 4개는 서로 참조하므로 4개가 모두 통과했을 때만 한꺼번에 교체합니다. 하나라도 실패하면 JSON은 전부 기존 값을 유지합니다. markdown은 파일 단위로 교체하고, 실패한 파일만 기존 값을 유지합니다.
- 같은 원인의 실패가 이어지면 첫 회만 에러 로그를 남기고 이후는 debug 로그로 내립니다. 해당 파일이 복구되면 다시 처음부터 셉니다.
- 문서 변경은 재배포 없이 다음 갱신 주기에 반영됩니다. `data/`만 바뀐 커밋으로는 배포 워크플로가 돌지 않습니다.
- `health_check` 응답의 `data` 필드에서 출처(`bundled`/`remote`), base URL, 마지막 성공 시각(`lastSuccessAt`, 8개 파일 모두 성공한 시각), 직전 시도에서 실패한 파일(`failedFiles`), 검증은 통과했지만 다른 JSON 실패로 교체를 보류한 파일(`heldBackFiles`)을 확인할 수 있습니다.

> **data 포맷을 바꾸면 schema 번호를 올린다.** `scripts/build_mcp_data.js`가 만드는 JSON의 구조(필드 추가·삭제·의미 변경)를 바꾸는 PR은 해당 파일의 `schema`(`figma-mapping.json`은 `version`)를 1 올립니다. 번호가 다르면 이미 배포된 서버는 새 포맷을 받지 않고 번들 데이터를 계속 쓰다가, 새 코드가 배포되면 그때부터 새 포맷을 받습니다. 번호를 올리지 않으면 구버전 서버가 모르는 포맷을 읽게 됩니다.

### 인증 (HTTP, 옵트인)

`MONTAGE_MCP_AUTH=google`이면 montage-web MCP와 같은 방식의 Google OAuth를 붙입니다. 이 서버가 MCP OAuth 인가 서버 역할을 하고, 로그인은 Google(`wantedlab.com` 계정만)에 위임하며, 발급한 Firebase ID 토큰을 Bearer 토큰으로 검증합니다. 클라이언트 등록 정보와 refresh token은 Firestore(`clients`, `refreshTokens` 컬렉션)에 저장합니다.

- 인증 대상: `/mcp`(POST/GET/DELETE), `/sse`, `/messages`. `/`, `/healthz`는 공개.
- 추가 경로: `/.well-known/oauth-authorization-server`, `/.well-known/oauth-protected-resource`, `/authorize`, `/token`, `/register`, `/oauth/consent`, `/oauth/google/callback`.
- `/authorize`는 바로 Google로 보내지 않고 클라이언트 이름과 redirect URI(호스트 강조)를 보여주는 동의 페이지를 먼저 띄웁니다. 승인하면 Google 로그인으로 넘어가고, 거부하면 redirect URI로 `error=access_denied`를 돌려줍니다. 승인/거부 POST는 같은 origin(`Origin`/`Referer`, `Sec-Fetch-Site`)에서 와야 하고, 동의 페이지가 브라우저에 심은 `SameSite=Strict` 쿠키(`__Host-mcp_consent`)가 있어야 합니다.
- 토큰 검증 조건: email이 `@wantedlab.com`, `email_verified`가 true, Google 로그인으로 발급된 토큰. 토큰 교환 시에는 Google ID 토큰의 `hd`가 `wantedlab.com`인지도 확인합니다.
- MCP 세션(Streamable HTTP, SSE)은 만든 사용자에게 묶입니다. 다른 사용자가 같은 세션 ID로 요청하면 404를 받습니다.
- 인증된 사용자 email(소문자)을 Track 이벤트의 `deviceId`로 보냅니다.
- 필수 변수가 하나라도 없거나 `MONTAGE_MCP_AUTH`가 `google` 외의 값이면 기동 시 에러를 내고 종료합니다.
- stdio 전송에는 적용되지 않습니다.
- `firebase-admin`은 `optionalDependencies`입니다. 인증을 켰는데 모듈이 없으면(`npm install --omit=optional` 등) 기동 시 에러를 내고 종료합니다.
- 기동 시 인증과 원격 데이터 갱신의 on/off를 `MONTAGE_MCP_DEBUG`와 관계없이 stderr에 한 줄(`INFO startup`)로 남깁니다.

| 변수 | 필수 | 설명 |
|---|---|---|
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | O | Google OAuth 클라이언트. 승인된 리디렉션 URI에 `<MONTAGE_MCP_PUBLIC_URL>/oauth/google/callback` 등록 |
| `FIREBASE_API_KEY` | O | Google ID 토큰을 Firebase ID 토큰으로 바꿀 때 쓰는 Web API 키 |
| `FIREBASE_PROJECT_ID` / `FIREBASE_CLIENT_EMAIL` / `FIREBASE_PRIVATE_KEY` | O | Firebase Admin 서비스 계정. private key의 `\n`은 줄바꿈으로 변환 |
| `MONTAGE_MCP_PUBLIC_URL` | O | 서버 공개 URL(예: `https://montage-ios-mcp.example.com`). OAuth issuer와 콜백 URL의 기준. localhost가 아니면 `https` 필수. 사용자가 브라우저로 실제 접속하는 호스트와 같아야 한다(동의 페이지의 CSP와 Origin 검사가 이 값을 기준으로 한다) |
| `FIREBASE_DATABASE_ID` | - | Firestore 데이터베이스 ID. 기본값 `montage-storage` |
| `MONTAGE_MCP_TRUST_PROXY` | - | Express `trust proxy` 홉 수. 기본값 `1`. OAuth 엔드포인트의 IP별 rate limit이 실제 클라이언트 IP 기준으로 동작하도록 인그레스 구성에 맞춘다. 0 이상의 정수가 아니면 기동에 실패한다 |

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
| `deviceId` | string | 인증된 사용자 email(소문자). `MONTAGE_MCP_AUTH=google`인 HTTP 요청에서만 포함 |
| `timestamp` | string | ISO 8601 |
| `params` | object | 호출 인자. `_` prefix 키(예: `_meta`)는 자동 제거 |
| `metadata.duration_ms` | number | 도구 실행 시간 |
| `metadata.status` | `"success"` \| `"error"` | |
| `metadata.version` | string | 서버 `package.json` 버전 |
| `metadata.error_class` | string \| null | `status === "error"` 일 때만 포함 |

인증은 `clientId`로 수행되며 별도 Bearer 토큰은 필요하지 않습니다.
