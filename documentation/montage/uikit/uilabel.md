---
title: UILabel
---

```swift
extension UILabel
```

## Topics

### Type Methods


``static func montage(String) -> UILabel``

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `string` | 표시할 문자열 |
- **Return Value**

  생성된 UILabel 인스턴스

``static func montage(String, variant: Typography.Variant, weight: Typography.Weight) -> UILabel``

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `string` | 표시할 문자열 |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
- **Return Value**

  생성된 UILabel 인스턴스

``static func montage(String, variant: Typography.Variant, weight: Typography.Weight, atomic: Color.Atomic) -> UILabel``

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `string` | 표시할 문자열 |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `atomic` | 아토믹 색상 |
- **Return Value**

  생성된 UILabel 인스턴스

``static func montage(String, variant: Typography.Variant, weight: Typography.Weight, colorResolver: ColorResolvable) -> UILabel``

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `string` | 표시할 문자열 |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `colorResolver` | 색상 해석기 |
- **Return Value**

  생성된 UILabel 인스턴스

``static func montage(String, variant: Typography.Variant, weight: Typography.Weight, semantic: Color.Semantic) -> UILabel``

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `string` | 표시할 문자열 |
  | `variant` | 텍스트 변형 |
  | `weight` | 폰트 두께 |
  | `semantic` | 시맨틱 색상 |
- **Return Value**

  생성된 UILabel 인스턴스

