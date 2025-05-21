---
title: Float
---

```swift
extension Float
```

## Topics

### Type Methods


``static func opacity(Opacity) -> Float``

Opacity 열거형 값에 해당하는 Float 불투명도 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `opacityComponent` | 사용할 불투명도 열거형 값 |
- **Return Value**

  지정된 불투명도에 해당하는 Float 값 (0.0 ~ 1.0 범위)
- **Discussion**

  디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

``static func spacing(Spacing) -> Float``

Spacing 열거형 값에 해당하는 Float 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `spacingComponent` | 사용할 간격 열거형 값 |
- **Return Value**

  지정된 간격에 해당하는 Float 값
- **Discussion**

  디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.

