**ENUM**

# `Color.Atomic`

```swift
public enum Atomic: String, CaseIterable, ColorResolvable
```

디자인 시스템에서 정의된 Atomic 컬러 팔레트

Atomic 색상은 디자인 시스템의 기본 색상 값을 정의합니다.
이 색상들은 직접 사용하기보다는 Semantic 색상의 기반이 되는 
기본 색상 팔레트로 활용됩니다.

전체 팔레트 색상을 한번에 보려면 Figma의 [Color - Atomic)](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-52196) 를 참고하세요.

**사용 예시**:
```swift
// UIKit에서 사용
view.backgroundColor = UIColor.atomic(.blue50)

// SwiftUI에서 사용
Text("텍스트")
    .foregroundColor(.atomic(.red60))
```

- Note: 숫자가 높을수록 밝은 색상을 나타내며, 100에 가까울수록 흰색에 가깝고
  0에 가까울수록 검은색에 가깝습니다.

## Cases
### `common100`

```swift
case common100
```

### `common0`

```swift
case common0
```

### `neutral100`

```swift
case neutral100
```

### `neutral99`

```swift
case neutral99
```

### `neutral95`

```swift
case neutral95
```

### `neutral90`

```swift
case neutral90
```

### `neutral80`

```swift
case neutral80
```

### `neutral70`

```swift
case neutral70
```

### `neutral60`

```swift
case neutral60
```

### `neutral50`

```swift
case neutral50
```

### `neutral40`

```swift
case neutral40
```

### `neutral30`

```swift
case neutral30
```

### `neutral22`

```swift
case neutral22
```

### `neutral20`

```swift
case neutral20
```

### `neutral15`

```swift
case neutral15
```

### `neutral10`

```swift
case neutral10
```

### `neutral5`

```swift
case neutral5
```

### `neutral0`

```swift
case neutral0
```

### `coolNeutral100`

```swift
case coolNeutral100
```

### `coolNeutral99`

```swift
case coolNeutral99
```

### `coolNeutral98`

```swift
case coolNeutral98
```

### `coolNeutral97`

```swift
case coolNeutral97
```

### `coolNeutral96`

```swift
case coolNeutral96
```

### `coolNeutral95`

```swift
case coolNeutral95
```

### `coolNeutral90`

```swift
case coolNeutral90
```

### `coolNeutral80`

```swift
case coolNeutral80
```

### `coolNeutral70`

```swift
case coolNeutral70
```

### `coolNeutral60`

```swift
case coolNeutral60
```

### `coolNeutral50`

```swift
case coolNeutral50
```

### `coolNeutral40`

```swift
case coolNeutral40
```

### `coolNeutral30`

```swift
case coolNeutral30
```

### `coolNeutral25`

```swift
case coolNeutral25
```

### `coolNeutral23`

```swift
case coolNeutral23
```

### `coolNeutral22`

```swift
case coolNeutral22
```

### `coolNeutral20`

```swift
case coolNeutral20
```

### `coolNeutral17`

```swift
case coolNeutral17
```

### `coolNeutral15`

```swift
case coolNeutral15
```

### `coolNeutral10`

```swift
case coolNeutral10
```

### `coolNeutral7`

```swift
case coolNeutral7
```

### `coolNeutral5`

```swift
case coolNeutral5
```

### `coolNeutral0`

```swift
case coolNeutral0
```

### `blue100`

```swift
case blue100
```

### `blue99`

```swift
case blue99
```

### `blue95`

```swift
case blue95
```

### `blue90`

```swift
case blue90
```

### `blue80`

```swift
case blue80
```

### `blue70`

```swift
case blue70
```

### `blue65`

```swift
case blue65
```

### `blue60`

```swift
case blue60
```

### `blue55`

```swift
case blue55
```

### `blue50`

```swift
case blue50
```

### `blue45`

```swift
case blue45
```

### `blue40`

```swift
case blue40
```

### `blue30`

```swift
case blue30
```

### `blue20`

```swift
case blue20
```

### `blue10`

```swift
case blue10
```

### `blue0`

```swift
case blue0
```

### `red100`

```swift
case red100
```

### `red99`

```swift
case red99
```

### `red95`

```swift
case red95
```

### `red90`

```swift
case red90
```

### `red80`

```swift
case red80
```

### `red70`

```swift
case red70
```

### `red60`

```swift
case red60
```

### `red50`

```swift
case red50
```

### `red40`

```swift
case red40
```

### `red30`

```swift
case red30
```

### `red20`

```swift
case red20
```

### `red10`

```swift
case red10
```

### `red0`

```swift
case red0
```

### `green100`

```swift
case green100
```

### `green99`

```swift
case green99
```

### `green95`

```swift
case green95
```

### `green90`

```swift
case green90
```

### `green80`

```swift
case green80
```

### `green70`

```swift
case green70
```

### `green60`

```swift
case green60
```

### `green50`

```swift
case green50
```

### `green40`

```swift
case green40
```

### `green30`

```swift
case green30
```

### `green20`

```swift
case green20
```

### `green10`

```swift
case green10
```

### `green0`

```swift
case green0
```

### `orange100`

```swift
case orange100
```

### `orange99`

```swift
case orange99
```

### `orange95`

```swift
case orange95
```

### `orange90`

```swift
case orange90
```

### `orange80`

```swift
case orange80
```

### `orange70`

```swift
case orange70
```

### `orange60`

```swift
case orange60
```

### `orange50`

```swift
case orange50
```

### `orange40`

```swift
case orange40
```

### `orange39`

```swift
case orange39
```

### `orange30`

```swift
case orange30
```

### `orange20`

```swift
case orange20
```

### `orange10`

```swift
case orange10
```

### `orange0`

```swift
case orange0
```

### `lime100`

```swift
case lime100
```

### `lime99`

```swift
case lime99
```

### `lime95`

```swift
case lime95
```

### `lime90`

```swift
case lime90
```

### `lime80`

```swift
case lime80
```

### `lime70`

```swift
case lime70
```

### `lime60`

```swift
case lime60
```

### `lime50`

```swift
case lime50
```

### `lime40`

```swift
case lime40
```

### `lime37`

```swift
case lime37
```

### `lime30`

```swift
case lime30
```

### `lime20`

```swift
case lime20
```

### `lime10`

```swift
case lime10
```

### `lime0`

```swift
case lime0
```

### `cyan100`

```swift
case cyan100
```

### `cyan99`

```swift
case cyan99
```

### `cyan95`

```swift
case cyan95
```

### `cyan90`

```swift
case cyan90
```

### `cyan80`

```swift
case cyan80
```

### `cyan70`

```swift
case cyan70
```

### `cyan60`

```swift
case cyan60
```

### `cyan50`

```swift
case cyan50
```

### `cyan40`

```swift
case cyan40
```

### `cyan30`

```swift
case cyan30
```

### `cyan20`

```swift
case cyan20
```

### `cyan10`

```swift
case cyan10
```

### `cyan0`

```swift
case cyan0
```

### `lightBlue100`

```swift
case lightBlue100
```

### `lightBlue99`

```swift
case lightBlue99
```

### `lightBlue95`

```swift
case lightBlue95
```

### `lightBlue90`

```swift
case lightBlue90
```

### `lightBlue80`

```swift
case lightBlue80
```

### `lightBlue70`

```swift
case lightBlue70
```

### `lightBlue60`

```swift
case lightBlue60
```

### `lightBlue50`

```swift
case lightBlue50
```

### `lightBlue40`

```swift
case lightBlue40
```

### `lightBlue30`

```swift
case lightBlue30
```

### `lightBlue20`

```swift
case lightBlue20
```

### `lightBlue10`

```swift
case lightBlue10
```

### `lightBlue0`

```swift
case lightBlue0
```

### `violet100`

```swift
case violet100
```

### `violet99`

```swift
case violet99
```

### `violet95`

```swift
case violet95
```

### `violet90`

```swift
case violet90
```

### `violet80`

```swift
case violet80
```

### `violet70`

```swift
case violet70
```

### `violet60`

```swift
case violet60
```

### `violet50`

```swift
case violet50
```

### `violet45`

```swift
case violet45
```

### `violet40`

```swift
case violet40
```

### `violet30`

```swift
case violet30
```

### `violet20`

```swift
case violet20
```

### `violet10`

```swift
case violet10
```

### `violet0`

```swift
case violet0
```

### `purple100`

```swift
case purple100
```

### `purple99`

```swift
case purple99
```

### `purple95`

```swift
case purple95
```

### `purple90`

```swift
case purple90
```

### `purple80`

```swift
case purple80
```

### `purple70`

```swift
case purple70
```

### `purple60`

```swift
case purple60
```

### `purple50`

```swift
case purple50
```

### `purple40`

```swift
case purple40
```

### `purple30`

```swift
case purple30
```

### `purple20`

```swift
case purple20
```

### `purple10`

```swift
case purple10
```

### `purple0`

```swift
case purple0
```

### `pink100`

```swift
case pink100
```

### `pink99`

```swift
case pink99
```

### `pink95`

```swift
case pink95
```

### `pink90`

```swift
case pink90
```

### `pink80`

```swift
case pink80
```

### `pink70`

```swift
case pink70
```

### `pink60`

```swift
case pink60
```

### `pink50`

```swift
case pink50
```

### `pink46`

```swift
case pink46
```

### `pink40`

```swift
case pink40
```

### `pink30`

```swift
case pink30
```

### `pink20`

```swift
case pink20
```

### `pink10`

```swift
case pink10
```

### `pink0`

```swift
case pink0
```

### `redOrange100`

```swift
case redOrange100
```

### `redOrange99`

```swift
case redOrange99
```

### `redOrange95`

```swift
case redOrange95
```

### `redOrange90`

```swift
case redOrange90
```

### `redOrange80`

```swift
case redOrange80
```

### `redOrange70`

```swift
case redOrange70
```

### `redOrange60`

```swift
case redOrange60
```

### `redOrange50`

```swift
case redOrange50
```

### `redOrange48`

```swift
case redOrange48
```

### `redOrange40`

```swift
case redOrange40
```

### `redOrange30`

```swift
case redOrange30
```

### `redOrange20`

```swift
case redOrange20
```

### `redOrange10`

```swift
case redOrange10
```

### `redOrange0`

```swift
case redOrange0
```

## Properties
<details><summary markdown="span"><code>name</code></summary>

```swift
public var name: String
```

</details>

## Methods
<details><summary markdown="span"><code>resolve(_:)</code></summary>

```swift
public func resolve(_: UITraitCollection) -> UIColor
```

</details>
