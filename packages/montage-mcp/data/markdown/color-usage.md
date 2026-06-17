---
title: Color
description: 디자인 시스템에서 미리 정의된 컬러 네임스페이스
---

```swift
enum Color
```

## Overview

Color는 모든 Montage 컴포넌트에서 일관된 색상을 사용할 수 있도록 설계된 색상 체계를 제공합니다. Atomic과 Semantic으로 구분된 두 가지 색상 타입을 지원합니다.

```swift
// Atomic 색상 사용
let atomicColor = Color.Atomic.blue50
let uiColor = UIColor.atomic(.blue50)
let swiftUIColor = SwiftUI.Color.atomic(.blue50)

// Semantic 색상 사용
let semanticColor = Color.Semantic.primaryNormal
let uiColor = UIColor.semantic(.primaryNormal)
let swiftUIColor = SwiftUI.Color.semantic(.primaryNormal)
```

>  **Note**
>
> UI 구성요소를 개발할 때는 직접 Atomic 색상을 사용하기보다 Semantic 색상을 사용하는 것이 권장됩니다. 이는 다크 모드와 같은 다양한 환경에서 일관된 디자인을 유지하는 데 도움이 됩니다.

>  **Warning**
>
> **`Color` 네임스페이스 충돌**
>
> Montage는 `public enum Color`(이 문서의 enum)와 `extension SwiftUI.Color { static func semantic/atomic }`를 동시에 정의합니다. 그래서 표현식 `Color.semantic(.foo)`는 SwiftUI.Color로 잘 해석되지만, **타입 어노테이션 위치**에서 그냥 `Color`라고 쓰면 컴파일러가 `Montage.Color`(enum)로 추론하여 `Cannot convert value of type 'SwiftUI.Color' to specified type 'Color'` 에러를 냅니다.
>
> stored property·return type·parameter type 등 타입 위치에는 반드시 **`SwiftUI.Color`** 로 한정 표기하십시오.
>
> ```swift
> // ✅ 올바름
> private var backgroundColor: SwiftUI.Color {
>     Color.semantic(.backgroundElevatedAlternative)
> }
>
> // ❌ 빌드 실패
> private var backgroundColor: Color { Color.semantic(.backgroundElevatedAlternative) }
> ```

## Topics

### Enumerations

<details>

<summary>``enum Atomic``</summary>


디자인 시스템에서 정의된 Atomic 컬러 팔레트
#### Enumeration Cases

<details>

<summary>``case blue0``</summary>


가장 어두운 파란색 (`#000000`)
</details>
<details>

<summary>``case blue10``</summary>


매우 어두운 파란색 (`#001536`)
</details>
<details>

<summary>``case blue100``</summary>


가장 밝은 파란색 (`#FFFFFF`)
</details>
<details>

<summary>``case blue20``</summary>


거의 검은색 파란색 (`#002966`)
</details>
<details>

<summary>``case blue30``</summary>


거의 검은색에 가까운 파란색 (`#003E9C`)
</details>
<details>

<summary>``case blue40``</summary>


매우 어두운 파란색 (`#0054D1`)
</details>
<details>

<summary>``case blue45``</summary>


어두운 파란색 (`#005EEB`)
</details>
<details>

<summary>``case blue50``</summary>


중간 어두운 파란색 (`#0066FF`)
</details>
<details>

<summary>``case blue55``</summary>


어두운 파란색 (`#1A75FF`)
</details>
<details>

<summary>``case blue60``</summary>


중간 어두운 파란색 (`#3385FF`)
</details>
<details>

<summary>``case blue65``</summary>


약간 어두운 파란색 (`#4F95FF`)
</details>
<details>

<summary>``case blue70``</summary>


중간 파란색 (`#69A5FF`)
</details>
<details>

<summary>``case blue80``</summary>


중간 밝기의 파란색 (`#9EC5FF`)
</details>
<details>

<summary>``case blue90``</summary>


약간 밝은 파란색 (`#C9DEFE`)
</details>
<details>

<summary>``case blue95``</summary>


밝은 파란색 (`#EAF2FE`)
</details>
<details>

<summary>``case blue99``</summary>


매우 밝은 파란색 (`#F7FBFF`)
</details>
<details>

<summary>``case common0``</summary>


검은색 계열의 기본 색상 (`#000000`)
</details>
<details>

<summary>``case common100``</summary>


흰색 계열의 기본 색상 (`#FFFFFF`)
</details>
<details>

<summary>``case coolNeutral0``</summary>


가장 어두운 차가운 중립 색상 (`#000000`)
</details>
<details>

<summary>``case coolNeutral10``</summary>


매우 어두운 차가운 중립 색상 (`#171719`)
</details>
<details>

<summary>``case coolNeutral100``</summary>


가장 밝은 차가운 중립 색상 (`#FFFFFF`)
</details>
<details>

<summary>``case coolNeutral15``</summary>


거의 검은색 차가운 중립 색상 (`#1B1C1E`)
</details>
<details>

<summary>``case coolNeutral17``</summary>


거의 검은색에 가까운 차가운 중립 색상 (`#212225`)
</details>
<details>

<summary>``case coolNeutral20``</summary>


매우 어두운 차가운 중립 색상 (`#292A2D`)
</details>
<details>

<summary>``case coolNeutral22``</summary>


어두운 차가운 중립 색상 (`#2E2F33`)
</details>
<details>

<summary>``case coolNeutral23``</summary>


매우 어두운 차가운 중립 색상 (`#333438`)
</details>
<details>

<summary>``case coolNeutral25``</summary>


특별한 어두운 차가운 중립 색상 (`#37383C`)
</details>
<details>

<summary>``case coolNeutral30``</summary>


매우 어두운 차가운 중립 색상 (`#46474C`)
</details>
<details>

<summary>``case coolNeutral40``</summary>


어두운 차가운 중립 색상 (`#5A5C63`)
</details>
<details>

<summary>``case coolNeutral5``</summary>


매우 어두운 차가운 중립 색상 (`#0F0F10`)
</details>
<details>

<summary>``case coolNeutral50``</summary>


중간 어두운 차가운 중립 색상 (`#70737C`)
</details>
<details>

<summary>``case coolNeutral60``</summary>


약간 어두운 차가운 중립 색상 (`#878A93`)
</details>
<details>

<summary>``case coolNeutral7``</summary>


거의 검은색에 가까운 차가운 중립 색상 (`#141415`)
</details>
<details>

<summary>``case coolNeutral70``</summary>


중간 차가운 중립 색상 (`#989BA2`)
</details>
<details>

<summary>``case coolNeutral80``</summary>


중간 밝기의 차가운 중립 색상 (`#AEB0B6`)
</details>
<details>

<summary>``case coolNeutral90``</summary>


약간 밝은 차가운 중립 색상 (`#C2C4C8`)
</details>
<details>

<summary>``case coolNeutral95``</summary>


밝은 차가운 중립 색상 (`#DBDCDF`)
</details>
<details>

<summary>``case coolNeutral96``</summary>


중간 밝기의 차가운 중립 색상 (`#E1E2E4`)
</details>
<details>

<summary>``case coolNeutral97``</summary>


약간 밝은 차가운 중립 색상 (`#EAEBEC`)
</details>
<details>

<summary>``case coolNeutral98``</summary>


밝은 차가운 중립 색상 (`#F4F4F5`)
</details>
<details>

<summary>``case coolNeutral99``</summary>


매우 밝은 차가운 중립 색상 (`#F7F7F8`)
</details>
<details>

<summary>``case cyan0``</summary>


가장 어두운 시안색 (`#000000`)
</details>
<details>

<summary>``case cyan10``</summary>


거의 검은색 시안색 (`#00252B`)
</details>
<details>

<summary>``case cyan100``</summary>


가장 밝은 시안색 (`#FFFFFF`)
</details>
<details>

<summary>``case cyan20``</summary>


거의 검은색에 가까운 시안색 (`#004854`)
</details>
<details>

<summary>``case cyan30``</summary>


매우 어두운 시안색 (`#006F82`)
</details>
<details>

<summary>``case cyan40``</summary>


어두운 시안색 (`#0098B2`)
</details>
<details>

<summary>``case cyan50``</summary>


중간 어두운 시안색 (`#00BDDE`)
</details>
<details>

<summary>``case cyan60``</summary>


약간 어두운 시안색 (`#28D0ED`)
</details>
<details>

<summary>``case cyan70``</summary>


중간 시안색 (`#57DFF7`)
</details>
<details>

<summary>``case cyan80``</summary>


중간 밝기의 시안색 (`#8AEDFF`)
</details>
<details>

<summary>``case cyan90``</summary>


약간 밝은 시안색 (`#B5F4FF`)
</details>
<details>

<summary>``case cyan95``</summary>


밝은 시안색 (`#DEFAFF`)
</details>
<details>

<summary>``case cyan99``</summary>


매우 밝은 시안색 (`#F7FEFF`)
</details>
<details>

<summary>``case green0``</summary>


가장 어두운 초록색 (`#000000`)
</details>
<details>

<summary>``case green10``</summary>


거의 검은색 초록색 (`#00240C`)
</details>
<details>

<summary>``case green100``</summary>


가장 밝은 초록색 (`#FFFFFF`)
</details>
<details>

<summary>``case green20``</summary>


거의 검은색에 가까운 초록색 (`#004517`)
</details>
<details>

<summary>``case green30``</summary>


매우 어두운 초록색 (`#006E25`)
</details>
<details>

<summary>``case green40``</summary>


어두운 초록색 (`#009632`)
</details>
<details>

<summary>``case green50``</summary>


중간 어두운 초록색 (`#00BF40`)
</details>
<details>

<summary>``case green60``</summary>


약간 어두운 초록색 (`#1ED45A`)
</details>
<details>

<summary>``case green70``</summary>


중간 초록색 (`#49E57D`)
</details>
<details>

<summary>``case green80``</summary>


중간 밝기의 초록색 (`#7DF5A5`)
</details>
<details>

<summary>``case green90``</summary>


약간 밝은 초록색 (`#ACFCC7`)
</details>
<details>

<summary>``case green95``</summary>


밝은 초록색 (`#D9FFE6`)
</details>
<details>

<summary>``case green99``</summary>


매우 밝은 초록색 (`#F2FFF6`)
</details>
<details>

<summary>``case lightBlue0``</summary>


가장 어두운 하늘색 (`#000000`)
</details>
<details>

<summary>``case lightBlue10``</summary>


거의 검은색 하늘색 (`#002130`)
</details>
<details>

<summary>``case lightBlue100``</summary>


가장 밝은 하늘색 (`#FFFFFF`)
</details>
<details>

<summary>``case lightBlue20``</summary>


거의 검은색에 가까운 하늘색 (`#004261`)
</details>
<details>

<summary>``case lightBlue30``</summary>


매우 어두운 하늘색 (`#006796`)
</details>
<details>

<summary>``case lightBlue40``</summary>


어두운 하늘색 (`#008DCF`)
</details>
<details>

<summary>``case lightBlue50``</summary>


중간 어두운 하늘색 (`#00AEFF`)
</details>
<details>

<summary>``case lightBlue60``</summary>


약간 어두운 하늘색 (`#3DC2FF`)
</details>
<details>

<summary>``case lightBlue70``</summary>


중간 하늘색 (`#70D2FF`)
</details>
<details>

<summary>``case lightBlue80``</summary>


중간 밝기의 하늘색 (`#A1E1FF`)
</details>
<details>

<summary>``case lightBlue90``</summary>


약간 밝은 하늘색 (`#C4ECFE`)
</details>
<details>

<summary>``case lightBlue95``</summary>


밝은 하늘색 (`#E5F6FE`)
</details>
<details>

<summary>``case lightBlue99``</summary>


매우 밝은 하늘색 (`#F7FDFF`)
</details>
<details>

<summary>``case lime0``</summary>


가장 어두운 라임색 (`#000000`)
</details>
<details>

<summary>``case lime10``</summary>


거의 검은색 라임색 (`#112900`)
</details>
<details>

<summary>``case lime100``</summary>


가장 밝은 라임색 (`#FFFFFF`)
</details>
<details>

<summary>``case lime20``</summary>


거의 검은색에 가까운 라임색 (`#225200`)
</details>
<details>

<summary>``case lime30``</summary>


매우 어두운 라임색 (`#347D00`)
</details>
<details>

<summary>``case lime37``</summary>


특별한 어두운 라임색 (`#429E00`)
</details>
<details>

<summary>``case lime40``</summary>


어두운 라임색 (`#48AD00`)
</details>
<details>

<summary>``case lime50``</summary>


중간 어두운 라임색 (`#58CF04`)
</details>
<details>

<summary>``case lime60``</summary>


약간 어두운 라임색 (`#6BE016`)
</details>
<details>

<summary>``case lime70``</summary>


중간 라임색 (`#88F03E`)
</details>
<details>

<summary>``case lime80``</summary>


중간 밝기의 라임색 (`#AEF779`)
</details>
<details>

<summary>``case lime90``</summary>


약간 밝은 라임색 (`#CCFCA9`)
</details>
<details>

<summary>``case lime95``</summary>


밝은 라임색 (`#E6FFD4`)
</details>
<details>

<summary>``case lime99``</summary>


매우 밝은 라임색 (`#F8FFF2`)
</details>
<details>

<summary>``case neutral0``</summary>


가장 어두운 중립 색상 (`#000000`)
</details>
<details>

<summary>``case neutral10``</summary>


거의 검은색 중립 색상 (`#171717`)
</details>
<details>

<summary>``case neutral100``</summary>


가장 밝은 중립 색상 (`#FFFFFF`)
</details>
<details>

<summary>``case neutral15``</summary>


거의 검은색에 가까운 중립 색상 (`#1C1C1C`)
</details>
<details>

<summary>``case neutral20``</summary>


매우 어두운 중립 색상 (`#2A2A2A`)
</details>
<details>

<summary>``case neutral22``</summary>


특별한 어두운 중립 색상 (`#303030`)
</details>
<details>

<summary>``case neutral30``</summary>


매우 어두운 중립 색상 (`#474747`)
</details>
<details>

<summary>``case neutral40``</summary>


어두운 중립 색상 (`#5C5C5C`)
</details>
<details>

<summary>``case neutral5``</summary>


매우 어두운 중립 색상 (`#0F0F0F`)
</details>
<details>

<summary>``case neutral50``</summary>


중간 어두운 중립 색상 (`#737373`)
</details>
<details>

<summary>``case neutral60``</summary>


약간 어두운 중립 색상 (`#8A8A8A`)
</details>
<details>

<summary>``case neutral70``</summary>


중간 중립 색상 (`#9B9B9B`)
</details>
<details>

<summary>``case neutral80``</summary>


중간 밝기의 중립 색상 (`#B0B0B0`)
</details>
<details>

<summary>``case neutral90``</summary>


약간 밝은 중립 색상 (`#C4C4C4`)
</details>
<details>

<summary>``case neutral95``</summary>


밝은 중립 색상 (`#DCDCDC`)
</details>
<details>

<summary>``case neutral99``</summary>


매우 밝은 중립 색상 (`#F7F7F7`)
</details>
<details>

<summary>``case orange0``</summary>


가장 어두운 주황색 (`#000000`)
</details>
<details>

<summary>``case orange10``</summary>


거의 검은색 주황색 (`#361E00`)
</details>
<details>

<summary>``case orange100``</summary>


가장 밝은 주황색 (`#FFFFFF`)
</details>
<details>

<summary>``case orange20``</summary>


거의 검은색에 가까운 주황색 (`#663A00`)
</details>
<details>

<summary>``case orange30``</summary>


매우 어두운 주황색 (`#9C5800`)
</details>
<details>

<summary>``case orange39``</summary>


특별한 어두운 주황색 (`#D17600`)
</details>
<details>

<summary>``case orange40``</summary>


어두운 주황색 (`#D47800`)
</details>
<details>

<summary>``case orange50``</summary>


중간 어두운 주황색 (`#FF9200`)
</details>
<details>

<summary>``case orange60``</summary>


약간 어두운 주황색 (`#FFA938`)
</details>
<details>

<summary>``case orange70``</summary>


중간 주황색 (`#FFC06E`)
</details>
<details>

<summary>``case orange80``</summary>


중간 밝기의 주황색 (`#FFD49C`)
</details>
<details>

<summary>``case orange90``</summary>


약간 밝은 주황색 (`#FEE6C6`)
</details>
<details>

<summary>``case orange95``</summary>


밝은 주황색 (`#FEF4E6`)
</details>
<details>

<summary>``case orange99``</summary>


매우 밝은 주황색 (`#FFFCF7`)
</details>
<details>

<summary>``case pink0``</summary>


가장 어두운 분홍색 (`#000000`)
</details>
<details>

<summary>``case pink10``</summary>


거의 검은색 분홍색 (`#3D0133`)
</details>
<details>

<summary>``case pink100``</summary>


가장 밝은 분홍색 (`#FFFFFF`)
</details>
<details>

<summary>``case pink20``</summary>


거의 검은색에 가까운 분홍색 (`#730560`)
</details>
<details>

<summary>``case pink30``</summary>


매우 어두운 분홍색 (`#A81690`)
</details>
<details>

<summary>``case pink40``</summary>


어두운 분홍색 (`#D331B8`)
</details>
<details>

<summary>``case pink46``</summary>


특별한 어두운 분홍색 (`#E846CD`)
</details>
<details>

<summary>``case pink50``</summary>


중간 어두운 분홍색 (`#F553DA`)
</details>
<details>

<summary>``case pink60``</summary>


약간 어두운 분홍색 (`#FA73E3`)
</details>
<details>

<summary>``case pink70``</summary>


중간 분홍색 (`#FF94ED`)
</details>
<details>

<summary>``case pink80``</summary>


중간 밝기의 분홍색 (`#FFB8F3`)
</details>
<details>

<summary>``case pink90``</summary>


약간 밝은 분홍색 (`#FED3F7`)
</details>
<details>

<summary>``case pink95``</summary>


밝은 분홍색 (`#FEECFB`)
</details>
<details>

<summary>``case pink99``</summary>


매우 밝은 분홍색 (`#FFFAFE`)
</details>
<details>

<summary>``case purple0``</summary>


가장 어두운 자주색 (`#000000`)
</details>
<details>

<summary>``case purple10``</summary>


거의 검은색 자주색 (`#290247`)
</details>
<details>

<summary>``case purple100``</summary>


가장 밝은 자주색 (`#FEFFFF`)
</details>
<details>

<summary>``case purple20``</summary>


거의 검은색에 가까운 자주색 (`#580A7D`)
</details>
<details>

<summary>``case purple30``</summary>


매우 어두운 자주색 (`#861CB8`)
</details>
<details>

<summary>``case purple40``</summary>


어두운 자주색 (`#AD36E3`)
</details>
<details>

<summary>``case purple50``</summary>


중간 어두운 자주색 (`#CB59FF`)
</details>
<details>

<summary>``case purple60``</summary>


약간 어두운 자주색 (`#D478FF`)
</details>
<details>

<summary>``case purple70``</summary>


중간 자주색 (`#DE96FF`)
</details>
<details>

<summary>``case purple80``</summary>


중간 밝기의 자주색 (`#E9BAFF`)
</details>
<details>

<summary>``case purple90``</summary>


약간 밝은 자주색 (`#F2D6FF`)
</details>
<details>

<summary>``case purple95``</summary>


밝은 자주색 (`#F9EDFF`)
</details>
<details>

<summary>``case purple99``</summary>


매우 밝은 자주색 (`#FEFBFF`)
</details>
<details>

<summary>``case red0``</summary>


가장 어두운 빨간색 (`#000000`)
</details>
<details>

<summary>``case red10``</summary>


거의 검은색 빨간색 (`#3B0101`)
</details>
<details>

<summary>``case red100``</summary>


가장 밝은 빨간색 (`#FFFFFF`)
</details>
<details>

<summary>``case red20``</summary>


거의 검은색에 가까운 빨간색 (`#730303`)
</details>
<details>

<summary>``case red30``</summary>


매우 어두운 빨간색 (`#B00C0C`)
</details>
<details>

<summary>``case red40``</summary>


어두운 빨간색 (`#E52222`)
</details>
<details>

<summary>``case red50``</summary>


중간 어두운 빨간색 (`#FF4242`)
</details>
<details>

<summary>``case red60``</summary>


약간 어두운 빨간색 (`#FF6363`)
</details>
<details>

<summary>``case red70``</summary>


중간 빨간색 (`#FF8C8C`)
</details>
<details>

<summary>``case red80``</summary>


중간 밝기의 빨간색 (`#FFB5B5`)
</details>
<details>

<summary>``case red90``</summary>


약간 밝은 빨간색 (`#FED5D5`)
</details>
<details>

<summary>``case red95``</summary>


밝은 빨간색 (`#FEECEC`)
</details>
<details>

<summary>``case red99``</summary>


매우 밝은 빨간색 (`#FFFAFA`)
</details>
<details>

<summary>``case redOrange0``</summary>


가장 어두운 붉은 주황색 (`#000000`)
</details>
<details>

<summary>``case redOrange10``</summary>


거의 검은색 붉은 주황색 (`#290F00`)
</details>
<details>

<summary>``case redOrange100``</summary>


가장 밝은 붉은 주황색 (`#FFFFFF`)
</details>
<details>

<summary>``case redOrange20``</summary>


거의 검은색에 가까운 붉은 주황색 (`#592100`)
</details>
<details>

<summary>``case redOrange30``</summary>


매우 어두운 붉은 주황색 (`#913500`)
</details>
<details>

<summary>``case redOrange40``</summary>


어두운 붉은 주황색 (`#C94A00`)
</details>
<details>

<summary>``case redOrange48``</summary>


특별한 어두운 붉은 주황색 (`#F55A00`)
</details>
<details>

<summary>``case redOrange50``</summary>


중간 어두운 붉은 주황색 (`#FF5E00`)
</details>
<details>

<summary>``case redOrange60``</summary>


약간 어두운 붉은 주황색 (`#FF7B2E`)
</details>
<details>

<summary>``case redOrange70``</summary>


중간 붉은 주황색 (`#FF9B61`)
</details>
<details>

<summary>``case redOrange80``</summary>


중간 밝기의 붉은 주황색 (`#FFBD96`)
</details>
<details>

<summary>``case redOrange90``</summary>


약간 밝은 붉은 주황색 (`#FED9C4`)
</details>
<details>

<summary>``case redOrange95``</summary>


밝은 붉은 주황색 (`#FEEEE5`)
</details>
<details>

<summary>``case redOrange99``</summary>


매우 밝은 붉은 주황색 (`#FFFAF7`)
</details>
<details>

<summary>``case violet0``</summary>


가장 어두운 보라색 (`#000000`)
</details>
<details>

<summary>``case violet10``</summary>


거의 검은색 보라색 (`#11024D`)
</details>
<details>

<summary>``case violet100``</summary>


가장 밝은 보라색 (`#FFFFFF`)
</details>
<details>

<summary>``case violet20``</summary>


거의 검은색에 가까운 보라색 (`#23098F`)
</details>
<details>

<summary>``case violet30``</summary>


매우 어두운 보라색 (`#3A16C9`)
</details>
<details>

<summary>``case violet40``</summary>


어두운 보라색 (`#4F29E5`)
</details>
<details>

<summary>``case violet45``</summary>


특별한 어두운 보라색 (`#5B37ED`)
</details>
<details>

<summary>``case violet50``</summary>


중간 어두운 보라색 (`#6541F2`)
</details>
<details>

<summary>``case violet60``</summary>


약간 어두운 보라색 (`#7D5EF7`)
</details>
<details>

<summary>``case violet70``</summary>


중간 보라색 (`#9E86FC`)
</details>
<details>

<summary>``case violet80``</summary>


중간 밝기의 보라색 (`#C0B0FF`)
</details>
<details>

<summary>``case violet90``</summary>


약간 밝은 보라색 (`#DBD3FE`)
</details>
<details>

<summary>``case violet95``</summary>


밝은 보라색 (`#F0ECFE`)
</details>
<details>

<summary>``case violet99``</summary>


매우 밝은 보라색 (`#FBFAFF`)
</details>

#### Initializers

<details>

<summary>``init?(rawValue: String)``</summary>

</details>

#### Instance Methods

<details>

<summary>``func resolve(UITraitCollection) -> UIColor``</summary>


주어진 UITraitCollection에 따라 UIColor를 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `traitCollection` | 색상을 해석할 UITraitCollection |
- **Return Value**

  해석된 UIColor 인스턴스
</details>

</details>
<details>

<summary>``enum Semantic``</summary>


디자인 시스템에서 정의된 Semantic 컬러 값
#### Enumeration Cases

<details>

<summary>``case accentBackgroundCyan``</summary>


시안색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundLightBlue``</summary>


하늘색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundLime``</summary>


라임색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundPink``</summary>


분홍색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundPurple``</summary>


자주색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundRedOrange``</summary>


붉은 주황색 강조 배경 색상
</details>
<details>

<summary>``case accentBackgroundViolet``</summary>


보라색 강조 배경 색상
</details>
<details>

<summary>``case accentForegroundBlue``</summary>


파란색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundCyan``</summary>


시안색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundGreen``</summary>


초록색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundLightBlue``</summary>


하늘색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundLime``</summary>


라임색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundOrange``</summary>


주황색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundPink``</summary>


분홍색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundPurple``</summary>


자주색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundRed``</summary>


빨간색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundRedOrange``</summary>


붉은 주황색 강조 전경 색상
</details>
<details>

<summary>``case accentForegroundViolet``</summary>


보라색 강조 전경 색상
</details>
<details>

<summary>``case backgroundElevated``</summary>


상승된 배경 색상
</details>
<details>

<summary>``case backgroundElevatedAlternative``</summary>


상승된 대체 배경 색상
</details>
<details>

<summary>``case backgroundNormal``</summary>


기본 배경 색상
</details>
<details>

<summary>``case backgroundNormalAlternative``</summary>


대체 배경 색상
</details>
<details>

<summary>``case backgroundTransparent``</summary>


투명 배경 색상
</details>
<details>

<summary>``case backgroundTransparentAlternative``</summary>


투명 대체 배경 색상
</details>
<details>

<summary>``case fillAlternative``</summary>


대체 채우기 색상
</details>
<details>

<summary>``case fillNegative``</summary>


negative 요소 내부 색상 (e.g. Button negative)
</details>
<details>

<summary>``case fillNormal``</summary>


기본 채우기 색상
</details>
<details>

<summary>``case fillPrimary``</summary>


primary 요소 내부 색상 (e.g. Chip)
</details>
<details>

<summary>``case fillStrong``</summary>


강조된 채우기 색상
</details>
<details>

<summary>``case interactionDisable``</summary>


비활성화된 상호작용 색상
</details>
<details>

<summary>``case interactionFocus``</summary>


포커스 상태에서 그림자를 표현하는 상호작용 색상 (e.g. TextField focused)
</details>
<details>

<summary>``case interactionInactive``</summary>


비활성화된 상호작용 색상
</details>
<details>

<summary>``case interactionNegative``</summary>


negative 상태에서 포커스되었을 때 그림자를 표현하는 상호작용 색상 (e.g. TextField negative focused)
</details>
<details>

<summary>``case inverseBackground``</summary>


역전된 배경 색상
</details>
<details>

<summary>``case inverseLabel``</summary>


역전된 라벨 색상
</details>
<details>

<summary>``case inversePrimary``</summary>


역전된 주요 색상
</details>
<details>

<summary>``case labelAlternative``</summary>


대체 라벨 색상
</details>
<details>

<summary>``case labelAssistive``</summary>


보조 라벨 색상
</details>
<details>

<summary>``case labelDisable``</summary>


비활성화된 라벨 색상
</details>
<details>

<summary>``case labelNeutral``</summary>


중립적인 라벨 색상
</details>
<details>

<summary>``case labelNormal``</summary>


기본 라벨 색상
</details>
<details>

<summary>``case labelStrong``</summary>


강조된 라벨 색상
</details>
<details>

<summary>``case lineAlternative``</summary>


대체 선 색상
</details>
<details>

<summary>``case lineNegativeNormal``</summary>


negative 상태의 기본 보더 색상 (e.g. TextField negative)
</details>
<details>

<summary>``case lineNegativeStrong``</summary>


negative 상태에서 포커스 등 강조가 필요할 때의 보더 색상 (e.g. TextField negative focused)
</details>
<details>

<summary>``case lineNeutral``</summary>


중립적인 선 색상
</details>
<details>

<summary>``case lineNormal``</summary>


기본 선 색상
</details>
<details>

<summary>``case linePrimaryNormal``</summary>


primary 상태의 기본 보더 색상 (e.g. chip)
</details>
<details>

<summary>``case linePrimaryStrong``</summary>


primary 상태에서 포커스 등 강조가 필요할 때의 보더 색상 (e.g. TextField focused)
</details>
<details>

<summary>``case lineSolidAlternative``</summary>


대체 실선 색상
</details>
<details>

<summary>``case lineSolidNeutral``</summary>


중립적인 실선 색상
</details>
<details>

<summary>``case lineSolidNormal``</summary>


기본 실선 색상
</details>
<details>

<summary>``case materialDimmer``</summary>


어두운 재질 색상
</details>
<details>

<summary>``case primaryHeavy``</summary>


매우 강조된 주요 색상
</details>
<details>

<summary>``case primaryNormal``</summary>


기본 주요 색상
</details>
<details>

<summary>``case primaryStrong``</summary>


강조된 주요 색상
</details>
<details>

<summary>``case staticBlack``</summary>


정적 검은색 색상
</details>
<details>

<summary>``case staticWhite``</summary>


정적 흰색 색상
</details>
<details>

<summary>``case statusCautionary``</summary>


주의 상태 색상
</details>
<details>

<summary>``case statusNegative``</summary>


부정적인 상태 색상
</details>
<details>

<summary>``case statusPositive``</summary>


긍정적인 상태 색상
</details>

#### Initializers

<details>

<summary>``init?(rawValue: String)``</summary>

</details>

#### Instance Methods

<details>

<summary>``func resolve(UITraitCollection) -> UIColor``</summary>


주어진 UITraitCollection에 따라 UIColor를 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `traitCollection` | 색상을 해석할 UITraitCollection |
- **Return Value**

  해석된 UIColor 인스턴스
</details>

</details>

### Associated Extensions

<details>

<summary>``extension UIColor``</summary>

<details>

<summary>``static func atomic(Color.Atomic) -> UIColor``</summary>


Atomic 색상 타입에 해당하는 UIColor를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Atomic 색상 타입 |
- **Return Value**

  동적으로 생성된 UIColor 인스턴스
</details>

<details>

<summary>``static func semantic(Color.Semantic) -> UIColor``</summary>


Semantic 색상 타입에 해당하는 UIColor를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Semantic 색상 타입 |
- **Return Value**

  동적으로 생성된 UIColor 인스턴스
</details>


</details>


<details>

<summary>``extension Color``</summary>

<details>

<summary>``static func atomic(Color.Atomic) -> SwiftUI.Color``</summary>


Atomic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Atomic 색상 타입 |
- **Return Value**

  동적으로 생성된 SwiftUI.Color 인스턴스
</details>

<details>

<summary>``static func semantic(Color.Semantic) -> SwiftUI.Color``</summary>


Semantic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Semantic 색상 타입 |
- **Return Value**

  동적으로 생성된 SwiftUI.Color 인스턴스
</details>

<details>

<summary>``var uiColor: UIColor``</summary>


SwiftUI.Color를 UIColor로 변환합니다.
- **Return Value**

  변환된 UIColor 인스턴스
</details>


</details>

