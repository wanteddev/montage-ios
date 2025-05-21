---
title: UIFont
---

```swift
extension UIFont
```

## Topics

### Type Methods


``static func montage(size: CGFloat, weight: Typography.Weight) -> UIFont?``

Montage 디자인 시스템의 폰트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 폰트 크기 |
  | `weight` | 폰트 두께 |
- **Return Value**

  생성된 UIFont 인스턴스. 폰트를 찾을 수 없는 경우 nil 반환

``static func montage(variant: Typography.Variant, weight: Typography.Weight) -> UIFont``

Montage 디자인 시스템의 폰트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
- **Return Value**

  생성된 UIFont 인스턴스. 폰트를 찾을 수 없는 경우 시스템 폰트로 대체

