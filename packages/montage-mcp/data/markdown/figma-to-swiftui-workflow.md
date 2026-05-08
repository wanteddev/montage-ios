# Figma → SwiftUI (Montage) 변환 워크플로우

피그마 디자인을 Montage 디자인 시스템의 SwiftUI 코드로 변환하는 절차입니다. 본 문서는 `montage-ios` MCP 도구로 서빙되는 신뢰의 원천(single source of truth)입니다. 사전 지식·추측으로 API를 작성하지 말고 도구 응답을 그대로 따르세요.

## 트리거 조건

다음 중 하나에 해당하면 본 워크플로우를 적용합니다.

- 사용자가 Figma URL을 주고 SwiftUI/Montage 코드 작성을 요청
- "Figma 디자인을 Montage로 변환", "이 화면 SwiftUI로 만들어줘" 같은 요청에 Figma 참조가 포함

## 절차

### 0단계: Montage 코딩 가이드라인 로드 (필수)

`mcp__montage-ios__montage_coding_guidelines`를 1회 호출해 전문을 읽습니다. import 규칙·토큰 사용·접근성 외에 **SwiftUI Preview에서 `Pretendard.registerFonts()` 호출 같은 Preview 전용 보일러플레이트**가 포함되어 있으므로, 이 단계를 건너뛰면 코드가 가이드라인을 위반할 수 있습니다.

가이드라인에서 확인한 규칙은 6단계(코드 생성)와 7단계(자체 검증)에서 그대로 적용합니다.

### 1단계: 피그마 디자인 분석

피그마 URL에서 fileKey와 nodeId를 추출합니다.

- URL 형식: `https://figma.com/design/:fileKey/:fileName?node-id=:int1-:int2`
- fileKey: URL path의 `:fileKey` 부분
- nodeId: `node-id` 쿼리 파라미터 값 (하이픈을 콜론으로 변환, 예: `1-2` → `1:2`)

`mcp__claude_ai_Figma__get_design_context` (또는 `mcp__figma__get_design_context`) 도구를 사용하여 디자인 컨텍스트를 가져옵니다.

- clientLanguages: `"swift"`
- clientFrameworks: `"swiftui"`

필요하다면 `get_screenshot`으로 스크린샷도 확인합니다.

### 2단계: 카탈로그 파악 (선택)

처음이거나 변환 대상 화면이 광범위하면 `mcp__montage-ios__list_components`를 1회 호출해 카테고리/컴포넌트 전수를 파악합니다. 이미 익숙하면 건너뜁니다.

### 3단계: Figma 컴포넌트 → Montage initializer 매핑 (반복)

디자인에 등장하는 각 Figma 컴포넌트마다 다음을 수행합니다.

#### 3-A. 컴포넌트 매핑 호출

```
mcp__montage-ios__resolve_figma_component
  figmaName: "Button/Solid/Large"   // Figma 컴포넌트 경로
  variants: { color: "primary" }    // (선택) component property
```

응답:

```json
{
  "ok": true,
  "source": "manifest" | "convention",
  "confidence": 0.0,
  "montageType": "Button",
  "swiftSnippet": "Montage.Button(\n  variant: .solid,\n  ...\n)",
  "matchedVariants": { "variant": "solid", "size": "large" },
  "unmatchedSegments": ["..."],
  "candidates": [],
  "notes": "..."
}
```

**판정**:

| 상태 | 행동 |
|---|---|
| `ok: true`, `source: "manifest"` | 그대로 사용 (confidence 1.0) |
| `ok: true`, `source: "convention"`, `confidence ≥ 0.85`, `unmatchedSegments` 없음 | 그대로 사용 |
| `ok: true`, but `confidence < 0.85` 또는 `unmatchedSegments` 존재 | **3-B 진행** — `get_component`로 스펙 재확인 후 보정 |
| `ok: false` | `candidates` 중 가장 그럴듯한 이름으로 재호출. 그래도 실패면 사용자에게 매핑 누락을 보고하고 임시 SwiftUI 코드로 대체 |

#### 3-B. (필요 시) 컴포넌트 API 스펙 정밀 확인

```
mcp__montage-ios__get_component
  componentName: "Button"
```

응답에서 다음을 확인합니다.

- `Initializers`: 어느 init 시그니처를 쓸지
- `Enums`: variant/size/color 등의 정확한 case 이름
- `Nested Types`: 보조 타입

`resolve_figma_component`이 반환한 `swiftSnippet`을 `get_component` 결과에 맞춰 보정합니다 (예: 매칭 안 된 enum 값 채우기, 시그니처 변경).

### 4단계: 디자인 토큰 → Swift 표현식 매핑

디자인 컨텍스트에 등장하는 모든 색상·타이포·스페이싱·섀도우·오패시티 토큰마다:

```
mcp__montage-ios__resolve_figma_token
  figmaTokenName: "semantic/text/primary"
  kind: "color"   // color | typography | spacing | shadow | opacity
```

응답:

```json
{
  "ok": true,
  "source": "manifest" | "convention",
  "confidence": 0.0,
  "kind": "color",
  "swiftExpression": "Color.Semantic.Text.primary",
  "candidates": [],
  "notes": "..."
}
```

`confidence < 0.9`이면 `mcp__montage-ios__list_tokens`(전체) 또는 `mcp__montage-ios__get_color_usage`(컬러 한정)로 실재 토큰을 확인하고 보정합니다. 숫자 잎 노드(`100`, `500` 등)는 그대로 보존됩니다.

### 5단계: 아이콘 매핑

Figma에 사용된 각 아이콘 이름을 `mcp__montage-ios__list_icons`로 검색합니다.

```
mcp__montage-ios__list_icons
  query: "arrow"   // 부분 일치 (대소문자 무관)
```

매칭된 정확한 카탈로그 이름을 SwiftUI 코드의 `Image.MontageIcon(name:)` (또는 Montage가 제공하는 정확한 시그니처)에 사용합니다.

### 6단계: SwiftUI 코드 생성

다음 규칙을 따릅니다:

1. **Import**: `import SwiftUI` + `import Montage`
2. **컴포넌트 우선**: SwiftUI 표준 뷰 대신 Montage 컴포넌트 사용 (예: `SwiftUI.Button` ❌ → `Montage.Button` ✅)
3. **하드코딩 금지**: 색상·폰트·간격은 4단계에서 받은 Swift 표현식만 사용. 수동으로 `.foregroundColor(.black)` 등을 쓰지 않는다.
4. **Xcode placeholder 채우기**: `resolve_figma_component`가 반환한 `swiftSnippet`에 `<#…#>` 플레이스홀더가 있으면 디자인 컨텍스트에서 해당 정보를 찾아 채워 넣는다 (텍스트, 핸들러 클로저, 아이콘 이름 등).
5. **Preview 보일러플레이트**: 0단계에서 로드한 코딩 가이드라인의 Preview 규칙을 따른다 (`Pretendard.registerFonts()` 호출 포함).
6. **Swift 문법 규칙**: 호스트 프로젝트의 코드 스타일을 따른다.

### 7단계: 자체 검증

생성한 코드가 사용한 모든 Montage 타입·initializer·enum case가 도구가 반환한 스펙과 일치하는지 대조합니다. 일치하지 않는 항목은 `get_component`로 재확인 후 수정합니다.

> **주의**: `get_component` 응답에 없는 타입/시그니처/케이스를 사용하지 마세요. doccarchive에 그것이 없다면 그것은 존재하지 않는 API입니다.

### 8단계: 결과 출력

생성된 코드와 함께 다음을 보고합니다.

- **사용된 Montage 컴포넌트 목록** — `resolve_figma_component`로 매핑한 항목 (Figma 이름 → Montage 이름, source, confidence)
- **사용된 디자인 토큰 목록** — `resolve_figma_token` 결과 요약
- **매핑 실패/주의 사항** — fallback이나 임시 SwiftUI를 쓴 부분
- **Montage에 없는 커스텀 UI** — 향후 추가 후보로 명시
