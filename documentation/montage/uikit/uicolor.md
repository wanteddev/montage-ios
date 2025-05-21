---
title: UIColor
---

```swift
extension UIColor
```

## Topics

### Type Methods


``static func atomic(Color.Atomic) -> UIColor``

Atomic 색상 타입에 해당하는 UIColor를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Atomic 색상 타입 |
- **Return Value**

  동적으로 생성된 UIColor 인스턴스

``static func montage(ColorResolvable) -> UIColor``

ColorResolvable 프로토콜을 준수하는 타입에 해당하는 UIColor를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 색상 타입 |
- **Return Value**

  동적으로 생성된 UIColor 인스턴스

``static func semantic(Color.Semantic) -> UIColor``

Semantic 색상 타입에 해당하는 UIColor를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `type` | 생성할 Semantic 색상 타입 |
- **Return Value**

  동적으로 생성된 UIColor 인스턴스

