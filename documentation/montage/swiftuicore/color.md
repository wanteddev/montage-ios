---
title: Color
---

```swift
extension SwiftUI.Color
```

## Topics

### Instance Properties

<details>

<summary>``var uiColor: UIColor``</summary>

SwiftUI.Color를 UIColor로 변환합니다.
- **Return Value**

  변환된 UIColor 인스턴스
</details>

___
### Type Methods

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

<summary>``static func montage(ColorResolvable) -> SwiftUI.Color``</summary>

ColorResolvable 프로토콜을 준수하는 타입에 해당하는 SwiftUI.Color를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 색상 타입 |
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

