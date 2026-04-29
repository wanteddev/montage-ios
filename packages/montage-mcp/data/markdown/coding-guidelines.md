# Montage 코딩 가이드라인 (사용자 관점)

LLM/개발자가 **Montage 디자인 시스템을 사용하는 SwiftUI 화면 코드를 작성**할 때 따라야 할 규칙입니다.
(Montage 자체에 기여하는 규칙은 `CONTRIBUTING.md`와 `DOCUMENTATION_GUIDELINES.ko.md` 참조)

---

## 1. Import & 네임스페이스

```swift
import SwiftUI
import Montage
```

- 가능하면 SwiftUI 표준 뷰 대신 Montage 컴포넌트를 사용한다 (예: `SwiftUI.Button` ❌ → `Montage.Button` ✅).
- 동명 충돌이 우려되면 모듈 한정자(`Montage.Button`)를 명시한다.

## 2. 디자인 토큰을 직접 사용한다

하드코딩된 값을 절대 쓰지 않는다.

| 잘못된 예 | 올바른 예 |
|---|---|
| `.foregroundColor(.black)` | `.foregroundColor(Color.Semantic.Text.primary)` |
| `.font(.system(size: 16))` | `.font(.montage(.body1, weight: .medium))` (또는 도구가 알려준 정확한 시그니처) |
| `.padding(16)` | `.padding(Spacing.x4)` |
| `.shadow(radius: 8)` | `Shadow.s2` 등 정의된 토큰 |

토큰의 정확한 Swift 표현식은 `resolve_figma_token` 또는 `list_tokens` 도구로 확인한다.

## 3. 컴포넌트 variant/size/color는 enum 케이스로 전달

Figma의 component property는 Montage enum 케이스에 1:1 대응된다. 추측하지 말고 `get_component`로 확인한 정확한 값을 사용한다.

```swift
// Figma "Button/Solid/Large" + accent color → Montage Button
Button(
  variant: .solid,
  color: .primary,
  size: .large,
  text: "지원하기",
  handler: { ... }
)
```

## 4. Figma → SwiftUI 변환 시 단계

1. `mcp__figma__get_design_context`로 디자인 컨텍스트 수집
2. `resolve_figma_component`로 각 Figma 컴포넌트 → Montage initializer 매핑
3. `resolve_figma_token`으로 색상/타이포/스페이싱 토큰 매핑
4. `get_component`로 정확한 시그니처/enum 케이스 확인
5. SwiftUI 코드 작성 — 이 단계에서 **사전 지식·추측으로 API를 사용하지 않는다**. 도구가 반환한 정보가 유일한 진실의 원천이다.

## 5. SwiftUI 작성 스타일

- `View` body는 선언적이고 짧게. 분기/계산은 별도 메서드 또는 ViewModifier로.
- `@State`/`@Binding`/`@Observable`은 명확하게 분리. ViewModel은 `@Observable` (iOS 17+) 우선.
- iOS 16 호환이 필요하면 `@StateObject` + `ObservableObject` 사용.

## 6. 접근성

- 모든 인터랙티브 컴포넌트는 의미 있는 라벨/힌트를 제공한다.
- Dynamic Type을 깨지 않게, 폰트 크기를 직접 픽셀로 고정하지 않는다 (Typography 토큰 사용).
- VoiceOver 그룹핑이 필요하면 `.accessibilityElement(children: .combine)`.

## 7. 미지원 케이스 처리

- Montage에 없는 디자인은 **추가 컴포넌트 요청 코멘트와 함께 임시 SwiftUI 코드** 작성. 임시 코드도 토큰은 사용한다.
- variant 조합이 doccarchive에 존재하지 않으면 LLM이 임의 enum 케이스를 만들지 말 것. `resolve_figma_component`가 반환한 후보 목록을 호출자에게 전달.
