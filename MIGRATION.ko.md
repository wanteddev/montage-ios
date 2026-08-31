# 마이그레이션 가이드

[English](./MIGRATION.md) | [한국어](./MIGRATION.ko.md)

메이저 버전 업그레이드에 필요한 변경 사항을 정리합니다. 최신 버전이 위에 옵니다.

**이 문서는 브레이킹 체인지만 다룹니다.** 새로 생긴 컴포넌트와 모디파이어는 [추가된 API](#추가된-api)에 이름만 모아뒀고, 자세한 내용은 [릴리즈 노트](https://github.com/wanteddev/montage-ios/releases)에 있습니다.

각 메이저 절의 기준선은 **직전 메이저의 마지막 릴리즈 태그**입니다. 개발 중에 생겼다가 없어진 API는 이전 버전 사용처가 겪을 일이 없으므로 적지 않습니다.

---

## 4.0

**기준선: v3.15.2 → 4.0.0**

브레이킹 체인지가 네 갈래입니다. 위에서 아래 순서로 진행하면 컴파일 에러가 가장 빨리 줄어듭니다.

| 순서 | 절 | 성격 | 하는 일 |
|---|---|---|---|
| 1 | [이름이 바뀐 것](#1-이름이-바뀐-것) | 기계적 치환 | `sed`로 끝납니다 |
| 2 | [없어져서 다시 짜야 하는 것](#2-없어져서-다시-짜야-하는-것) | 구조 재작성 | 대체 API로 옮깁니다 |
| 3 | [대응이 없는 것](#3-대응이-없는-것) | 직접 선택 | 사용처가 판단해야 합니다 |
| 4 | [화면이 달라지는 것](#4-화면이-달라지는-것) | 화면 확인 | **컴파일 에러가 나지 않습니다** |

**4번을 건너뛰지 마세요.** API는 그대로인데 값만 바뀐 항목이라 빌드가 통과해도 화면이 달라집니다. 치환이 끝났다고 마이그레이션이 끝난 게 아닙니다.

---

## 1. 이름이 바뀐 것

### 1.1 컬러 시맨틱 토큰

`Color.semantic(_:)` / `UIColor.semantic(_:)`에 넘기는 토큰 이름이 전부 바뀝니다. 대부분은 이름만 바뀌지만 **14건은 색값도 함께 바뀝니다.** [값이 함께 바뀌는 토큰](#값이-함께-바뀌는-토큰)을 꼭 확인해주세요.

#### 새 이름 규칙

```
용도 + 역할 + 변형

용도   foreground  텍스트·아이콘
       background  화면 바탕
       surface     화면 위 요소의 배경(카드·필드·버튼)
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

3.x에서 이름 중간에 붙던 `Solid`가 4.0에서는 맨 뒤 `Opaque`로 갑니다. **`lineSolidNormal` → `lineNeutralPrimaryOpaque`**처럼 자리까지 바뀐다는 점만 주의하면 됩니다.

#### Foreground - 텍스트·아이콘

| 3.x | 4.0 | 값 |
|---|---|---|
| `.labelNormal` | `.foregroundNeutralPrimary` | 동일 |
| `.labelStrong` | `.foregroundNeutralStrong` | 동일 |
| `.labelNeutral` | `.foregroundNeutralSecondary` | 동일 |
| `.labelAlternative` | `.foregroundNeutralTertiary` | 동일 |
| `.labelAssistive` | `.foregroundNeutralQuaternary` | 동일 |
| `.inverseLabel` | `.foregroundNeutralInverse` | **미세 변경** |
| `.labelDisable` | `.foregroundDisablePrimary` | 동일 |
| `.interactionInactive` | `.foregroundInactivePrimary` | 동일 |
| `.inversePrimary` | `.foregroundBrandInverse` | 동일 |
| `.statusPositive` | `.foregroundPositivePrimary` | 동일 |
| `.statusCautionary` | `.foregroundCautionaryPrimary` | 동일 |
| `.statusNegative` | `.foregroundNegativePrimary` | 동일 |
| `.accentForegroundBlue` | `.foregroundBrandPrimary` | **변경** |
| `.accentForegroundGreen` | `.foregroundPositivePrimary` | **변경** |
| `.accentForegroundOrange` | `.foregroundCautionaryPrimary` | **변경** |
| `.accentForegroundRed` | `.foregroundNegativeStrong` | **다크 변경** |
| `.accentForegroundLime` | `.foregroundAccentLime` | **다크 변경** |
| `.accentForegroundCyan` | `.foregroundAccentCyan` | **다크 변경** |
| `.accentForegroundLightBlue` | `.foregroundAccentLightBlue` | **다크 변경** |
| `.accentForegroundViolet` | `.foregroundAccentViolet` | **다크 변경** |
| `.accentForegroundPurple` | `.foregroundAccentPurple` | **다크 변경** |
| `.accentForegroundPink` | `.foregroundAccentPink` | **다크 변경** |
| `.accentForegroundRedOrange` | 대응 없음 | [3.1](#31-redorange-토큰) 참고 |

> `accentForeground{색}` 중 Blue·Green·Orange·Red는 **역할이 `Accent{색}`에서 `Brand`·`Positive`·`Cautionary`·`Negative`로 바뀌었습니다.** 이름만 옮기지 말고 그 자리가 정말 그 역할인지 확인해주세요.

#### Background · Surface - 화면 바탕과 요소 배경

| 3.x | 4.0 | 값 |
|---|---|---|
| `.backgroundNormal` | `.backgroundNeutralPrimary` | 동일 |
| `.backgroundNormalAlternative` | `.backgroundNeutralSecondary` | 동일 |
| `.backgroundElevated` | `.surfaceElevatedPrimary` | 동일 |
| `.backgroundElevatedAlternative` | `.surfaceElevatedSecondary` | 동일 |
| `.fillNormal` | `.surfaceNeutralSecondary` | 동일 |
| `.fillAlternative` | `.surfaceNeutralTertiary` | 동일 |
| `.fillStrong` | `.surfaceNeutralStrong` | 동일 |
| `.backgroundStatusPositive` | `.surfacePositivePrimary` | 동일 |
| `.backgroundStatusCautionary` | `.surfaceCautionaryPrimary` | 동일 |
| `.backgroundStatusNegative` | `.surfaceNegativePrimary` | 동일 |
| `.inverseBackground` | `.surfaceNeutralInverse` | 동일 |
| `.primaryNormal` | `.surfaceBrandPrimary` | 동일 |
| `.primaryStrong` | `.surfaceBrandStrong` | 동일 |
| `.primaryHeavy` | `.surfaceBrandHeavy` | 동일 |
| `.interactionDisable` | `.surfaceDisablePrimary` | 동일 |
| `.accentBackgroundLime` | `.surfaceAccentLimeOpaque` | 동일 |
| `.accentBackgroundCyan` | `.surfaceAccentCyanOpaque` | 동일 |
| `.accentBackgroundLightBlue` | `.surfaceAccentLightBlueOpaque` | 동일 |
| `.accentBackgroundViolet` | `.surfaceAccentVioletOpaque` | 동일 |
| `.accentBackgroundPurple` | `.surfaceAccentPurpleOpaque` | 동일 |
| `.accentBackgroundPink` | `.surfaceAccentPinkOpaque` | 동일 |
| `.accentBackgroundRedOrange` | 대응 없음 | [3.1](#31-redorange-토큰) 참고 |

> `background`는 화면 바탕(Primary·Secondary) 두 종만 남았습니다. 나머지 배경 토큰은 `surface`로, 투명 레이어인 `backgroundTransparent*`는 `effect`로 갈라졌습니다.
>
> `accentBackground{색}`은 기본이 **불투명(`Opaque`)** 대응입니다. 반투명 위에 겹쳐 쓰던 자리라면 접미사 없는 `.surfaceAccent{색}`(8% 알파)을 쓰세요.

#### Line - 테두리·구분선

| 3.x | 4.0 | 값 |
|---|---|---|
| `.lineNormal` | `.lineNeutralPrimary` | 동일 |
| `.lineNeutral` | `.lineNeutralSecondary` | 동일 |
| `.lineAlternative` | `.lineNeutralTertiary` | 동일 |
| `.lineSolidNormal` | `.lineNeutralPrimaryOpaque` | 동일 |
| `.lineSolidNeutral` | `.lineNeutralSecondaryOpaque` | 동일 |
| `.lineSolidAlternative` | `.lineNeutralTertiaryOpaque` | 동일 |
| `.linePrimaryNormal` | `.lineBrandPrimary` | 동일 |
| `.linePrimaryStrong` | `.lineBrandStrong` | 동일 |
| `.lineStatusPositiveNormal` | `.linePositivePrimary` | 동일 |
| `.lineStatusCautionaryNormal` | `.lineCautionaryPrimary` | 동일 |
| `.lineStatusNegativeNormal` | `.lineNegativePrimary` | 동일 |
| `.lineStatusNegativeStrong` | `.lineNegativeStrong` | 동일 |

#### Effect - 딤·투명 레이어

| 3.x | 4.0 | 값 |
|---|---|---|
| `.materialDimmer` | `.effectDimmerPrimary` | **다크 변경** |
| `.backgroundTransparent` | `.effectTransparentPrimary` | 동일 |
| `.backgroundTransparentAlternative` | `.effectTransparentSecondary` | 동일 |

#### 값이 함께 바뀌는 토큰

이름만 옮기면 **색이 달라집니다.** 아래 자리는 치환 후 눈으로 확인해주세요.

| 3.x → 4.0 | 라이트 | 다크 |
|---|---|---|
| `accentForegroundBlue` → `foregroundBrandPrimary` | `blue45` `#005EEB` → `blue50` `#0066FF` | `blue45` → `blue60` `#3385FF` |
| `accentForegroundGreen` → `foregroundPositivePrimary` | `green40` `#009632` → `green50` `#00BF40` | `green40` → `green60` `#1ED45A` |
| `accentForegroundOrange` → `foregroundCautionaryPrimary` | `orange39` `#D17600` → `orange50` `#FF9200` | `orange39` → `orange60` `#FFA938` |
| `accentForegroundRed` → `foregroundNegativeStrong` | 동일 (`red40`) | `red40` `#E52222` → `red60` `#FF6363` |
| `accentForegroundLime` → `foregroundAccentLime` | 동일 (`lime37`) | `lime37` `#429E00` → `lime50` `#58CF04` |
| `accentForegroundCyan` → `foregroundAccentCyan` | 동일 (`cyan40`) | `cyan40` `#0098B2` → `cyan50` `#00BDDE` |
| `accentForegroundLightBlue` → `foregroundAccentLightBlue` | 동일 (`lightBlue40`) | `lightBlue40` `#008DCF` → `lightBlue50` `#00AEFF` |
| `accentForegroundViolet` → `foregroundAccentViolet` | 동일 (`violet45`) | `violet45` `#5B37ED` → `violet70` `#9E86FC` |
| `accentForegroundPurple` → `foregroundAccentPurple` | 동일 (`purple40`) | `purple40` `#AD36E3` → `purple60` `#D478FF` |
| `accentForegroundPink` → `foregroundAccentPink` | 동일 (`pink46`) | `pink46` `#E846CD` → `pink60` `#FA73E3` |
| `materialDimmer` → `effectDimmerPrimary` | 동일 | `coolNeutral5` `#0F0F10` → `coolNeutral10` `#171719` (딤이 약간 밝아짐) |
| `inverseLabel` → `foregroundNeutralInverse` | `neutral99` `#F7F7F7` → `coolNeutral99` `#F7F7F8` | `neutral10` `#171717` → `coolNeutral10` `#171719` |

`accentForegroundBlue`·`Green`·`Orange` 세 개는 **라이트 모드에서도 확실히 달라집니다.** 나머지 accent 계열은 다크 모드에서 한 단계 밝아지고, `inverseLabel`은 1/255 수준이라 사실상 티가 나지 않습니다.

#### 표에 없는 토큰

프리미티브 토큰(`neutral*`, `blue*`, `coolNeutral*` …)은 이름·값 모두 그대로입니다.

4.0에서 새로 생긴 토큰(`lineBrandFocus`, `lineNegativeFocus`, `surfaceBrandSubtle`, `surfaceNegativeStrong`, `foregroundAccent*` 등)은 3.x에 대응이 없으므로 이 표에 없습니다. `Color.Semantic`에서 직접 확인해주세요.

> `Color.Semantic`의 doc 주석에 `(구 …)`로 3.x 이름이 적혀 있지만, 일부는 4.0 개발 중에만 존재했던 이름(`fillPrimary`, `fillNegative`, `interactionFocus`, `interactionNegative`)입니다. **3.x에서 올라온다면 이 문서의 표를 기준으로 삼으세요.**

#### 일괄 치환

3.x 토큰 이름이 4.0에 하나도 남지 않아서, `\b`로 끊어 치환하면 엉뚱한 데가 걸릴 일이 없습니다.

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

### 1.2 Spacing · Opacity 토큰

열거형을 거쳐 함수를 부르던 게 정적 프로퍼티 하나로 합쳐지고, 값이 이름에 그대로 들어갑니다.

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
| `.spacing(.pt01)` | `.spacing1` |
| `.spacing(.pt02)` | `.spacing2` |
| `.spacing(.pt04)` | `.spacing4` |
| `.spacing(.pt08)` | `.spacing8` |
| `.spacing(.pt12)` | `.spacing12` |
| `.spacing(.pt16)` | `.spacing16` |
| `.spacing(.pt20)` | `.spacing20` |
| `.spacing(.pt24)` | `.spacing24` |
| `.spacing(.pt28)` | **대응 없음** ([3.2](#32-spacing-pt28--pt36)) |
| `.spacing(.pt32)` | `.spacing32` |
| `.spacing(.pt36)` | **대응 없음** ([3.2](#32-spacing-pt28--pt36)) |
| `.spacing(.pt40)` | `.spacing40` |
| `.spacing(.pt48)` | `.spacing48` |
| `.spacing(.pt56)` | `.spacing56` |
| `.spacing(.pt64)` | `.spacing64` |
| `.spacing(.pt72)` | `.spacing72` |
| `.spacing(.pt80)` | `.spacing80` |

`pt08` → `spacing8`처럼 **앞자리 `0`이 없어집니다.** `spacing08`이 아닙니다.

Opacity는 16개가 1:1로 대응하고 값이 같습니다.

| 3.x | 4.0 |
|---|---|
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

Opacity 토큰의 타입이 `Double`로 바뀌었습니다. `withAlphaComponent(0)`처럼 숫자를 직접 넣던 자리도 `withAlphaComponent(.opacity0)`으로 정리할 수 있습니다.

`Color.spacing(_:)` / `Color.opacity(_:)` 정적 함수는 제거됐습니다.

---

### 1.3 전역 모디파이어

| 3.x | 4.0 | 비고 |
|---|---|---|
| `.disable(_:)` | `.disabled(_:)` | SwiftUI 표준 모디파이어로 흡수. 컴포넌트가 `isEnabled` 환경값을 읽습니다 |
| `scrollStatus.scrolledToMax` | `scrollStatus.reachedEnd` | `Montage.ScrollView`의 `ScrollStatus` 프로퍼티 |

`disable()` → `disabled()`는 이름만 바뀐 게 아닙니다. 3.x는 컴포넌트가 뷰 전체의 불투명도를 낮춰 흐리게 만들었고, 4.0은 SwiftUI `isEnabled` 값을 읽어 색 토큰(`foregroundDisablePrimary` 등)으로 바꿉니다. [4. 화면이 달라지는 것](#4-화면이-달라지는-것)을 확인해주세요.

`Chip`·`FilterButton`은 3.x에도 `disabled(_:)`가 있었지만 `Self`를 돌려주는 컴포넌트 자체 모디파이어였습니다. 4.0에서 이게 없어지고 SwiftUI 표준이 대신 잡히면서 반환 타입이 `some View`로 바뀝니다. **`.disabled()` 뒤에 컴포넌트 전용 모디파이어를 체이닝하던 자리는 컴파일 에러가 나니 `.disabled()`를 맨 뒤로 보내세요.**

```swift
// 3.x
Chip(variant: variant, size: size, text: text)
    .disabled(disable)
    .active(active)

// 4.0 - .disabled()가 Chip이 아니라 some View를 돌려준다
Chip(variant: variant, size: size, text: text)
    .active(active)
    .disabled(disable)
```

상위 뷰에 걸어 둔 `.disabled(true)`도 이제 두 컴포넌트의 색까지 바꿉니다. 3.x는 자체 프로퍼티로 색을 정해서 위에서 내려온 `.disabled()`는 터치만 막고 색은 그대로였습니다.

---

### 1.4 컴포넌트 API 리네임

#### ListCell

| 3.x | 4.0 |
|---|---|
| `ListCell(title:)` | `ListCell(label:)` |
| `.titleVariant(_:)` | `.labelVariant(_:)` |
| `.titleWeight(_:)` | `.labelWeight(_:)` |
| `.titleColor(_:)` | `.labelColor(_:)` |
| `.caption(_:)` | `.description(_:)` |
| `.fillWidth(false)` | `.variant(.inset)` (기본값) |
| `.fillWidth(true)` | `.variant(.full)` |

`inset`은 인터랙션 배경만 좌우 12 확장하고 모서리 16, `full`은 셀이 좌우 여백 20을 직접 갖습니다. 3.x의 `fillWidth(false)`·`fillWidth(true)`가 쓰던 값 그대로라 이름만 바꾸면 화면은 달라지지 않습니다.

슬롯 재구성은 [2.5 ListCell 슬롯](#25-listcell-슬롯)에 있습니다.

#### TopNavigation 슬롯 프리셋

프리셋 네임스페이스가 `컴포넌트.Resource.슬롯명` 패턴으로 통일됐습니다.

| 3.x | 4.0 |
|---|---|
| `TopNavigation.Resource.LeadingButtonInfo` | `TopNavigation.Resource.Leading` |
| `TopNavigation.Resource.TrailingButtonInfo` | `TopNavigation.Resource.Trailing` |

```swift
// 3.x
TopNavigation.LeadingButton(TopNavigation.Resource.LeadingButtonInfo.back(action: { dismiss() }))

// 4.0
TopNavigation.LeadingButton(TopNavigation.Resource.Leading.back(action: { dismiss() }))
```

#### 입력 컴포넌트

| 3.x | 4.0 | 대상 |
|---|---|---|
| `.heading(_:)` | `.label(_:required:)` | `TextField` · `TextArea` · `Select` |
| `.requiredBadge(_:)` | `.label(_:required:)`의 `required` | `TextField` · `TextArea` · `Select` |
| `.description(_:)` | `.message(_:)` | `TextArea` · `Select` |
| `.inputCharacterLimit(_:)` | `.maxLength(_:)` | `TextArea` |
| `.status(.negative(description:))` | `.status(.negative)` + `.message(_:)` | `TextField` |

`TextField.Status`에서 연관값이 빠졌습니다. `.normal()` → `.normal`, `.negative(description:)` → `.negative`.

구조가 바뀌는 부분은 [2.1 입력 컴포넌트의 라벨·메시지·카운터](#21-입력-컴포넌트의-라벨메시지카운터)에 있습니다.

#### Button · TextButton

`fill(horizontal:vertical:)`이 제거되고 `fillWidth(_:)`로 대체됐습니다.

| 3.x | 4.0 |
|---|---|
| `.fill(horizontal: true)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: false)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: true)` | `.fillWidth(true)` |

`vertical`은 3.x에서도 아무 일을 하지 않았습니다. 파라미터로 받기만 하고 함수 본문이 그 값을 버려서, `vertical: true`로 부르던 곳도 버튼 높이가 늘어난 적이 없습니다. 세 경우 모두 렌더 결과가 같으니 기계적으로 치환해도 됩니다.

#### IconButton

`normal` variant의 사이즈가 `Int`에서 `NormalSize` 열거형으로 바뀌었습니다.

| 3.x | 4.0 | 아이콘 글리프 | 컨테이너 |
|---|---|---|---|
| `.normal(size: 16)` | `.normal(size: .small)` | 16 | 24 |
| `.normal(size: 18)` | `.normal(size: .medium)` | 18 | 28 |
| `.normal(size: 20)` | `.normal(size: .large)` | 20 | 32 |
| `.normal(size: 24)` | `.normal(size: .xlarge)` | 24 | 36 |

글리프 크기는 그대로고 **터치 컨테이너만 커집니다.** 배경·테두리 없는 variant라 트레일링 아이콘이 약 6pt 움직이거나 행 높이가 약 8pt 늘어나는 정도입니다.

위 네 값 외의 크기는 [3.3 IconButton 비표준 크기](#33-iconbutton-비표준-크기)를 보세요.

#### PushBadge

| 3.x | 4.0 |
|---|---|
| `.new` | `.text("N")` |
| `.number(count)` | `.maxCount(count, max: 99)` |

한 글자일 때 최소 너비 + 패딩 대신 `badgeSize` 정사각(xsmall 16 / small 20 / medium 24)으로 고정됩니다. `N`처럼 좁은 글자는 픽셀 차이가 없고, 한글 한 글자나 `M`·`W`에서도 찌그러지지 않습니다.

확대 상한도 생겼습니다. 3.x는 글자 크기를 접근성 단계까지 키우면 뱃지도 계속 커졌지만, 4.0은 `xxxLarge`에서 멈춥니다. 뱃지가 얹히는 아이콘·아바타는 Dynamic Type을 따라 커지지 않아서, 뱃지만 계속 커지면 대상을 덮어버리기 때문입니다.

#### SegmentedControl

| 3.x | 4.0 |
|---|---|
| `Item(image:title:)` | `Item(leadingIcon:title:)` |
| `icon` 토글 | `.iconOnly(_:)` |

`variant(_:)` 모디파이어 제거는 [3.4](#34-segmentedcontrol-outlined-variant)를 보세요.

#### Accordion

`trailingContent`에서 인자 없는 오버로드가 빠지고 펼침 여부(`Bool`)를 받는 오버로드만 남았습니다.

```swift
// 3.x
.trailingContent { Chevron() }

// 4.0
.trailingContent { _ in Chevron() }
```

#### init에서 빠진 파라미터

비활성 여부와 배경색이 `init` 파라미터에서 모디파이어로 옮겨갔습니다.

| 3.x | 4.0 |
|---|---|
| `TopNavigation(scrollOffset:backgroundColor:)` | `TopNavigation(scrollOffset:)` + `.backgroundColor(_:)` |
| `TopNavigation.TrailingIconButton(icon:disable:showPushBadge:action:)` | `(icon:showPushBadge:action:)` + `.disabled(_:)` |
| `TopNavigation.TrailingTextButton(text:disable:action:)` | `(text:action:)` + `.disabled(_:)` |
| `framedStyle(status:borderRadius:shadowLevel:disabled:)` | `framedStyle(status:borderRadius:shadowLevel:)` + `.disabled(_:)` |

`disable:`을 넘기던 자리는 [1.3 전역 모디파이어](#13-전역-모디파이어)와 같은 방식으로 SwiftUI 표준 `.disabled(_:)`를 씁니다.

#### Skeleton

가변 폭 배열 대신 타이포그래피 `variant`를 받습니다. 줄 높이와 줄 수를 variant에서 자동 계산합니다.

```swift
// 3.x
Skeleton.SkeletonView(.text(lengths: [._25, ._50, ._75]))

// 4.0
Skeleton.SkeletonView(.text(variant: .body1))
```

플레이스홀더 바 폭이 가변(25/50/75/100%)에서 균일로 바뀝니다. 여러 줄을 흉내내려면 `SkeletonView`를 여러 개 놓으세요.

#### Avatar

`border(color:)`의 기본값이 `.lineAlternative`에서 `.lineNeutralTertiary`로 바뀌었습니다. 같은 색을 가리키는 새 이름이라 렌더 결과는 같습니다.

---

## 2. 없어져서 다시 짜야 하는 것

### 2.1 입력 컴포넌트의 라벨·메시지·카운터

3.x는 `TextField`가 라벨과 에러 메시지까지 자기 안에서 그렸습니다. 4.0은 `TextField`·`TextArea`·`Select` 세 컴포넌트가 입력 칸만 그리고, `label`·`message`·`accessory`를 붙이면 **`FormControl`이 감싸면서 라벨과 메시지를 대신 배치합니다.**

```swift
// 4.0에서 .label()·.message()를 붙이면 내부적으로 이렇게 됩니다
FormControl {
    TextField(text: $email)   // 입력만 그린다
}
.label("이메일")               // 라벨은 필드 위에
.message(errorMessage)         // 메시지는 필드 아래에
```

FormControl로 감싸는 건 자동이라 호출부는 모디파이어만 바꾸면 됩니다. 다만 **뷰 계층이 달라져서 필드 높이와 폼 전체 높이가 변합니다.** 이름만 바꾸는 치환이 아닙니다.

| 3.x (필드 내부) | 4.0 | 위치 |
|---|---|---|
| `.heading("이메일")` | `.label("이메일")` | 필드 **위** |
| `.requiredBadge(true)` | `.label("이메일", required: true)` | 라벨 옆 |
| `.status(.negative(description: msg))` | `.status(.negative)` + `.message(msg)` | 필드 **아래** |
| `.bottomResources(trailing: [.characterCount(limit:)])` | `.accessory { … }` | 필드 아래 **우측** |
| `.disable(_:)` | `.disabled(_:)` | - |

#### TextField

```swift
// 3.x
Montage.TextField(text: $email)
    .heading(String(localized: "이메일"))
    .placeholder(String(localized: "이메일을 입력해주세요."))
    .status(isInvalidated ? .negative(description: errorMessage) : .normal())
    .disable(isDisabled)

// 4.0
Montage.TextField(text: $email)
    .label(String(localized: "이메일"))
    .placeholder(String(localized: "이메일을 입력해주세요."))
    .status(isInvalidated ? .negative : .normal)
    .message(isInvalidated ? errorMessage : nil)
    .disabled(isDisabled)
```

라벨은 필드의 접근성 라벨로, 메시지는 접근성 힌트로 연결됩니다.

#### TextArea + 글자수 카운터

```swift
// 3.x
TextArea(text: $feedback, focus: $focus)
    .resize(.fixed(min: 116, max: 116))
    .placeholder("좋았던 점이나 아쉬운 점을 적어주세요.")
    .bottomResources(trailing: [.characterCount(limit: 1000)])

// 4.0
TextArea(text: $feedback, focus: $focus)
    .maxLength(1000)
    .resize(.fixed(min: 116, max: 116))
    .placeholder(String(localized: "좋았던 점이나 아쉬운 점을 적어주세요."))
    .accessory {
        Text(verbatim: "\(feedback.count)/1000")
            .typography(variant: .label2, weight: .medium, semantic: .foregroundNeutralTertiary)
    }
```

`.characterCount` 리소스가 제거됐습니다. 카운터는 이제 호출부가 직접 그립니다. 두 가지를 챙겨주세요.

- **입력 상한은 `maxLength(_:)`로 필드에 줍니다.** 카운터 표시와 입력 제한이 분리됐습니다.
- **`Text(verbatim:)`을 쓰세요.** `Text("\(count)/\(limit)")`는 `LocalizedStringKey` 보간을 타서 상한이 1000 이상일 때 로케일 천단위 구분자가 붙습니다(`5,000`). `verbatim:`이면 `5000`으로 나옵니다.

세 컴포넌트가 공통으로 갖는 모디파이어는 다섯 개입니다.

`.label(_:required:)` · `.message(_:)` · `.labelPlacement(_:)` · `.labelWidth(_:)` · `.accessory { }`

#### FormControl로 감싸는 경우

위 모디파이어를 하나라도 붙이면 내부에서 `FormControl`로 감싸지므로, 대부분의 화면은 `FormControl`을 쓸 일이 없습니다. 직접 쓰는 게 나은 경우는 셋입니다.

- 앱에서 직접 만든 입력 컴포넌트를 감쌀 때
- 어떤 입력 컴포넌트가 들어갈지 런타임에 바뀌어 래퍼 설정을 한곳에 모아야 할 때
- `FormControlGroup`으로 여러 필드의 라벨 폭을 맞출 때

```swift
FormControl { context in
    Montage.TextField(text: $email)
        .status(context.status.textFieldStatus)
        .placeholder(String(localized: "이메일을 입력해주세요."))
}
.label(String(localized: "이메일"))
.status(isInvalidated ? .negative : .normal)
.message(isInvalidated ? errorMessage : nil)
```

`size`·`status`는 **컴포넌트에 직접 준 값 → `FormControl` 전파값 → 기본값**(`.large` / `.normal`) 순으로 정해집니다. 슬롯 안까지 전파되므로 보통 `FormControl`에 한 번만 주면 됩니다. 반대로 컴포넌트에 상태를 따로 주면 라벨·메시지 색이 따로 놀 수 있으니, 위 예제처럼 `context.status`로 받아 내려주세요.

`FormControl`의 나머지 모디파이어: `size(.large/.medium)`, `labelPlacement(.top/.leading)`, `labelWidth(_:)`, `label(_:required:)`.

#### 자체 입력 래퍼가 있다면

`AutoCompleteTextInput`처럼 내부에 `TextField`를 감싼 래퍼는 **래퍼 자체를 `FormControl`로 감싸고**, 상태·메시지 파라미터를 래퍼 인터페이스로 노출하는 편이 낫습니다. 래퍼 안에서 `FormControl`을 쓰면 라벨을 밖에서 주기 어려워집니다.

---

### 2.2 TextArea 하단 리소스

`bottomResources`의 시그니처와 리소스 타입이 모두 바뀌었습니다.

```swift
// 3.x - 하나의 Resource 타입을 leading/trailing 양쪽에 넘김
public func bottomResources(
    leading leadingResources: [Resource] = [],
    trailing trailingResources: [Resource] = [],
    leadingResourceSpacing: CGFloat = 4,
    trailingResourceSpacing: CGFloat = 4
) -> Self

// 4.0 - 슬롯별로 타입이 갈림
public func bottomResources(
    leading: [Resource.Leading] = [],
    trailing: [Resource.Trailing] = [],
    leadingResourceSpacing: CGFloat? = nil,
    trailingResourceSpacing: CGFloat? = nil
) -> Self
```

- 인자 라벨이 `leading leadingResources:` → `leading:`으로 바뀌었습니다.
- 리소스 간 간격 기본값이 고정 `4`에서 **사이즈별 기본값(large 8 / medium 6)**으로 바뀝니다. 명시하지 않았다면 간격이 넓어집니다.

프리셋 대응은 이렇습니다.

| 3.x `Resource` | 4.0 |
|---|---|
| `.icon` | `Resource.Leading.icon` / `Resource.Trailing.icon` |
| `.iconButton` | `Resource.Leading.iconButton` / `Resource.Trailing.iconButton` |
| `.characterCount` | 제거 - [2.1](#21-입력-컴포넌트의-라벨메시지카운터)의 `accessory` |
| `.textButton` · `.chip` · `.filterButton` · `.badge` | **대응 없음** ([3.6](#36-textarea-하단-리소스-프리셋)) |
| - | `.contentBadge` · `.segmentedControl` 신설, trailing 전용 `.button` · `.primaryIconButton` 신설 |
| `.slot` 없음 | `Resource.Leading.slot { }` / `Resource.Trailing.slot { }` |

프리셋에 없는 구성은 `slot(_:)`으로 직접 넣습니다.

---

### 2.3 ActionArea

`Model` 구조체와 고정 파라미터가 사라지고 호출부가 뷰를 직접 넣습니다.

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

`BottomSheet`·`Popup`의 `modalActionArea(_:)`도 `ActionArea.Model?`에서 `(() -> ActionArea)?`로 바뀌었습니다.

`actionArea` 슬롯 클로저에는 `@ViewBuilder`가 **붙지 않습니다.** `if`문을 쓰면 `_ConditionalContent`가 되어 `ActionArea` 타입 제약이 깨집니다. 조건 분기는 삼항 연산자나 모디파이어 체인으로 처리하세요.

```swift
// 안 됩니다
.actionArea { if isEditing { ActionArea(variant: a) } else { ActionArea(variant: b) } }

// 이렇게
.actionArea { ActionArea(variant: isEditing ? a : b) }
```

#### 투명 배경 제어

투명 배경을 직접 제어하던 API가 없어졌습니다. 4.0에서는 배경과 상단 그라데이션이 스크롤 하단 도달 신호(`scrollReachedEnd`) 하나로 함께 결정됩니다.

| 3.x | 4.0 |
|---|---|
| `.transparentBackground(_:)` | 제거 |
| `ActionArea.BackgroundTransparencyControl` (`.automatic` / `.manual`) | 제거 |
| `actionArea(backgroundTransparency:)` | 제거 - `actionArea(scrollReachedEnd:)` |

| `scrollReachedEnd` | `extra` 슬롯 | 상단 그라데이션 | 배경 |
|---|---|---|---|
| 넘기지 않음 또는 `false` | 무관 | 표시 | 불투명 |
| `true` | 비어 있음 | 숨김 | **투명** |
| `true` | 있음 | 숨김 | 불투명 |

그라데이션은 "아래에 가려진 콘텐츠가 있다"는 신호이고 0.5초에 걸쳐 켜졌다 꺼집니다.

`Montage.ScrollView`를 쓰면 스크롤 바닥 도달이 자동 전달되므로 아무것도 넘기지 않아도 3.x의 `.automatic`과 같습니다. `SwiftUI.ScrollView`/`List`처럼 신호를 올려주지 않는 컨테이너를 쓸 때만 직접 넘기세요.

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

배경색 자체를 바꿔야 한다면 `backgroundColor(_:)`를 씁니다(배경과 그라데이션 시작색에 함께 적용). 두 방법으로 안 되는 화면이 있으면 [이슈](https://github.com/wanteddev/montage-ios/issues)로 알려주세요.

스펙 변경은 [4. 화면이 달라지는 것](#4-화면이-달라지는-것)에 있습니다.

---

### 2.4 View.topNavigation(...) 제거

화면 상단을 붙이던 `View.topNavigation(...)` 모디파이어 두 개가 통째로 사라졌습니다. `TopNavigation` 컴포넌트를 직접 배치하거나, 새로 생긴 `ScreenScaffold`로 화면을 조립합니다.

```swift
// 3.x
content
    .topNavigation(
        title: "설정",
        leadingContent: { TopNavigation.LeadingButton(.back(action: { dismiss() })) },
        withBottom: .init(variant: .neutral(main: .init(text: "저장", action: save)))
    )

// 4.0
ScreenScaffold(
    navigation: {
        TopNavigation(title: "설정")
            .leadingContent { TopNavigation.LeadingButton(.back(action: { dismiss() })) }
    },
    actionArea: {
        ActionArea(variant: .neutral(main: .init(text: "저장", action: save)))
    }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

`ScreenScaffold`는 `TopNavigation` + 본문 + `ActionArea`를 한 화면으로 조립하면서 화면마다 손으로 맞추던 스크롤 오프셋 전달과 하단 여백 계산을 대신합니다.

`ActionArea`를 `safeAreaInset(edge: .bottom)`으로 넣기 때문에 스크롤 컨테이너가 그만큼 콘텐츠 인셋을 잡습니다. **바닥까지 내렸을 때 마지막 요소가 버튼에 가리지 않도록 호출부가 손으로 비워 주던 여백은 지우세요.**

| `scrollContainer` | 언제 |
|---|---|
| `.builtIn` (기본) | 스캐폴드가 `Montage.ScrollView`를 깔고 스크롤 상태를 직접 잼 |
| `.custom` | `List`처럼 컨테이너를 바꿀 수 없을 때. 콘텐츠가 `reportsScrollOffset(_:)`·`reportsScrollReachedEnd(_:)`로 신호를 올려야 함 |

`navigation`·`actionArea` 슬롯 클로저에도 **`@ViewBuilder`가 붙지 않습니다.** 조건부로 넣을 때는 `actionArea: isEditing ? slot : nil`처럼 클로저 자체를 갈라 주세요.

`BottomSheet`·`Popup` 안에는 넣지 않습니다. 두 컴포넌트가 같은 일을 하고 `ActionArea` 높이를 자기 높이 계산에 쓰므로 그쪽 `actionArea:` 인자로 넘기세요. 전체 화면 커버나 push한 화면은 시트가 아니므로 여기에 해당하지 않습니다.

`List`를 쓸 때는 행 배경과 스크롤 배경을 **둘 다** 걷어내야 합니다. 하나만 처리하면 `backgroundColor(_:)`로 지정한 색이 가려지고, `ActionArea`가 바닥에서 투명해질 때 그 경계가 드러납니다.

---

### 2.5 ListCell 슬롯

`leadingContent {}` / `trailingContent {}`가 프리셋 배열을 받는 네 개의 슬롯 모디파이어로 바뀌었습니다.

| 3.x | 4.0 |
|---|---|
| `.leadingContent { … }` | `.leadingResources([.slot { … }])` |
| `.trailingContent { _ in … }` | `.trailingResources([.slot { … }])` |
| `.interactionPadding(_:)` | 제거 - `variant(_:)`에 통합 |
| `.verticalAlign(_:)`의 타입 `VerticalAlignment` | `ListCell.VerticalAlign` |

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

슬롯이 네 개로 늘었습니다: `leadingResources`, `labelTrailingResources`, `trailingResources`, `extraResources`. 자주 쓰는 조합은 프리셋으로 있습니다.

```swift
.leadingResources([.icon(.search), .checkbox(checked: isChecked)])
.leadingResources([.radio(checked: isSelected)])
.leadingResources([.avatar(url, variant: .company)])
.leadingResources([.thumbnail(url)])
.leadingResources([.slot { AnyCustomView() }])   // 프리셋에 없으면 slot
```

`.verticalAlign(.bottom)`은 [3.5](#35-listcell-verticalalignbottom)를 보세요.

---

### 2.6 Chip 이미지 슬롯

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

---

### 2.7 FallbackView 여백

`init`에서 `image:`와 `button:`이 빠졌습니다.

| 3.x | 4.0 |
|---|---|
| `FallbackView(image:title:description:button:)` | `FallbackView(title:description:)` |
| `button:` 슬롯 | `buttonActionArea(_:)` |
| `image:` 슬롯 | **대응 없음** ([3.7](#37-fallbackview-이미지-슬롯)) |

여백을 지정하는 `Padding` 열거형도 생기고 **상하 최소 여백이 컴포넌트에 내장됐습니다.**

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

### 2.8 제거된 UIKit 래퍼

deprecated UIKit 래퍼가 제거됐습니다. SwiftUI 컴포넌트를 `UIHostingController`로 브리징하세요.

| 제거됨 | 대체 |
|---|---|
| `Montage.Button.SolidUIButton` | `Montage.Button(variant: .solid, …)` |
| `Montage.Button.OutlinedUIButton` | `Montage.Button(variant: .outlined, …)` |
| `ContentBadgeUIView` | `ContentBadge(…)` |
| `InteractionUIView` | `Interaction` 모디파이어 |

스펙은 동일하므로 렌더 결과에 차이가 없습니다.

---

## 3. 대응이 없는 것

기계적 대응이 없어 **사용처가 직접 골라야 하는** 항목입니다. 비슷한 걸 임의로 넣으면 결과가 달라진 걸 모르고 넘어가게 됩니다.

### 3.1 RedOrange 토큰

`accentForegroundRedOrange`와 `accentBackgroundRedOrange`에 대응하는 4.0 토큰이 없습니다. 프리미티브 `redOrange*`는 그대로 남아 있습니다.

1:1 치환이 불가능하니 그 자리의 의도를 보고 직접 골라야 하고, **무엇을 고르든 색이 바뀝니다.**

원티드 앱은 이 토큰을 쓰던 세 곳이 모두 텍스트·아이콘 색이어서 `.foregroundNegativePrimary`로 옮겼고, 그 결과 `redOrange50/60`이 `red50/60`으로 바뀌었습니다. 배경색으로 쓰던 자리라면 `.surfaceNegativePrimary`나 프리미티브 `redOrange*` 직접 지정이 원래 값에 더 가깝습니다.

### 3.2 Spacing pt28 · pt36

4.0 Spacing 스케일에 `28`과 `36`이 없습니다. 새 스케일은 `0, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 40, 48, 56, 64, 72, 80`입니다.

`.spacing(.pt28)` / `.spacing(.pt36)`을 쓰던 자리는 `spacing24`·`spacing32`·`spacing40` 중에서 골라야 하고, **레이아웃이 4pt씩 움직입니다.** 스케일을 벗어난 값이 꼭 필요하면 리터럴을 씁니다. 다만 리터럴이 여러 곳에 생긴다면 그 화면의 간격 설계를 다시 볼 신호입니다.

```bash
grep -rn "spacing(\.pt28\|spacing(\.pt36" --include="*.swift" .
```

### 3.3 IconButton 비표준 크기

표준 4개(16·18·20·24) 외의 크기를 쓰던 자리는 `NormalSize.custom(size:)`로 옮기는데, **`size`의 의미가 아이콘 크기에서 컨테이너 크기로 바뀝니다.**

3.x의 `.normal(size: n)`은 컨테이너가 아이콘과 같은 `n`이었지만, 4.0의 `.custom(size: n)`은 `n`이 컨테이너 한 변이고 아이콘은 컨테이너의 2/3에 가장 가까운 dimension 토큰으로 정해집니다. 컨테이너는 `[24, 64]`로 clamp됩니다.

```swift
// 3.x - n은 아이콘 크기
IconButton(variant: .normal(size: 22), icon: .search)

// 4.0 - n은 컨테이너 크기, 아이콘은 여기서 도출된다
IconButton(variant: .normal(size: .custom(size: 32)), icon: .search)  // 아이콘 20
```

3.x 값을 그대로 넣으면 아이콘이 작아집니다. `.custom(size: 22)`는 컨테이너가 24로 clamp되어 아이콘이 16이 됩니다. 원하는 아이콘 크기가 나오는 컨테이너 값을 직접 골라야 합니다.

| 컨테이너 | 24 | 28 | 32 | 36 | 40 | 48 | 56 | 64 |
|---|---|---|---|---|---|---|---|---|
| 아이콘 | 16 | 18 | 20 | 24 | 28 | 32 | 36 | 40 |

### 3.4 SegmentedControl outlined variant

`Variant` 열거형과 `variant(_:)` 모디파이어가 통째로 제거됐습니다. `outlined`를 쓰던 자리는 `solid` 하나로 통합되고 **테두리형이 사라집니다.**

### 3.5 ListCell verticalAlign(.bottom)

`.top` / `.center`만 남았습니다. 하단 정렬이 필요하던 자리는 슬롯 구성을 다시 짜거나 `.top`으로 맞춰야 합니다.

### 3.6 TextArea 하단 리소스 프리셋

`Resource.textButton` · `.chip` · `.filterButton` · `.badge`가 제거됐습니다. `Resource.Leading.slot { }` / `Resource.Trailing.slot { }`으로 직접 그리거나, trailing이라면 새로 생긴 `.button` · `.contentBadge`가 의도에 맞는지 확인해주세요.

### 3.7 FallbackView 이미지 슬롯

3.x는 `image:`로 삽화를 넣을 수 있었지만 4.0 `FallbackView`에는 이미지 관련 API가 없습니다. 제목과 설명, 버튼 영역만 남았습니다.

삽화가 꼭 필요하면 `FallbackView`를 쓰지 않고 호출부에서 직접 조립해야 합니다. 그대로 두면 **빈 화면에서 삽화가 사라집니다.**

### 3.8 AvatarGroup variant

`AvatarGroup(_:variant:size:onTap:)`에서 `variant:`가 빠지고 `.person`으로 고정됐습니다. 3.x에서 `company`·`academy`로 회사·학원 로고를 묶어 보여주던 자리는 4.0에서 **모서리가 둥근 사각형이 아니라 원형으로 바뀝니다.**

컴파일 에러가 나므로 인자를 지우게 되는데, 그 자리의 렌더 결과가 달라진다는 걸 같이 확인해주세요.

### 3.9 TextField 트레일링 버튼 색

`TextField.TrailingButtonInfo(variant:title:disable:handler:)`에서 `variant: Button.Color`가 빠졌습니다. 4.0은 outlined 한 가지로 고정됩니다. `primary`로 강조하던 인증 버튼 등은 색이 바뀝니다.

### 3.10 그 밖의 제거된 API

| 제거됨 | 비고 |
|---|---|
| `ModalNavigation.Variant.extended` | 대응 없음 |
| `ModalNavigation.Variant.floating(alternative:background:)` | 인자 없는 `.floating`만 남음 |
| `Select.shadowBackgroundColor(_:)` | 대응 없음 |
| `Skeleton.Length` (`_25`/`_50`/`_75`/`_100`) | 폭이 균일로 고정 |

---

## 4. 화면이 달라지는 것

**컴파일은 통과하지만 화면이 달라지는 항목입니다.** API가 그대로라 치환 작업이 끝난 뒤 화면을 봐야 드러납니다.

### 4.1 컴포넌트 스펙

#### Button

| 항목 | 3.x | 4.0 |
|---|---|---|
| radius | large 12 / medium 10 / small 8 | large **14** / medium **12** / small **10** / xsmall 8 |
| 높이 제약 | `.frame(height:)` 고정 | `.frame(minHeight:)` |
| 아이콘 크기 | large 24 / medium 24·22 / small 20·18 | large 22 / medium 22·20 / small 20·16 / xsmall 16 |
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
| min-height | - | 증가 (필드가 높아짐) |
| 테두리 색 | - | 옅어짐 |
| 세로 정렬 | 항상 `top` | `overflow`일 때만 `top`, 그 외 `center` |

세로 정렬은 Dynamic Type을 키웠을 때만 눈에 띕니다. 3.x는 항상 `top` 정렬이라 텍스트 높이가 leading 아이콘·chevron(24pt)을 넘어서면 **아이콘만 위로 치우쳐** 보였습니다. 4.0은 여러 줄로 흐르는 `overflow` 상태에서만 `top`을 쓰고 한 줄일 때는 `center`로 맞춥니다. 선택 목록의 `ListCell`도 `verticalAlign(.center)`가 붙어 라디오·체크박스가 라벨 중앙에 옵니다.

#### ActionArea

| 항목 | 3.x | 4.0 |
|---|---|---|
| `extra` 슬롯 좌우 여백 | 20 | **24** |
| `extra` 슬롯 하단 여백 | 24 | **20** |
| `extra` 구분선 색 | `lineNeutral` (= `lineNeutralSecondary`) | `lineNeutralTertiary` (옅어짐) |
| 캡션 타이포 | `label2` | `label2` + `weight: .medium` (굵어짐) |
| 대체(`alternative`) 액션 버튼 | `outlined` / `primary` | `outlined` / **`assistive`** |
| `cancel` 메인 액션 버튼 | `outlined` / `assistive` | **`solid`** / `assistive` |

메인 버튼 행의 좌우 여백 20은 그대로입니다.

버튼 색상은 API가 그대로라 컴파일 에러가 나지 않습니다. 대체 액션은 라벨이 파란색에서 검정으로 바뀌어 주 액션과의 대비가 커지고, `cancel` variant의 메인 버튼은 테두리형에서 회색 채움으로 바뀝니다. 보조(`sub`) 액션은 변경이 없습니다.

#### TopNavigation · ModalNavigation

| 항목 | 3.x | 4.0 |
|---|---|---|
| 스크롤 배경 tint | `backgroundOpacity * 0.7` | `backgroundOpacity * 0.88` |
| 아이콘 버튼 press | 아이콘 뒤 회색 사각 레이어 | 아이콘 색만 `foregroundNeutralQuaternary`로 |

콘텐츠를 스크롤해 내비게이션 배경이 나타나는 구간에서 **배경이 더 진해집니다.**

`IconButton`의 컨테이너(36pt)가 내비게이션 바의 `.frame(24)`보다 커서 press 레이어가 버튼 밖으로 삐져나와 보였습니다. 4.0은 레이어 대신 아이콘 색으로 피드백합니다. 터치 영역은 그대로입니다. leading(`back`·`icon`)과 trailing 아이콘 버튼에 모두 적용되며, 텍스트 버튼은 해당 없습니다.

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

이미지가 없을 때 그리는 플레이스홀더도 전용 일러스트에서 아이콘 글리프(`personFill` / `companyFill` / `graduationFill`)로 바뀌었습니다. 푸시뱃지 inset도 사이즈별로 조정됐습니다.

#### 그 외

`Shadow` · `Typography` · `Opacity` · `Spacing` 정의와 `Toast` · `SnackBar` · `Popup` · `Popover` · `Tooltip` · `Thumbnail` · `Accordion` · `Category` · `ProgressTracker`도 값이 조정됐습니다.

### 4.2 전체 목록

**마이그레이션 후 이 목록의 화면을 눈으로 확인해주세요.**

| 대상 | 무엇이 달라지나 |
|---|---|
| **컬러 토큰** | `accentForegroundBlue`·`Green`·`Orange`는 라이트·다크 모두, 나머지 `accentForeground*`와 `materialDimmer`는 다크에서 색이 바뀝니다. [값이 함께 바뀌는 토큰](#값이-함께-바뀌는-토큰) 참고 |
| **RedOrange 토큰** | 대응 토큰이 없어 무엇으로 옮기든 **색이 바뀝니다.** 쓰던 자리를 전부 찾아 확인해주세요 |
| **Spacing pt28 · pt36** | 대응 값이 없어 24/32/40 중 하나를 골라야 하고 레이아웃이 4pt씩 움직입니다 |
| **Button** | 높이 제약이 고정에서 최소값으로 바뀌어 **긴 라벨이 말줄임 대신 줄바꿈**됩니다. 버튼이 세로로 커져 주변 레이아웃이 밀립니다. radius도 사이즈별로 +2 |
| **Chip · FilterButton** | 타이포가 한 단계 내려가고 패딩이 줄어 **작아집니다.** 가로로 나열되는 칩·필터 바의 줄바꿈 지점이 달라집니다 |
| **Select** | min-height가 올라가 **선택 필드가 높아집니다.** 테두리 색도 옅어집니다. Dynamic Type을 키웠을 때 leading 아이콘·chevron이 위로 치우치던 것이 중앙정렬로 정정됐습니다 |
| **SegmentedControl** | `outlined` variant 제거. outlined를 쓰던 자리는 solid로 바뀝니다 |
| **ActionArea** | 투명 배경이 **스크롤 하단 도달 신호에 묶입니다.** 신호를 올려주지 않는 컨테이너(`SwiftUI.ScrollView`·`List`·스크롤 없는 팝업)에서는 그라데이션과 불투명 배경이 그대로 남으므로 `scrollReachedEnd(true)`를 직접 넘겨야 합니다. 배경이 투명해지는 건 `extra` 슬롯이 비어 있을 때뿐입니다. `extra` 슬롯 좌우 여백 20→24·하단 24→20, 구분선 옅어짐, 캡션이 `medium` weight로 굵어짐. **대체 액션 버튼 라벨이 파란색에서 검정으로, `cancel` 메인 버튼이 테두리형에서 회색 채움으로 바뀝니다** |
| **AvatarGroup variant** | `variant:`가 `.person` 고정이라 company·academy로 묶던 그룹이 **둥근 사각형에서 원형으로** 바뀝니다 |
| **Avatar · AvatarGroup** | company·academy cornerRadius 전 사이즈 +2. 이미지 없을 때 플레이스홀더가 일러스트에서 아이콘 글리프로 교체. 비활성 시 `opacity43` 적용 |
| **FallbackView** | `image:` 슬롯이 없어져 **삽화가 사라집니다.** 상하 최소 여백 160 내장. 밖의 여백·고정 높이를 정리하지 않으면 이중 적용. 설명 타이포가 `body2` → `body2Reading`으로 행간이 늘어납니다 |
| **TextField 트레일링 버튼** | `variant:`가 없어져 outlined로 고정됩니다. `primary`로 강조하던 버튼의 색이 바뀝니다 |
| **입력 컴포넌트** | 라벨이 필드 위로, 에러가 필드 아래로, 카운터가 필드 아래 우측으로 나옵니다. 필드 높이와 폼 전체 높이가 달라집니다 |
| **TextArea 하단 리소스** | 리소스 간 간격 기본값이 고정 4에서 사이즈별(large 8 / medium 6)로 바뀝니다 |
| **글자수 카운터** | `Text("...")` 보간은 상한 1000 이상에서 천단위 구분자가 붙습니다(`5,000`). `Text(verbatim:)`을 쓰세요 |
| **비활성 상태** | 컴포넌트가 직접 낮추던 불투명도 대신 `isEnabled` 기반 색 토큰을 씁니다. 불투명도가 겹쳐 적용되지 않아 **덜 흐려 보입니다.** ListCell 슬롯에 넣은 커스텀 뷰(회사 로고 등)는 이제 흐려지지 않습니다. **상위 뷰의 `.disabled(true)`가 `Chip`·`FilterButton` 색까지 바꿉니다**(3.x는 터치만 막혔습니다) |
| **PushBadge** | 한 글자 뱃지가 `badgeSize` 정사각으로 고정됩니다. 확대 상한이 생겨 접근성 글자 크기에서 3.x보다 작게 나옵니다 |
| **PlayBadge** | 배경에 `coolNeutral40` 28% 틴트 추가, 재생 아이콘이 `staticWhite` 88%로. 밝은 썸네일에서도 뱃지가 묻히지 않습니다 |
| **TopNavigation · ModalNavigation** | 스크롤 시 배경이 더 진해집니다. **아이콘 버튼을 눌렀을 때 회색 사각 레이어 대신 아이콘 색만 옅어집니다** |
| **Toast · SnackBar** | 배경 불투명도 light 50% → 52%, dark 46% → 43% |
| **BottomSheet** | 배경 불투명도 80% → 88% |
| **TopNavigation · ModalNavigation** | 스크롤 배경 tint 농도가 `0.7` → `0.88`로 올라가 **스크롤 시 내비게이션 배경이 더 진해집니다** |
| **Typography `caption2`** | Dynamic Type 스케일 곡선이 `.caption2` → `.caption`. 기본 크기는 그대로고, 확대했을 때 `caption2`가 `caption1`보다 커지던 문제가 없어집니다 |
| **Thumbnail** | 비활성 시 `opacity43` 적용 |
| **Skeleton** | 텍스트 플레이스홀더 바 폭이 가변 → 균일 (로딩 중 한정) |
| **IconButton** | 글리프 동일, 터치 컨테이너만 확대 (약 68pt 레이아웃 이동) |

---

## 추가된 API

**마이그레이션에 필요 없습니다.** 4.0에서 새로 쓸 수 있게 된 것들이라 참고용으로만 적어둡니다. 자세한 사용법은 [DocC 문서](./documentation)와 Blueprint 샘플 앱에 있습니다.

### 신규 컴포넌트

#### ScreenScaffold

`TopNavigation` + 본문 + `ActionArea`를 한 화면으로 조립합니다. 화면마다 손으로 맞추던 스크롤 오프셋 전달과 하단 여백 계산을 대신합니다. 제거된 `View.topNavigation(...)`의 대체 수단이기도 해서 마이그레이션 중에도 등장합니다([2.4](#24-viewtopnavigation-제거)).

```swift
ScreenScaffold(
    navigation: { TopNavigation(title: "설정") },
    actionArea: { ActionArea(variant: .neutral(main: .init(text: "저장", action: save))) }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

#### SearchField

검색어 입력 컴포넌트입니다. 왼쪽 검색 아이콘과 입력 영역으로 구성되고, 입력값이 있으면 오른쪽에 지우기 버튼이 나타납니다. 크기 체계는 `TextField`와 같습니다. `TopNavigation`의 검색 모드도 이 컴포넌트를 씁니다.

```swift
SearchField(text: $keyword)
    .placeholder("검색어를 입력해 주세요.")
    .onSubmit { search(keyword) }

// 테두리형, medium
SearchField(text: $keyword)
    .variant(.outlined)
    .size(.medium)
```

#### FormControl · FormControlGroup

`FormControl`은 입력 컴포넌트의 라벨·메시지·accessory를 배치합니다. 컴포넌트에 모디파이어를 직접 붙이면 내부에서 알아서 감싸므로 직접 쓸 일은 많지 않습니다([2.1](#21-입력-컴포넌트의-라벨메시지카운터)).

`FormControlGroup`은 라벨을 왼쪽에 두는 입력을 여러 개 쌓을 때 라벨 열 폭을 가장 긴 라벨에 맞춥니다. 호출부에 고정 폭을 박지 않아도 되고, Dynamic Type이나 다국어로 라벨 길이가 바뀌어도 알아서 다시 맞춥니다.

```swift
FormControlGroup {
    TextField(text: $name)
        .labelPlacement(.leading)
        .label("이름")

    TextField(text: $email)
        .labelPlacement(.leading)
        .label("이메일 주소")
}
// 라벨 열이 "이메일 주소" 폭으로 통일되고 두 입력의 시작 위치가 맞는다
```

### 신규 토큰 그룹

`Radius` · `Dimension` · `Primitive` · `MaterialBackground`. 각각 `CGFloat` 확장으로 노출되고 `allValues` · `min` · `max`를 제공합니다.

시맨틱 토큰도 새로 생긴 게 있습니다: `lineBrandFocus`, `lineNegativeFocus`, `surfaceBrandSubtle`, `surfaceNegativeStrong`, `foregroundAccent*`, `lineAccent*`, `surfaceAccent*`(반투명 8%).

### 컴포넌트별 추가

| 컴포넌트 | 추가된 것 |
|---|---|
| `Button` | 사이즈 `xsmall`, color `negative` |
| `TextButton` | `fillWidth(_:)` |
| `IconButton` | `interactionEffect(_:)`, `interactionColor(_:)` |
| `ActionArea` | `caption(_:icon:)`의 아이콘 슬롯(16pt), `scrollReachedEnd(_:)`, `backgroundColor(_:)` |
| `TopNavigation` | `backgroundColor(_:)` |
| `Chip` | `borderColor(_:)` |
| `Category` | `itemDisabled(_:)` |
| `PushBadge` | `outlineBorder(_:color:)` |
| `ListCell` | `verticalPadding(.custom(_:))`, 슬롯 4개(`leading` · `labelTrailing` · `trailing` · `extra`) |
| `Select` | `size(.large/.medium)` |
| `TextField` · `TextArea` | `autocorrectionDisabled(_:)`, `onTextChange(_:)`, `size(_:)` |
| `Shadow` | `shadow(_:) -> some ShapeStyle` |
| `UIColor` | Montage 토큰 확장 |

---

## 체크리스트

### 치환

- [ ] 컬러 시맨틱 토큰 치환 후 `grep -rn "\.label\(Normal\|Alternative\|Assistive\|Strong\|Neutral\|Disable\)\b"`로 남은 곳 확인
- [ ] `spacing(.pt` · `opacity(.p` 남은 곳 확인
- [ ] `grep -rn "spacing(\.pt28\|spacing(\.pt36"` - 대응 없는 값
- [ ] `.disable(` 남은 곳 확인 (`.disabled(`가 맞습니다)
- [ ] `Chip`·`FilterButton`의 `.disabled()` 뒤에 컴포넌트 전용 모디파이어를 체이닝한 자리가 없는지
- [ ] `.topNavigation(` 남은 곳 확인
- [ ] `accentForegroundRedOrange` · `accentBackgroundRedOrange` 사용처 전수 확인
- [ ] `FallbackView(image:` · `AvatarGroup(` 의 `variant:` · `TrailingButtonInfo(variant:` 사용처 확인

### 구조

- [ ] 3.x의 `heading`·`requiredBadge`·`description`을 `label`·`message`로 옮겼는지
- [ ] 글자수 카운터가 `Text(verbatim:)`인지 - 상한 1000 이상 자리 우선
- [ ] `FallbackView` 사용처의 외부 `padding(.vertical,)` · `frame(height:)` 제거
- [ ] `.actionArea {}` · `ScreenScaffold` 슬롯 안에 `if`문이 없는지
- [ ] Chip 슬롯 아이콘의 크기·색을 사용처에서 지정했는지
- [ ] `transparentBackground`를 `.manual`로 쓰던 자리에 `scrollReachedEnd(_:)`를 넘겼는지

### 화면 확인

- [ ] `accentForeground{Blue,Green,Orange}`를 쓰던 화면의 색 (라이트·다크 둘 다)
- [ ] 나머지 `accentForeground*` · `materialDimmer` 다크 모드
- [ ] 긴 라벨을 쓰는 버튼이 줄바꿈되면서 높아진 만큼 주변 레이아웃이 밀려도 괜찮은지
- [ ] 스크롤 컨테이너가 없는 팝업·시트의 ActionArea 배경
- [ ] `alternative` 액션과 `.cancel` variant를 쓰는 ActionArea의 버튼 색
- [ ] 이미지 없는 Avatar의 플레이스홀더
- [ ] 삽화를 쓰던 `FallbackView` 화면과 company·academy `AvatarGroup`
- [ ] [4. 화면이 달라지는 것](#4-화면이-달라지는-것) 목록의 화면을 실기기/시뮬레이터에서 확인

스펙 변경은 Blueprint를 두 버전으로 빌드해 대조하는 게 가장 빠릅니다. `UDID`에는 `xcrun simctl list devices`로 확인한 값을 넣습니다.

```bash
UDID=... # xcrun simctl list devices

git worktree add --detach ../baseline v3.15.2
xcodebuild -workspace ../baseline/Montage.xcworkspace -scheme Blueprint \
  -configuration Debug -destination "id=$UDID" \
  -derivedDataPath /tmp/dd-before build
```

---

## 3.0

3.0 이전 버전에서 올라오는 경우는 [릴리즈 노트](https://github.com/wanteddev/montage-ios/releases)를 참고해주세요.
