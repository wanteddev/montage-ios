---
title: Text
---

```swift
extension Text
```

## Topics

### Instance Methods


``func montage(variant: Typography.Variant, weight: Typography.Weight, atomic: Color.Atomic) -> Text``

Montage 디자인 시스템의 스타일을 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `atomic` | 아토믹 색상 |
- **Return Value**

  스타일이 적용된 Text 인스턴스

``func montage(variant: Typography.Variant, weight: Typography.Weight, color: SwiftUI.Color) -> Text``

Montage 디자인 시스템의 스타일을 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `color` | 색상 |
- **Return Value**

  스타일이 적용된 Text 인스턴스

``func montage(variant: Typography.Variant, weight: Typography.Weight, colorResolver: ColorResolvable) -> Text``

Montage 디자인 시스템의 스타일을 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `colorResolver` | 색상 해석기 |
- **Return Value**

  스타일이 적용된 Text 인스턴스

``func montage(variant: Typography.Variant, weight: Typography.Weight, semantic: Color.Semantic) -> Text``

Montage 디자인 시스템의 스타일을 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `semantic` | 시맨틱 색상 |
- **Return Value**

  스타일이 적용된 Text 인스턴스

