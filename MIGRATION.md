# 마이그레이션 가이드

메이저 버전 업그레이드에 필요한 변경 사항을 정리합니다. 최신 버전이 위에 옵니다.

각 항목은 **기계적 치환으로 끝나는 것**과 **구조를 다시 짜야 하는 것**, **시각 결과가 달라지는 것**으로 나눠 표시했습니다. 컴파일 에러만 없앤 뒤 화면을 확인하지 않으면 놓치는 항목이 있어서, 마지막 [시각 결과가 달라지는 변경](#시각-결과가-달라지는-변경) 절을 반드시 읽어주세요.

---

## 4.0

> **진행 중**입니다. `release/4.0.0`에 항목이 추가되면 이 문서를 갱신합니다.

4.0은 네 축으로 브레이킹 체인지가 들어갑니다.

1. **컬러 시맨틱 토큰 재편** - 토큰 이름이 `용도 + 역할 + 변형` 규칙으로 통일됐습니다. 값은 대부분 그대로고 이름만 바뀝니다.
2. **슬롯 기반 API 전환** - 고정 파라미터(`leadingImage:`)와 `Model` 구조체 대신 호출부가 뷰를 직접 넣습니다.
3. **입력 컴포넌트 구조 분리** - 라벨·상태 메시지·글자수가 `TextField`/`TextArea` 안쪽에서 `FormControl` 슬롯으로 나왔습니다.
4. **컴포넌트 스펙 리프레시** - radius·타이포·패딩·아이콘 크기가 디자인 스펙에 맞춰 재조정됐습니다. **API가 그대로여서 컴파일 에러가 나지 않는 유일한 축입니다.**

### 작업 순서

| 순서 | 작업 | 성격 | 시각 변화 |
|---|---|---|---|
| 1 | [컬러 시맨틱 토큰](#1-컬러-시맨틱-토큰) | 기계적 치환 | 없음 |
| 2 | [Spacing · Opacity 토큰](#2-spacing--opacity-토큰) | 기계적 치환 | 없음 |
| 3 | [전역 모디파이어](#3-전역-모디파이어) | 기계적 치환 | 없음 |
| 4 | [입력 컴포넌트 → FormControl](#4-입력-컴포넌트--formcontrol) | 구조 재작성 | **있음** |
| 5 | [슬롯 API 전환](#5-슬롯-api-전환) | 구조 재작성 | 대부분 없음 |
| 6 | [단순 API 치환](#6-단순-api-치환) | 기계적 치환 | 일부 있음 |
| 7 | [제거된 UIKit 래퍼](#7-제거된-uikit-래퍼) | 구조 재작성 | 없음 |
| 8 | [컴포넌트 스펙 리프레시](#8-컴포넌트-스펙-리프레시) | 화면 확인 | **있음** |
| 9 | [시각 결과가 달라지는 변경 점검](#시각-결과가-달라지는-변경) | 화면 확인 | **있음** |

**8번을 건너뛰지 마세요.** API가 그대로인데 값만 바뀐 항목이라 컴파일 에러가 나지 않습니다. 치환 작업이 끝나고 빌드가 통과했다고 마이그레이션이 끝난 게 아닙니다.

토큰 치환(1~3)을 먼저 끝내면 컴파일 에러가 크게 줄어 나머지 작업을 보기 쉬워집니다.

---

### 1. 컬러 시맨틱 토큰

`Color.semantic(_:)` / `UIColor.semantic(_:)`에 넘기는 토큰 이름이 전부 바뀝니다. 아래 표의 대응은 **RedOrange 계열 2건을 빼면 값이 같아서** 렌더 결과가 달라지지 않습니다. RedOrange는 4.0에 대응 토큰이 없어 직접 골라야 하고 색이 바뀝니다.

#### 새 이름 규칙

```
용도 + 역할 + 변형

용도   foreground  텍스트·아이콘
       background  화면 바탕
       surface     화면 위에 올라가는 면(카드·필드·버튼)
       line        테두리·구분선
       effect      딤·투명 레이어

역할   Neutral  Brand  Positive  Cautionary  Negative  Disable  Inactive  Accent{색}

변형   Primary → Secondary → Tertiary → Quaternary  (대비가 낮아지는 순서)
       Strong / Heavy   더 진함
       Subtle           더 옅음
       Inverse          반전 배경 위에서 쓰는 색
       Focus            포커스 링
       Opaque           불투명 버전 (접미사 없는 쪽이 반투명)
```

3.x의 `Solid` 접미사가 4.0에서 `Opaque`로 뒤집혔습니다. **`lineSolidNormal` → `lineNeutralPrimaryOpaque`**처럼 접미사 위치가 앞에서 뒤로 옮겨간다는 점만 주의하면 됩니다.

#### Foreground - 텍스트·아이콘

| 3.x | 4.0 |
|---|---|
| `.labelNormal` | `.foregroundNeutralPrimary` |
| `.labelStrong` | `.foregroundNeutralStrong` |
| `.labelNeutral` | `.foregroundNeutralSecondary` |
| `.labelAlternative` | `.foregroundNeutralTertiary` |
| `.labelAssistive` | `.foregroundNeutralQuaternary` |
| `.inverseLabel` | `.foregroundNeutralInverse` |
| `.labelDisable` | `.foregroundDisablePrimary` |
| `.interactionInactive` | `.foregroundInactivePrimary` |
| `.inversePrimary` | `.foregroundBrandInverse` |
| `.statusPositive` | `.foregroundPositivePrimary` |
| `.statusCautionary` | `.foregroundCautionaryPrimary` |
| `.statusNegative` | `.foregroundNegativePrimary` |
| `.accentForegroundBlue` | `.foregroundBrandPrimary` |
| `.accentForegroundGreen` | `.foregroundPositivePrimary` |
| `.accentForegroundOrange` | `.foregroundCautionaryPrimary` |
| `.accentForegroundRed` | `.foregroundNegativeStrong` |
| `.accentForegroundRedOrange` | **대응 없음** (아래 참고) |
| `.accentForegroundLime` | `.foregroundAccentLime` |
| `.accentForegroundCyan` | `.foregroundAccentCyan` |
| `.accentForegroundLightBlue` | `.foregroundAccentLightBlue` |
| `.accentForegroundViolet` | `.foregroundAccentViolet` |
| `.accentForegroundPurple` | `.foregroundAccentPurple` |
| `.accentForegroundPink` | `.foregroundAccentPink` |

> `accentForeground{색}` 중 Blue·Green·Orange·Red는 액센트 계열에서 **의미 색(brand/positive/cautionary/negative)으로 승격**됐습니다. 이름만 옮기지 말고 그 자리가 정말 의미 색인지 확인해주세요.

#### Background · Surface - 면

| 3.x | 4.0 |
|---|---|
| `.backgroundNormal` | `.backgroundNeutralPrimary` |
| `.backgroundNormalAlternative` | `.backgroundNeutralSecondary` |
| `.backgroundElevated` | `.surfaceElevatedPrimary` |
| `.backgroundElevatedAlternative` | `.surfaceElevatedSecondary` |
| `.fillNormal` | `.surfaceNeutralSecondary` |
| `.fillAlternative` | `.surfaceNeutralTertiary` |
| `.fillStrong` | `.surfaceNeutralStrong` |
| `.fillPrimary` | `.surfaceBrandSubtle` |
| `.fillNegative` | `.surfaceNegativeStrong` |
| `.backgroundStatusPositive` | `.surfacePositivePrimary` |
| `.backgroundStatusCautionary` | `.surfaceCautionaryPrimary` |
| `.backgroundStatusNegative` | `.surfaceNegativePrimary` |
| `.inverseBackground` | `.surfaceNeutralInverse` |
| `.primaryNormal` | `.surfaceBrandPrimary` |
| `.primaryStrong` | `.surfaceBrandStrong` |
| `.primaryHeavy` | `.surfaceBrandHeavy` |
| `.interactionDisable` | `.surfaceDisablePrimary` |
| `.accentBackgroundLime` | `.surfaceAccentLimeOpaque` |
| `.accentBackgroundCyan` | `.surfaceAccentCyanOpaque` |
| `.accentBackgroundLightBlue` | `.surfaceAccentLightBlueOpaque` |
| `.accentBackgroundViolet` | `.surfaceAccentVioletOpaque` |
| `.accentBackgroundPink` | `.surfaceAccentPinkOpaque` |
| `.accentBackgroundRedOrange` | **대응 없음** (아래 참고) |

> `background`는 화면 바탕(Primary·Secondary) 두 종만 남았습니다. 나머지는 면 토큰이면 `surface`로, 투명 레이어인 `backgroundTransparent*`는 `effect`로 갈라졌습니다 (`backgroundTransparent` → `effectTransparentPrimary`, `backgroundTransparentAlternative` → `effectTransparentSecondary`). 값은 그대로입니다.
>
> `accentBackground{색}`은 기본이 **불투명(`Opaque`)** 대응입니다. 반투명 위에 겹쳐 쓰던 자리라면 접미사 없는 `.surfaceAccent{색}`을 쓰세요.
>
> **RedOrange 계열은 4.0 시맨틱에서 없어졌습니다.** `accentForegroundRedOrange`와 `accentBackgroundRedOrange`에 대응하는 4.0 토큰이 없습니다(프리미티브 `redOrange*`는 그대로 남아 있습니다). 1:1 치환이 불가능하니 그 자리의 의도를 보고 직접 골라야 하고, 무엇을 고르든 **색이 바뀝니다.** 원티드 앱은 이 토큰을 쓰던 세 곳이 모두 텍스트·아이콘 색이어서 `.foregroundNegativePrimary`로 옮겼는데, 그 결과 `redOrange50/60`이 `red50/60`으로 바뀌었습니다. 면 색으로 쓰던 자리라면 `.surfaceNegativePrimary`나 프리미티브 `redOrange*` 직접 지정이 원래 값에 더 가깝습니다.

#### Line - 테두리·구분선

| 3.x | 4.0 |
|---|---|
| `.lineNormal` | `.lineNeutralPrimary` |
| `.lineNeutral` | `.lineNeutralSecondary` |
| `.lineAlternative` | `.lineNeutralTertiary` |
| `.lineSolidNormal` | `.lineNeutralPrimaryOpaque` |
| `.lineSolidNeutral` | `.lineNeutralSecondaryOpaque` |
| `.lineSolidAlternative` | `.lineNeutralTertiaryOpaque` |
| `.linePrimaryStrong` | `.lineBrandStrong` |
| `.lineStatusPositiveNormal` | `.linePositivePrimary` |
| `.lineStatusCautionaryNormal` | `.lineCautionaryPrimary` |
| `.lineStatusNegativeStrong` | `.lineNegativeStrong` |

#### Effect - 딤·투명 레이어

| 3.x | 4.0 |
|---|---|
| `.materialDimmer` | `.effectDimmerPrimary` |
| `.backgroundTransparent` | `.effectTransparentPrimary` |
| `.backgroundTransparentAlternative` | `.effectTransparentSecondary` |

#### 위 표에 없는 토큰

4.0에서 새로 생긴 토큰(`lineBrandFocus`, `lineNegativeFocus`, `foregroundAccent*` 등)과 프리미티브 토큰(`neutral*`, `blue*`, `coolNeutral*` …)은 `Color.Semantic`에서 직접 확인해주세요. 프리미티브 이름은 변경되지 않았습니다.

위 표에서 못 찾은 3.x 토큰은 `Color.Semantic` 각 케이스의 doc 주석을 보면 됩니다. 리네임된 토큰에는 `/// … (구 labelNormal)`처럼 3.x 이름이 적혀 있습니다.

#### 일괄 치환

3.x 토큰 이름이 4.0에 남아 있는 게 없으므로 단어 경계 치환으로 안전하게 처리됩니다.

```bash
# 확인 먼저
grep -rn "\.labelNormal\b" --include="*.swift" .

# 치환
find . -name "*.swift" -exec sed -i '' \
  -e 's/\.labelNormal\b/.foregroundNeutralPrimary/g' \
  -e 's/\.labelAlternative\b/.foregroundNeutralTertiary/g' \
  -e 's/\.backgroundNormal\b/.backgroundNeutralPrimary/g' \
  {} +
```

---

### 2. Spacing · Opacity 토큰

값이 이름에 그대로 들어가는 방식으로 평탄화됐습니다. 값 대응은 1:1이라 렌더 결과가 같습니다.

```swift
// 3.x
.padding(.spacing(.pt20))
.opacity(.p043)

// 4.0
.padding(.spacing20)
.opacity(.opacity43)
```

| 3.x | 4.0 |
|---|---|
| `.spacing(.pt02)` … `.spacing(.pt72)` | `.spacing2` … `.spacing72` |
| `.opacity(.p000)` | `.opacity0` |
| `.opacity(.p005)` | `.opacity5` |
| `.opacity(.p008)` | `.opacity8` |
| `.opacity(.p012)` | `.opacity12` |
| `.opacity(.p016)` | `.opacity16` |
| `.opacity(.p022)` | `.opacity22` |
| `.opacity(.p028)` | `.opacity28` |
| `.opacity(.p032)` | `.opacity32` |
| `.opacity(.p035)` | `.opacity35` |
| `.opacity(.p043)` | `.opacity43` |
| `.opacity(.p052)` | `.opacity52` |
| `.opacity(.p061)` | `.opacity61` |
| `.opacity(.p074)` | `.opacity74` |
| `.opacity(.p088)` | `.opacity88` |
| `.opacity(.p097)` | `.opacity97` |
| `.opacity(.p100)` | `.opacity100` |

`pt08` → `spacing8`처럼 **0 패딩이 사라집니다**. `spacing08`이 아닙니다.

Opacity 토큰은 `Double`로 이관됐습니다. `withAlphaComponent(0)`처럼 원시 리터럴을 쓰던 자리도 `withAlphaComponent(.opacity0)`으로 정리할 수 있습니다.

---

### 3. 전역 모디파이어

| 3.x | 4.0 | 비고 |
|---|---|---|
| `.disable(_:)` | `.disabled(_:)` | SwiftUI 표준 모디파이어로 흡수. 컴포넌트가 `isEnabled` 환경값을 읽습니다 |
| `scrollStatus.scrolledToMax` | `scrollStatus.reachedEnd` | `Montage.ScrollView`의 `ScrollStatus` 프로퍼티 |

`disable()` → `disabled()`는 이름만 바뀌는 게 아닙니다. 3.x는 컴포넌트가 스스로 `opacity`를 깔았고, 4.0은 SwiftUI `isEnabled`를 타고 색 토큰(`foregroundDisablePrimary` 등)으로 표현합니다. [시각 결과가 달라지는 변경](#시각-결과가-달라지는-변경)을 확인해주세요.

입력 컴포넌트에는 `autocorrectionDisabled(_:)`가 새로 생겼습니다(추가 API, 브레이킹 아님).

---

### 4. 입력 컴포넌트 → FormControl

가장 손이 많이 가는 변경입니다. `TextField`/`TextArea`가 **입력 그 자체만** 담당하고, 라벨·상태 메시지·글자수 카운터는 `FormControl`이 필드 밖에서 배치합니다.

| 3.x (필드 내부) | 4.0 (FormControl 슬롯) | 위치 |
|---|---|---|
| `.heading("이메일")` | `.label("이메일")` | 필드 **위** |
| `.status(.negative(description: msg))` | `.status(.negative)` + `.message(msg)` | 필드 **아래** |
| `.bottomResources(trailing: [.characterCount(limit:)])` | `.accessory { … }` | 필드 아래 **우측** |
| `.disable(_:)` | `.disabled(_:)` | - |

`TextField.Status`에서 연관값이 빠졌습니다. `.normal()` → `.normal`, `.negative(description:)` → `.negative`.

#### TextField

```swift
// 3.x
Montage.TextField(text: $email)
    .heading(String(localized: "이메일"))
    .placeholder(String(localized: "이메일을 입력해주세요."))
    .status(isInvalidated ? .negative(description: errorMessage) : .normal())
    .disable(isDisabled)

// 4.0
FormControl { context in
    Montage.TextField(text: $email)
        .status(context.status.textFieldStatus)
        .placeholder(String(localized: "이메일을 입력해주세요."))
}
.label(String(localized: "이메일"))
.status(isInvalidated ? .negative : .normal)
.message(isInvalidated ? errorMessage : nil)
.disabled(isDisabled)
```

상태는 **`FormControl`이 소유**하고 `context.status.textFieldStatus`로 필드에 내려갑니다. 필드에 상태를 직접 주면 라벨·메시지 색이 따로 놀게 됩니다.

#### TextArea + 글자수 카운터

```swift
// 3.x
TextArea(text: $feedback, focus: $focus)
    .resize(.fixed(min: 116, max: 116))
    .placeholder("좋았던 점이나 아쉬운 점을 적어주세요.")
    .bottomResources(trailing: [.characterCount(limit: 1000)])

// 4.0
FormControl { _ in
    TextArea(text: $feedback, focus: $focus)
        .maxLength(1000)
        .resize(.fixed(min: 116, max: 116))
        .placeholder(String(localized: "좋았던 점이나 아쉬운 점을 적어주세요."))
}
.accessory {
    Text(verbatim: "\(feedback.count)/1000")
        .typography(variant: .label2, weight: .medium, semantic: .foregroundNeutralTertiary)
}
```

`bottomResources`의 `.characterCount` 리소스가 제거됐습니다. 카운터는 이제 호출부가 직접 그립니다(`bottomResources` 자체는 남아 있습니다). 두 가지를 챙겨주세요.

- **입력 상한은 `maxLength(_:)`로 필드에 줍니다.** 카운터 표시와 입력 제한이 분리됐습니다.
- **`Text(verbatim:)`을 쓰세요.** `Text("\(count)/\(limit)")`는 `LocalizedStringKey` 보간을 타서 상한이 1000 이상일 때 로케일 천단위 구분자가 붙습니다(`5,000`). `verbatim:`이면 `5000`으로 나옵니다.

`FormControl`의 나머지 모디파이어: `size(.large/.medium)`, `labelPlacement(.top/.leading)`, `labelWidth(_:)`, `label(_:required:)`. 여러 필드를 묶어 정렬하려면 `FormControlGroup`을 씁니다.

#### 입력에 직접 붙이는 방식

`FormControl`로 감싸지 않고 `TextField`·`TextArea`·`Select`에 모디파이어를 바로 붙일 수도 있습니다. 세 컴포넌트가 같은 다섯 개를 갖습니다.

`.label(_:required:)` · `.message(_:)` · `.labelPlacement(_:)` · `.labelWidth(_:)` · `.accessory { }`

```swift
Montage.TextField(text: $email)
    .placeholder(String(localized: "이메일을 입력해주세요."))
    .label(String(localized: "이메일"), required: true)
    .message(isInvalidated ? errorMessage : nil)
    .status(isInvalidated ? .negative : .normal)
```

하나라도 붙이면 내부에서 `FormControl`로 감싸지므로 결과는 위의 `FormControl { … }` 조합과 같습니다. 라벨은 입력의 접근성 라벨로, 메시지는 접근성 힌트로 연결됩니다.

`size`·`status`는 **호출부 지정값 → `FormControl` 전파값 → 기본값**(`.large` / `.normal`) 순으로 결정됩니다. 입력 하나에 라벨·메시지만 붙이는 흔한 경우는 이 방식이 짧고, `FormControlGroup`으로 묶거나 입력을 조합해야 하면 `FormControl`을 직접 쓰는 편이 낫습니다.

---

#### 자체 입력 래퍼가 있다면

`AutoCompleteTextInput`처럼 내부에 `TextField`를 감싼 래퍼는 **래퍼 자체를 `FormControl`로 감싸고**, 상태·메시지 파라미터를 래퍼 인터페이스로 노출하는 편이 낫습니다. 래퍼 안에서 `FormControl`을 쓰면 라벨을 밖에서 주기 어려워집니다.

---

### 5. 슬롯 API 전환

`Model` 구조체와 고정 이미지 파라미터가 사라지고 호출부가 뷰를 직접 넣습니다.

#### ActionArea

```swift
// 3.x
.actionArea(
    variant: .neutral(main: .init(text: "확인", action: { … }))
)
// 또는
.bottomSheet(isPresented: $isPresented, actionAreaModel: .init(variant: …)) {
    Content()
}

// 4.0
.actionArea {
    ActionArea(variant: .neutral(main: .init(text: "확인", action: { … })))
}
// 또는
.bottomSheet(
    isPresented: $isPresented,
    actionArea: { ActionArea(variant: …) },
    { Content() }
)
```

`actionArea` 슬롯 클로저에는 `@ViewBuilder`가 **붙지 않습니다**. `if`문을 쓰면 `_ConditionalContent`가 되어 `ActionArea` 타입 제약이 깨집니다. 조건 분기는 삼항 연산자나 모디파이어 체인으로 처리하세요.

```swift
// 안 됩니다
.actionArea { if isEditing { ActionArea(variant: a) } else { ActionArea(variant: b) } }

// 이렇게
.actionArea { ActionArea(variant: isEditing ? a : b) }
```

투명 배경 API가 없어졌습니다. 배경은 항상 불투명하고, **상단 그라데이션만** "아래에 가려진 콘텐츠가 있다"는 신호로 켜졌다 꺼집니다(0.5초 페이드).

| 3.x | 4.0 |
|---|---|
| `.transparentBackground(_:)` | 제거 |
| `ActionArea.BackgroundTransparencyControl` (`.automatic` / `.manual`) | 제거 |
| `actionArea(backgroundTransparency:)` | 제거 |
| `.gradientColor(_:)` | `.backgroundColor(_:)` (배경과 그라데이션 시작색에 함께 적용) |
| - | `.scrollReachedEnd(_:)` 신설 |

`Montage.ScrollView`를 쓰면 스크롤 바닥 도달이 자동 전달되므로 아무것도 넘기지 않아도 3.x의 `.automatic`과 동등합니다. `SwiftUI.ScrollView`/`List`처럼 신호를 올려주지 않는 컨테이너를 쓸 때만 `actionArea(scrollReachedEnd:)`로 직접 넘기세요.

**`.manual`로 배경을 직접 투명하게 만들던 자리는 하단 도달 신호를 직접 넘기면 됩니다.** 스크롤 컨테이너가 아예 없는 화면(팝업·시트 안의 고정 높이 콘텐츠)은 신호가 올라올 데가 없어서 ActionArea가 "아래에 가려진 콘텐츠가 있다"고 보고 그라데이션과 배경을 그립니다. `true`를 넘기면 그라데이션이 숨겨지고 배경이 비칩니다.

넘기는 자리가 두 군데입니다.

```swift
// 뷰에 모디파이어로 붙이는 경우
content
    .actionArea(scrollReachedEnd: true) { ActionArea(variant: …) }

// BottomSheet·Popup 처럼 actionArea: 인자로 넘기는 경우 - ActionArea 에 직접 체인한다
.popup(isPresented: $isPresented, actionArea: {
    ActionArea(variant: …)
        .scrollReachedEnd(true)
})
```

배경색 자체를 바꿔야 한다면 `backgroundColor(_:)`를 씁니다. 두 방법 중 어느 것도 맞지 않으면 그 표현이 정말 필요한지 디자이너와 다시 확인해주세요.

4.0에서 ActionArea 스펙도 함께 조정됐습니다.

| 항목 | 3.x | 4.0 |
|---|---|---|
| `extra` 슬롯 좌우 여백 | 20 | **24** |
| `extra` 슬롯 하단 여백 | 24 | **20** |
| `extra` 구분선 색 | `lineNeutralSecondary` | `lineNeutralTertiary` (옅어짐) |
| 캡션 타이포 | `label2` | `label2` + `weight: .medium` (굵어짐) |
| 캡션 아이콘 | 없음 | `.caption(_:icon:)` 16pt 슬롯 신설 |
| 대체(`alternative`) 액션 버튼 | `outlined` / `primary` | `outlined` / **`assistive`** |
| `cancel` 메인 액션 버튼 | `outlined` / `assistive` | **`solid`** / `assistive` |

메인 버튼 행의 좌우 여백 20은 그대로입니다.

버튼 색상은 API가 그대로라 컴파일 에러가 나지 않습니다. 대체 액션은 라벨이 파란색에서 검정으로 바뀌어 주 액션과의 대비가 커지고, `cancel` variant의 메인 버튼은 테두리형에서 회색 채움으로 바뀝니다. 보조(`sub`) 액션은 변경이 없습니다.

#### ScreenScaffold

`TopNavigation` + 본문 + `ActionArea`를 한 화면으로 조립하는 컨테이너가 새로 생겼습니다. 화면마다 손으로 맞추던 스크롤 오프셋 전달과 하단 여백 계산을 스캐폴드가 대신합니다.

```swift
ScreenScaffold(
    navigation: { TopNavigation(title: title) },
    actionArea: { ActionArea(variant: .neutral(main: .init(text: "확인", action: submit))) }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

`ActionArea`를 `safeAreaInset(edge: .bottom)`으로 넣기 때문에 스크롤 컨테이너가 그만큼 콘텐츠 인셋을 잡습니다. **바닥까지 내렸을 때 마지막 요소가 버튼에 가리지 않도록 호출부가 손으로 비워 주던 여백은 지우세요.**

| `scrollContainer` | 언제 |
|---|---|
| `.builtIn` (기본) | 스캐폴드가 `Montage.ScrollView`를 깔고 스크롤 상태를 직접 잼 |
| `.custom` | `List`처럼 컨테이너를 바꿀 수 없을 때. 콘텐츠가 `reportsScrollOffset(_:)`·`reportsScrollReachedEnd(_:)`로 신호를 올려야 함 |

`navigation`·`actionArea` 슬롯 클로저에도 **`@ViewBuilder`가 붙지 않습니다.** `if`문을 쓰면 `_ConditionalContent`가 되어 타입 제약이 깨지므로, 조건부로 넣을 때는 `actionArea: isEditing ? slot : nil`처럼 클로저 자체를 갈라 주세요.

`BottomSheet`·`Popup` 안에는 넣지 않습니다. 두 컴포넌트가 같은 일을 하고 `ActionArea` 높이를 자기 높이 계산에 쓰므로 그쪽 `actionArea:` 인자로 넘기세요. 전체 화면 커버나 push된 목적지는 시트가 아니라 화면이므로 여기에 해당하지 않습니다.

`List`를 쓸 때는 행 배경과 스크롤 배경을 **둘 다** 걷어내야 합니다. 하나만 처리하면 `backgroundColor(_:)`로 지정한 색이 가려지고, `ActionArea`가 바닥에서 투명해질 때 그 경계가 드러납니다.

---

#### ListCell

`title*` 계열이 `label*`로, `fillWidth()`가 `variant(_:)`로, `leadingContent {}`가 `leadingResources([…])`로 바뀌었습니다.

| 3.x | 4.0 |
|---|---|
| `ListCell(title:)` | `ListCell(label:)` |
| `.titleVariant(_:)` / `.titleWeight(_:)` / `.titleColor(_:)` | `.labelVariant(_:)` / `.labelWeight(_:)` / `.labelColor(_:)` |
| `.caption(_:)` | `.description(_:)` |
| `.fillWidth(false)` | `.variant(.inset)` (기본값) |
| `.fillWidth(true)` | `.variant(.full)` |
| `.leadingContent { … }` | `.leadingResources([.slot { … }])` |
| `.interactionPadding(_:)` | 제거 - `variant`에 통합 |
| `.verticalAlign(.bottom)` | 제거 - `.top` / `.center`만 남음 |

```swift
// 3.x
ListCell(title: option.title) { onSelect() }
    .fillWidth()
    .leadingContent {
        Avatar(option.imageUrl, variant: .company, size: .xsmall)
    }

// 4.0
ListCell(label: option.title) { onSelect() }
    .variant(.full)
    .leadingResources([.slot {
        Avatar(option.imageUrl, variant: .company, size: .xsmall)
    }])
```

`inset`은 인터랙션 배경만 좌우 12 확장하고 모서리 16, `full`은 셀이 좌우 여백 20을 직접 갖습니다. 기존 `fillWidth(false/true)`와 값까지 대응합니다.

슬롯이 네 종으로 늘었습니다: `leadingResources`, `labelTrailingResources`, `trailingResources`, `extraResources`. 자주 쓰는 조합은 프리셋으로 있습니다.

```swift
.leadingResources([.icon(.search), .checkbox(checked: isChecked)])
.leadingResources([.radio(checked: isSelected)])
.leadingResources([.avatar(url, variant: .company)])
.leadingResources([.thumbnail(url)])
.leadingResources([.slot { AnyCustomView() }])   // 프리셋에 없으면 slot
```

`verticalPadding`에 `.custom(CGFloat)`이 추가됐습니다.

#### Chip

이미지 파라미터가 콘텐츠 슬롯으로 바뀌었습니다.

| 3.x | 4.0 |
|---|---|
| `leadingImage:` / `trailingImage:` | `.leadingContent { … }` / `.trailingContent { … }` |
| `.imageColor(_:)` | 슬롯 안에서 직접 지정 |
| `.iconOnly(_:)` | 제거 - `leadingContent`만 채우면 됩니다 |

아이콘 크기·색을 컴포넌트가 정해주지 않으므로 **사용처가 직접 넣어야 합니다.** 3.x가 size별로 넣던 값은 이렇습니다.

| Chip size | 아이콘 크기 |
|---|---|
| `.large` | 16 |
| `.medium` · `.small` | 14 |
| `.xsmall` | 12 |

```swift
// 4.0
Chip(text: skill.name, variant: .outlined, size: .medium)
    .trailingContent {
        Image.icon(.close)
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundStyle(Color.semantic(.foregroundNeutralTertiary))
    }
```

#### 슬롯 프리셋 이름

프리셋은 `컴포넌트.Resource.슬롯명` 패턴으로 통일됐습니다.

```swift
// 3.x
TopNavigation.LeadingButton(TopNavigation.Resource.LeadingButtonInfo.back(action: { dismiss() }))

// 4.0
TopNavigation.LeadingButton(TopNavigation.Resource.Leading.back(action: { dismiss() }))
```

---

### 6. 단순 API 치환

#### Button · TextButton

`fill(horizontal:vertical:)`이 **제거**되고 `fillWidth(_:)`로 대체됐습니다. 유예 없이 4.0에서 바로 빠지니 호출부를 모두 옮기세요.

| 3.x | 4.0 |
|---|---|
| `.fill(horizontal: true)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: false)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: true)` | `.fillWidth(true)` |

`vertical`은 3.x에서도 이미 아무 동작을 하지 않았습니다. 시그니처에만 있고 함수 본문에서 쓰이지 않아, `vertical: true`로 부르던 곳도 세로 채움이 일어난 적이 없습니다. 세 경우 모두 렌더링이 그대로라 기계적으로 치환해도 됩니다.

`TextButton`은 3.x에 `fillWidth(_:)`가 없었습니다. 4.0에서 `Button`과 같은 모양으로 새로 생겼습니다.

#### IconButton

`normal` variant의 사이즈가 `Int`에서 `NormalSize` 열거형으로 바뀌었습니다.

| 3.x | 4.0 | 아이콘 글리프 | 컨테이너 |
|---|---|---|---|
| `.normal(size: 16)` | `.normal(size: .small)` | 16 | 24 |
| `.normal(size: 18)` | `.normal(size: .medium)` | 18 | 28 |
| `.normal(size: 20)` | `.normal(size: .large)` | 20 | 32 |
| `.normal(size: 24)` | `.normal(size: .xlarge)` | 24 | 36 |

글리프 크기는 그대로고 **터치 컨테이너만 커집니다**. 배경·테두리 없는 variant라 트레일링 아이콘이 약 6px 움직이거나 행 높이가 약 8px 늘어나는 정도입니다.

#### Skeleton

가변 폭 배열 대신 타이포그래피 변형을 받습니다. 줄 높이·줄 수를 변형에서 자동 계산합니다.

```swift
// 3.x
Skeleton.SkeletonView(.text(lengths: [._25, ._50, ._75]))

// 4.0
Skeleton.SkeletonView(.text(variant: .body1))
```

플레이스홀더 바 폭이 가변(25/50/75/100%)에서 균일로 바뀝니다. 여러 줄을 흉내내려면 `SkeletonView`를 여러 개 놓으세요.

#### PushBadge

variant가 통합됐습니다.

| 3.x | 4.0 |
|---|---|
| `.new` | `.text("N")` |
| `.number(count)` | `.maxCount(count, max: 99)` |

한 글자일 때 최소 너비 + 패딩 대신 `badgeSize` 정사각(xsmall 16 / small 20 / medium 24)으로 고정됩니다. `N`처럼 좁은 글자는 픽셀 차이가 없고, 한글 한 글자나 `M`·`W`에서 정원이 유지됩니다. Dynamic Type은 `xxxLarge`에서 멈춥니다.

#### FallbackView

여백 인터페이스가 생기고 **상하 최소 여백이 컴포넌트에 내장됐습니다.**

```swift
public enum Padding {
    case normal   // 160 (기본값)
    case compact  // 80
}
```

```swift
// 3.x - 밖에서 여백을 줬습니다
FallbackView(…)
    .padding(.vertical, 80)

// 4.0 - 컴포넌트에 맡깁니다
FallbackView(…)
    .padding(.compact)
```

**밖에서 주던 여백과 고정 높이를 반드시 정리하세요.** 그대로 두면 이중 적용됩니다. 특히 `frame(height:)`는 최소 여백 160(또는 80)에 콘텐츠까지 들어가지 않아 넘칩니다.

| 3.x | 4.0 |
|---|---|
| `.padding(.vertical, 160)` | 제거 (기본 `.normal` = 160) |
| `.padding(.vertical, 120)` | 제거 |
| `.padding(.vertical, 80)` | `.padding(.compact)` |
| `.padding(.vertical, 48)` | `.padding(.compact)` |
| `.frame(height: 200)` | `.padding(.compact)` + 고정 높이 제거 |

버튼 영역은 `buttonActionArea(_:)`로 넘깁니다(`.single` / `.horizontal` / `.vertical`).

---

### 7. 제거된 UIKit 래퍼

deprecated UIKit 래퍼가 제거됐습니다. SwiftUI 컴포넌트를 `UIHostingController`로 브리징하세요.

| 제거됨 | 대체 |
|---|---|
| `Montage.Button.SolidUIButton` | `Montage.Button(variant: .solid, …)` |
| `Montage.Button.OutlinedUIButton` | `Montage.Button(variant: .outlined, …)` |
| `ContentBadgeUIView` | `ContentBadge(…)` |

스펙은 동일하므로 렌더 결과에 차이가 없습니다.

---

### 8. 컴포넌트 스펙 리프레시

컴파일 에러가 나지 않아 놓치기 쉬운 구간입니다. **API는 그대로인데 값이 바뀐** 항목이라, 치환 작업이 끝난 뒤 화면을 봐야 드러납니다.

#### Button

| 항목 | 3.x | 4.0 |
|---|---|---|
| radius | large 12 / medium 10 / small 8 | large **14** / medium **12** / small **10** / xsmall 8 |
| 높이 제약 | `.frame(height:)` 고정 | `.frame(minHeight:)` |
| 아이콘 크기 | large 24 / medium 24·22 / small 20·18 | large 22 / medium 22·20 / small 20·16 / xsmall 16 |
| 사이즈 | large · medium · small | **+ xsmall** |
| color | primary · assistive | **+ negative** |
| 타이포 | 사이즈별 한 단계 위 | 사이즈별 한 단계 아래로 조정 |

**높이 제약이 고정에서 최소값으로 바뀐 게 파급이 가장 큽니다.** 3.x는 라벨이 길면 한 줄로 말줄임(`텍스트...`)했는데, 4.0은 **줄바꿈해서 버튼이 세로로 커집니다.** 긴 라벨을 쓰는 버튼이 있으면 주변 레이아웃이 밀립니다.

#### Chip · FilterButton

타이포가 사이즈별로 한 단계 내려가고 패딩이 조정되어 **칩이 전체적으로 작아집니다.**

| Chip size | 3.x 타이포 | 4.0 타이포 |
|---|---|---|
| `large` | `body2` | `label1` |
| `medium` | `label1` | `label2` |
| `small` | `label1` | `caption1` |
| `xsmall` | `caption1` | `caption2` |

FilterButton은 radius가 커지고 패딩이 줄어 더 둥글고 작아집니다.

#### Select

| 항목 | 3.x | 4.0 |
|---|---|---|
| 사이즈 | 없음 | `size(.large / .medium)` 신설 |
| min-height | - | 증가 (필드가 높아짐) |
| 테두리 색 | - | 옅어짐 |
| `heading` · `requiredBadge` | 컴포넌트 내장 | 제거 - `FormControl`로 이관 |
| 세로 정렬 | 항상 `top` | `overflow`일 때만 `top`, 그 외 `center` |

세로 정렬은 Dynamic Type을 키웠을 때만 눈에 띕니다. 3.x는 항상 `top` 정렬이라 텍스트 높이가 leading 아이콘·chevron(24pt)을 넘어서면 **아이콘만 위로 치우쳐** 보였습니다. 4.0은 여러 줄로 흐르는 `overflow` 상태에서만 `top`을 쓰고 한 줄일 때는 `center`로 맞춥니다. 선택 목록의 `ListCell`도 `verticalAlign(.center)`가 붙어 라디오·체크박스가 라벨 중앙에 옵니다.

#### TopNavigation · ModalNavigation

스크롤 시 깔리는 배경 tint 농도가 올라갔습니다.

| 항목 | 3.x·4.0 초기 | 4.0 |
|---|---|---|
| 스크롤 배경 tint | `backgroundOpacity * 0.7` | `backgroundOpacity * 0.88` |

콘텐츠를 스크롤해 내비게이션 배경이 나타나는 구간에서 **배경이 더 진해집니다.** API 변경은 없고 값만 바뀌므로 컴파일 에러가 나지 않습니다. 내비게이션 아래로 콘텐츠가 지나가는 화면을 눈으로 확인해주세요.

#### SegmentedControl

| 항목 | 3.x | 4.0 |
|---|---|---|
| variant | `solid` · `outlined` | **`outlined` 제거** |
| 아이콘 | `icon` 토글 | `leadingIcon` + `iconOnly` |

#### Avatar · AvatarGroup

company·academy variant의 cornerRadius가 전 사이즈에서 **+2** 됩니다.

| size | 3.x | 4.0 |
|---|---|---|
| `xsmall` | 6 | 8 |
| `small` | 8 | 10 |
| `medium` | 10 | 12 |
| `large` | 12 | 14 |
| `xlarge` | 14 | 16 |
| `custom(v)` | `ceil(v * 0.25 / 2) * 2` | `ceil(v * 0.25 / 2) * 2 + 2` |

테두리 기본색이 `lineAlternative`에서 `lineNeutralTertiary`로, 푸시뱃지 inset도 사이즈별로 조정됐습니다.

#### 그 외

`Shadow` · `Typography` · `Opacity` · `Spacing` 정의와 `Toast` · `SnackBar` · `Popup` · `Popover` · `Tooltip` · `Thumbnail` · `Accordion` · `Category` · `ProgressTracker`도 값이 조정됐습니다. 새로 생긴 `Radius` · `Dimension` · `Primitive` · `MaterialBackground`는 추가 API입니다.

---

## 시각 결과가 달라지는 변경

컴파일은 통과하지만 화면이 달라지는 항목입니다. **마이그레이션 후 이 목록의 화면을 눈으로 확인해주세요.**

| 대상 | 무엇이 달라지나 |
|---|---|
| **Button** | 높이 제약이 고정에서 최소값으로 바뀌어 **긴 라벨이 말줄임 대신 줄바꿈**됩니다. 버튼이 세로로 커져 주변 레이아웃이 밀립니다. radius도 사이즈별로 +2 |
| **Chip · FilterButton** | 타이포가 한 단계 내려가고 패딩이 줄어 **작아집니다.** 가로로 나열되는 칩·필터 바의 줄바꿈 지점이 달라집니다 |
| **Select** | min-height가 올라가 **선택 필드가 높아집니다.** 테두리 색도 옅어집니다. Dynamic Type을 키웠을 때 leading 아이콘·chevron이 위로 치우치던 것이 중앙정렬로 정정됐습니다 |
| **SegmentedControl** | `outlined` variant 제거. outlined를 쓰던 자리는 solid로 바뀝니다 |
| **ActionArea** | 투명 배경이 **스크롤 하단 도달 신호에 묶입니다.** 신호를 올려주지 않는 컨테이너(`SwiftUI.ScrollView`·`List`·스크롤 없는 팝업)에서는 배경이 불투명하게 보이므로 `scrollReachedEnd(_:)`로 직접 넘겨야 합니다. `extra` 슬롯 좌우 여백 20→24·하단 24→20, 구분선 옅어짐, 캡션이 `medium` weight로 굵어짐. **대체 액션 버튼 라벨이 파란색에서 검정으로, `cancel` 메인 버튼이 테두리형에서 회색 채움으로 바뀝니다** |
| **Avatar · AvatarGroup** | company·academy cornerRadius 전 사이즈 +2. 회사 로고가 조금 더 둥글어집니다 |
| **FallbackView** | 상하 최소 여백 160 내장. 밖의 여백·고정 높이를 정리하지 않으면 이중 적용. 설명 타이포가 `body2` → `body2Reading`으로 행간이 늘어납니다 |
| **입력 컴포넌트** | 라벨이 필드 위로, 에러가 필드 아래로, 카운터가 필드 아래 우측으로 나옵니다. 필드 높이와 폼 전체 높이가 달라집니다 |
| **글자수 카운터** | `Text("...")` 보간은 상한 1000 이상에서 천단위 구분자가 붙습니다(`5,000`). `Text(verbatim:)`을 쓰세요 |
| **disabled 표현** | 컴포넌트 자체 `opacity` → `isEnabled` 기반 색 토큰. 불투명도 이중 적용이 없어져 **덜 흐려 보입니다**. ListCell 슬롯에 넣은 커스텀 뷰(회사 로고 등)는 더 이상 흐려지지 않습니다 |
| **PlayBadge** | 배경에 `coolNeutral40` 28% 틴트 추가. 밝은 썸네일에서 뱃지가 보이게 됩니다 |
| **Toast · SnackBar** | 배경 불투명도 light 50% → 52%, dark 46% → 43% |
| **BottomSheet** | 배경 불투명도 80% → 88% |
| **SearchField** | solid 틴트 2겹, 비활성 outlined 배경이 `surfaceNeutralTertiary`로 |
| **TopNavigation · ModalNavigation** | 스크롤 배경 tint 농도가 `0.7` → `0.88`로 올라가 **스크롤 시 내비게이션 배경이 더 진해집니다** |
| **Typography `caption2`** | Dynamic Type 스케일 곡선이 `.caption2` → `.caption`. 기본 크기는 동일하고, 확대 단계에서 `caption2`가 `caption1`보다 커지던 위계 역전이 해소됩니다 |
| **Avatar · Thumbnail** | 비활성 시 `opacity43` 적용 |
| **Skeleton** | 텍스트 플레이스홀더 바 폭이 가변 → 균일 (로딩 중 한정) |
| **IconButton** | 글리프 동일, 터치 컨테이너만 확대 (약 6~8px 레이아웃 이동) |
| **RedOrange 토큰** | `accentForegroundRedOrange`·`accentBackgroundRedOrange`에 대응 토큰이 없어 무엇으로 옮기든 **색이 바뀝니다.** 이 토큰을 쓰던 자리를 전부 찾아 확인해주세요 |

---

## 체크리스트

- [ ] 컬러 시맨틱 토큰 치환 후 `grep -rn "\.label\(Normal\|Alternative\|Assistive\|Strong\|Neutral\|Disable\)\b"`로 잔존 확인
- [ ] `spacing(.pt` · `opacity(.p` 잔존 확인
- [ ] `.disable(` 잔존 확인 (`.disabled(`가 맞습니다)
- [ ] 모든 `TextField`/`TextArea`가 `FormControl`로 감싸졌는지
- [ ] 글자수 카운터가 `Text(verbatim:)`인지 - 상한 1000 이상 자리 우선
- [ ] `FallbackView` 사용처의 외부 `padding(.vertical,)` · `frame(height:)` 제거
- [ ] `.actionArea {}` 슬롯 안에 `if`문이 없는지
- [ ] Chip 슬롯 아이콘의 크기·색을 사용처에서 지정했는지
- [ ] 긴 라벨을 쓰는 버튼이 줄바꿈되어 레이아웃을 밀지 않는지
- [ ] `transparentBackground`를 `.manual`로 쓰던 자리에 `scrollReachedEnd(_:)`를 넘겼는지
- [ ] 스크롤 컨테이너가 없는 팝업·시트의 ActionArea 배경이 의도대로 보이는지
- [ ] `alternative` 액션과 `.cancel` variant를 쓰는 ActionArea의 버튼 색이 의도대로 보이는지
- [ ] [컴포넌트 스펙 리프레시](#8-컴포넌트-스펙-리프레시)·[시각 결과가 달라지는 변경](#시각-결과가-달라지는-변경) 목록의 화면을 실기기/시뮬레이터에서 확인

> 스펙 변경은 Blueprint를 두 버전으로 빌드해 대조하면 가장 빠르게 확인됩니다.
>
> ```bash
> git worktree add --detach ../baseline v3.15.2   # 올라오기 전 버전
> xcodebuild -workspace ../baseline/Montage.xcworkspace -scheme Blueprint \
>   -configuration Debug -destination 'id=<simulator udid>' \
>   -derivedDataPath /tmp/dd-before build
> ```

---

## 3.0

3.0 이전 버전에서 올라오는 경우는 [릴리즈 노트](https://github.com/wanteddev/montage-ios/releases)를 참고해주세요.
