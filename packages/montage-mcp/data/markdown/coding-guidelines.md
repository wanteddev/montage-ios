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

## 1-A. `Color` 네임스페이스 충돌 (CRITICAL)

Montage는 `public enum Color`를 정의하고 동시에 `extension SwiftUI.Color`에 `static func semantic(_:) / atomic(_:)`을 추가한다. 즉,

- `Color.semantic(.foo)` 같은 **표현식**은 SwiftUI.Color로 정상 추론된다.
- 그러나 **타입 어노테이션 위치**(stored property, return type, function parameter, generic constraint 등)에 `Color`라고 쓰면 컴파일러가 `Montage.Color` (enum) 으로 해석하여 `Cannot convert value of type 'SwiftUI.Color' to ...` 에러가 난다.

**규칙**: SwiftUI 색상 값을 변수/리턴 타입으로 보유할 때는 반드시 `SwiftUI.Color`로 한정해서 어노테이션한다.

```swift
// ✅ 올바름
private var backgroundColor: SwiftUI.Color {
    isSelected ? Color.semantic(.primaryNormal).opacity(0.02)
               : Color.semantic(.backgroundElevatedAlternative)
}

private func tint(for state: State) -> SwiftUI.Color { ... }

@State private var fillColor: SwiftUI.Color = .semantic(.fillNormal)

// ❌ 잘못됨 — `Color`가 Montage.Color (enum)로 해석되어 빌드 실패
private var backgroundColor: Color { Color.semantic(.primaryNormal) }
```

표현식 내부에서는 그냥 `Color.semantic(...)`을 써도 된다 — 충돌은 **타입 위치**에서만 발생한다. 모호한 표현식이 있으면 `SwiftUI.Color.semantic(...)`로 한정한다.

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
- Dynamic Type을 깨지 않게, 폰트 크기를 직접 포인트로 고정하지 않는다 (Typography 토큰 사용).
- VoiceOver 그룹핑이 필요하면 `.accessibilityElement(children: .combine)`.

## 7. 미지원 케이스 처리

- Montage에 없는 디자인은 **추가 컴포넌트 요청 코멘트와 함께 임시 SwiftUI 코드** 작성. 임시 코드도 토큰은 사용한다.
- variant 조합이 doccarchive에 존재하지 않으면 LLM이 임의 enum 케이스를 만들지 말 것. `resolve_figma_component`가 반환한 후보 목록을 호출자에게 전달.

## 8. Modifier 체이닝 순서 (중요)

**호스트 helper(`.paragraph`, `.heading` 등 Typography helper)는 `Text`를 받아 `some View`로 변환하므로, 반드시 `Text` 직후에 체이닝하고 SwiftUI 표준 modifier는 그 뒤에 둔다.**

```swift
// ✅ 올바른 순서
Text("합격 데이터를 기반으로\n선택한 포지션에 맞게 이력서를 다듬어 드려요.")
    .paragraph(variant: .body1, weight: .regular, color: .semantic(.labelNeutral))
    .multilineTextAlignment(.center)
    .frame(maxWidth: .infinity)

// ❌ 잘못된 순서 — typography가 적용되지 않거나 스타일이 누락된다
Text("...")
    .multilineTextAlignment(.center)  // 타입을 some View로 좁혀버림
    .paragraph(variant: .body1, weight: .regular, color: ...)
```

## 9. 멀티컬러 아이콘 렌더링 (CRITICAL — 자주 누락됨)

이름이 `Color`로 끝나는 아이콘(`agentColor`, `aiReviewColor`, `*Color` 패턴 전체)은 멀티컬러 에셋이다. SwiftUI는 기본적으로 template rendering을 적용하므로 단색(보통 accentColor)으로 뭉개진다. **반드시** `Image.icon(...)` 직후에 `.renderingMode(.original)`을 체이닝해야 한다 — 없으면 디자인이 죽는다.

```swift
Image.icon(.agentColor)
    .renderingMode(.original)  // *Color 아이콘은 필수
    .resizable()
    .scaledToFit()
    .frame(width: 48, height: 48)
```

단색 아이콘에는 불필요하다. 일반 아이콘은 `.foregroundColor(...)`로 색을 지정한다.

## 10. SwiftUI Preview에서 Pretendard 폰트 등록

Montage는 Pretendard에 의존하지만 Xcode Preview는 Info.plist를 거치지 않아 폰트가 자동 등록되지 않는다 → Preview에서만 시스템 폰트로 폴백되어 실제 디자인과 어긋난다. Preview에서는 다음 보일러플레이트를 첫 줄에 넣는다.

```swift
import Pretendard

#Preview {
    _ = try? Pretendard.registerFonts()
    return MyView()
}
```

호스트 앱은 launch 시점에 등록되므로 런타임에는 문제없다. **Preview 전용 처리**다.

## 11. SwiftFormat 룰 정렬

Montage 호스트 레포는 SwiftFormat을 사용한다. 코드 생성 시 다음 룰을 미리 적용한 형태로 출력한다(린터가 자동 정정하므로 강제는 아니지만, 노이즈 감소).

- `redundantType`: 타입 추론 가능한 곳에 명시적 타입 annotation 생략
  ```swift
  // ❌ @State private var isLoading: Bool = false
  // ✅ @State private var isLoading = false
  ```
- `redundantSelf`: 클로저 외부에서 `self.` 생략
- `trailingClosures`: 마지막 클로저 인자는 trailing closure로
