---
title: Color.Atomic
description: 디자인 시스템에서 정의된 Atomic 컬러 팔레트
---

```swift
enum Atomic
```

## Overview

Atomic 색상은 디자인 시스템의 기본 색상 값을 정의합니다. 이 색상들은 직접 사용하기보다는 Semantic 색상의 기반이 되는 기본 색상 팔레트로 활용됩니다.

전체 팔레트 색상을 한번에 보려면 Figma의 [Color - Atomic)](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-52196.md) 를 참고하세요.

```swift
// UIKit에서 사용
view.backgroundColor = UIColor.atomic(.blue50)

// SwiftUI에서 사용
Text("텍스트")
    .foregroundColor(.atomic(.red60))
```

>  Note
>
> 숫자가 높을수록 밝은 색상을 나타내며, 100에 가까울수록 흰색에 가깝고 0에 가까울수록 검은색에 가깝습니다.

## Topics

### Enumeration Cases


``case blue0``

가장 어두운 파란색

``case blue10``

매우 어두운 파란색

``case blue100``

가장 밝은 파란색

``case blue20``

거의 검은색 파란색

``case blue30``

거의 검은색에 가까운 파란색

``case blue40``

매우 어두운 파란색

``case blue45``

어두운 파란색

``case blue50``

중간 어두운 파란색

``case blue55``

어두운 파란색

``case blue60``

중간 어두운 파란색

``case blue65``

약간 어두운 파란색

``case blue70``

중간 파란색

``case blue80``

중간 밝기의 파란색

``case blue90``

약간 밝은 파란색

``case blue95``

밝은 파란색

``case blue99``

매우 밝은 파란색

``case common0``

검은색 계열의 기본 색상

``case common100``

흰색 계열의 기본 색상

``case coolNeutral0``

가장 어두운 차가운 중립 색상

``case coolNeutral10``

매우 어두운 차가운 중립 색상

``case coolNeutral100``

가장 밝은 차가운 중립 색상

``case coolNeutral15``

거의 검은색 차가운 중립 색상

``case coolNeutral17``

거의 검은색에 가까운 차가운 중립 색상

``case coolNeutral20``

매우 어두운 차가운 중립 색상

``case coolNeutral22``

어두운 차가운 중립 색상

``case coolNeutral23``

매우 어두운 차가운 중립 색상

``case coolNeutral25``

특별한 어두운 차가운 중립 색상

``case coolNeutral30``

매우 어두운 차가운 중립 색상

``case coolNeutral40``

어두운 차가운 중립 색상

``case coolNeutral5``

매우 어두운 차가운 중립 색상

``case coolNeutral50``

중간 어두운 차가운 중립 색상

``case coolNeutral60``

약간 어두운 차가운 중립 색상

``case coolNeutral7``

거의 검은색에 가까운 차가운 중립 색상

``case coolNeutral70``

중간 차가운 중립 색상

``case coolNeutral80``

중간 밝기의 차가운 중립 색상

``case coolNeutral90``

약간 밝은 차가운 중립 색상

``case coolNeutral95``

밝은 차가운 중립 색상

``case coolNeutral96``

중간 밝기의 차가운 중립 색상

``case coolNeutral97``

약간 밝은 차가운 중립 색상

``case coolNeutral98``

밝은 차가운 중립 색상

``case coolNeutral99``

매우 밝은 차가운 중립 색상

``case cyan0``

가장 어두운 시안색

``case cyan10``

거의 검은색 시안색

``case cyan100``

가장 밝은 시안색

``case cyan20``

거의 검은색에 가까운 시안색

``case cyan30``

매우 어두운 시안색

``case cyan40``

어두운 시안색

``case cyan50``

중간 어두운 시안색

``case cyan60``

약간 어두운 시안색

``case cyan70``

중간 시안색

``case cyan80``

중간 밝기의 시안색

``case cyan90``

약간 밝은 시안색

``case cyan95``

밝은 시안색

``case cyan99``

매우 밝은 시안색

``case green0``

가장 어두운 초록색

``case green10``

거의 검은색 초록색

``case green100``

가장 밝은 초록색

``case green20``

거의 검은색에 가까운 초록색

``case green30``

매우 어두운 초록색

``case green40``

어두운 초록색

``case green50``

중간 어두운 초록색

``case green60``

약간 어두운 초록색

``case green70``

중간 초록색

``case green80``

중간 밝기의 초록색

``case green90``

약간 밝은 초록색

``case green95``

밝은 초록색

``case green99``

매우 밝은 초록색

``case lightBlue0``

가장 어두운 하늘색

``case lightBlue10``

거의 검은색 하늘색

``case lightBlue100``

가장 밝은 하늘색

``case lightBlue20``

거의 검은색에 가까운 하늘색

``case lightBlue30``

매우 어두운 하늘색

``case lightBlue40``

어두운 하늘색

``case lightBlue50``

중간 어두운 하늘색

``case lightBlue60``

약간 어두운 하늘색

``case lightBlue70``

중간 하늘색

``case lightBlue80``

중간 밝기의 하늘색

``case lightBlue90``

약간 밝은 하늘색

``case lightBlue95``

밝은 하늘색

``case lightBlue99``

매우 밝은 하늘색

``case lime0``

가장 어두운 라임색

``case lime10``

거의 검은색 라임색

``case lime100``

가장 밝은 라임색

``case lime20``

거의 검은색에 가까운 라임색

``case lime30``

매우 어두운 라임색

``case lime37``

특별한 어두운 라임색

``case lime40``

어두운 라임색

``case lime50``

중간 어두운 라임색

``case lime60``

약간 어두운 라임색

``case lime70``

중간 라임색

``case lime80``

중간 밝기의 라임색

``case lime90``

약간 밝은 라임색

``case lime95``

밝은 라임색

``case lime99``

매우 밝은 라임색

``case neutral0``

가장 어두운 중립 색상

``case neutral10``

거의 검은색 중립 색상

``case neutral100``

가장 밝은 중립 색상

``case neutral15``

거의 검은색에 가까운 중립 색상

``case neutral20``

매우 어두운 중립 색상

``case neutral22``

특별한 어두운 중립 색상

``case neutral30``

매우 어두운 중립 색상

``case neutral40``

어두운 중립 색상

``case neutral5``

매우 어두운 중립 색상

``case neutral50``

중간 어두운 중립 색상

``case neutral60``

약간 어두운 중립 색상

``case neutral70``

중간 중립 색상

``case neutral80``

중간 밝기의 중립 색상

``case neutral90``

약간 밝은 중립 색상

``case neutral95``

밝은 중립 색상

``case neutral99``

매우 밝은 중립 색상

``case orange0``

가장 어두운 주황색

``case orange10``

거의 검은색 주황색

``case orange100``

가장 밝은 주황색

``case orange20``

거의 검은색에 가까운 주황색

``case orange30``

매우 어두운 주황색

``case orange39``

특별한 어두운 주황색

``case orange40``

어두운 주황색

``case orange50``

중간 어두운 주황색

``case orange60``

약간 어두운 주황색

``case orange70``

중간 주황색

``case orange80``

중간 밝기의 주황색

``case orange90``

약간 밝은 주황색

``case orange95``

밝은 주황색

``case orange99``

매우 밝은 주황색

``case pink0``

가장 어두운 분홍색

``case pink10``

거의 검은색 분홍색

``case pink100``

가장 밝은 분홍색

``case pink20``

거의 검은색에 가까운 분홍색

``case pink30``

매우 어두운 분홍색

``case pink40``

어두운 분홍색

``case pink46``

특별한 어두운 분홍색

``case pink50``

중간 어두운 분홍색

``case pink60``

약간 어두운 분홍색

``case pink70``

중간 분홍색

``case pink80``

중간 밝기의 분홍색

``case pink90``

약간 밝은 분홍색

``case pink95``

밝은 분홍색

``case pink99``

매우 밝은 분홍색

``case purple0``

가장 어두운 자주색

``case purple10``

거의 검은색 자주색

``case purple100``

가장 밝은 자주색

``case purple20``

거의 검은색에 가까운 자주색

``case purple30``

매우 어두운 자주색

``case purple40``

어두운 자주색

``case purple50``

중간 어두운 자주색

``case purple60``

약간 어두운 자주색

``case purple70``

중간 자주색

``case purple80``

중간 밝기의 자주색

``case purple90``

약간 밝은 자주색

``case purple95``

밝은 자주색

``case purple99``

매우 밝은 자주색

``case red0``

가장 어두운 빨간색

``case red10``

거의 검은색 빨간색

``case red100``

가장 밝은 빨간색

``case red20``

거의 검은색에 가까운 빨간색

``case red30``

매우 어두운 빨간색

``case red40``

어두운 빨간색

``case red50``

중간 어두운 빨간색

``case red60``

약간 어두운 빨간색

``case red70``

중간 빨간색

``case red80``

중간 밝기의 빨간색

``case red90``

약간 밝은 빨간색

``case red95``

밝은 빨간색

``case red99``

매우 밝은 빨간색

``case redOrange0``

가장 어두운 붉은 주황색

``case redOrange10``

거의 검은색 붉은 주황색

``case redOrange100``

가장 밝은 붉은 주황색

``case redOrange20``

거의 검은색에 가까운 붉은 주황색

``case redOrange30``

매우 어두운 붉은 주황색

``case redOrange40``

어두운 붉은 주황색

``case redOrange48``

특별한 어두운 붉은 주황색

``case redOrange50``

중간 어두운 붉은 주황색

``case redOrange60``

약간 어두운 붉은 주황색

``case redOrange70``

중간 붉은 주황색

``case redOrange80``

중간 밝기의 붉은 주황색

``case redOrange90``

약간 밝은 붉은 주황색

``case redOrange95``

밝은 붉은 주황색

``case redOrange99``

매우 밝은 붉은 주황색

``case violet0``

가장 어두운 보라색

``case violet10``

거의 검은색 보라색

``case violet100``

가장 밝은 보라색

``case violet20``

거의 검은색에 가까운 보라색

``case violet30``

매우 어두운 보라색

``case violet40``

어두운 보라색

``case violet45``

특별한 어두운 보라색

``case violet50``

중간 어두운 보라색

``case violet60``

약간 어두운 보라색

``case violet70``

중간 보라색

``case violet80``

중간 밝기의 보라색

``case violet90``

약간 밝은 보라색

``case violet95``

밝은 보라색

``case violet99``

매우 밝은 보라색

### Initializers


``init?(rawValue: String)``

### Instance Properties


``var name: String``

Atomic 색상의 이름을 반환합니다.
- **Return Value**

  색상의 이름 문자열

### Instance Methods


``func resolve(UITraitCollection) -> UIColor``

주어진 UITraitCollection에 따라 UIColor를 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `_` | 색상을 해석할 UITraitCollection |
- **Return Value**

  해석된 UIColor 인스턴스

### Default Implementations


[Equatable Implementations](/documentation/montage/color/atomic/equatable-implementations.md)

[RawRepresentable Implementations](/documentation/montage/color/atomic/rawrepresentable-implementations.md)

## Relationships

Conforms To

`ColorResolvable`

`Swift.CaseIterable`

`Swift.Equatable`

`Swift.Hashable`

`Swift.RawRepresentable`



