---
title: CoreFoundation
---

## Topics

### Extended Structures

<details>

<summary>``extension CGFloat``</summary>

#### Type Properties

<details>

<summary>``static let dimension14: CGFloat``</summary>


14pt
</details>
<details>

<summary>``static let dimension16: CGFloat``</summary>


16pt
</details>
<details>

<summary>``static let dimension18: CGFloat``</summary>


18pt
</details>
<details>

<summary>``static let dimension20: CGFloat``</summary>


20pt
</details>
<details>

<summary>``static let dimension24: CGFloat``</summary>


24pt
</details>
<details>

<summary>``static let dimension28: CGFloat``</summary>


28pt
</details>
<details>

<summary>``static let dimension32: CGFloat``</summary>


32pt
</details>
<details>

<summary>``static let dimension40: CGFloat``</summary>


40pt
</details>
<details>

<summary>``static let dimension48: CGFloat``</summary>


48pt
</details>
<details>

<summary>``static let dimension56: CGFloat``</summary>


56pt
</details>
<details>

<summary>``static let dimension64: CGFloat``</summary>


64pt
</details>
<details>

<summary>``static let primitive0: CGFloat``</summary>


0pt
</details>
<details>

<summary>``static let primitive1: CGFloat``</summary>


1pt
</details>
<details>

<summary>``static let primitive10: CGFloat``</summary>


10pt
</details>
<details>

<summary>``static let primitive12: CGFloat``</summary>


12pt
</details>
<details>

<summary>``static let primitive14: CGFloat``</summary>


14pt
</details>
<details>

<summary>``static let primitive16: CGFloat``</summary>


16pt
</details>
<details>

<summary>``static let primitive18: CGFloat``</summary>


18pt
</details>
<details>

<summary>``static let primitive2: CGFloat``</summary>


2pt
</details>
<details>

<summary>``static let primitive20: CGFloat``</summary>


20pt
</details>
<details>

<summary>``static let primitive24: CGFloat``</summary>


24pt
</details>
<details>

<summary>``static let primitive28: CGFloat``</summary>


28pt
</details>
<details>

<summary>``static let primitive32: CGFloat``</summary>


32pt
</details>
<details>

<summary>``static let primitive4: CGFloat``</summary>


4pt
</details>
<details>

<summary>``static let primitive40: CGFloat``</summary>


40pt
</details>
<details>

<summary>``static let primitive48: CGFloat``</summary>


48pt
</details>
<details>

<summary>``static let primitive56: CGFloat``</summary>


56pt
</details>
<details>

<summary>``static let primitive6: CGFloat``</summary>


6pt
</details>
<details>

<summary>``static let primitive64: CGFloat``</summary>


64pt
</details>
<details>

<summary>``static let primitive72: CGFloat``</summary>


72pt
</details>
<details>

<summary>``static let primitive8: CGFloat``</summary>


8pt
</details>
<details>

<summary>``static let primitive80: CGFloat``</summary>


80pt
</details>
<details>

<summary>``static let primitiveInfinity: CGFloat``</summary>


무한대. Figma `9999` 토큰에 대응.
</details>
<details>

<summary>``static let radius0: CGFloat``</summary>


0pt (직각)
</details>
<details>

<summary>``static let radius10: CGFloat``</summary>


10pt
</details>
<details>

<summary>``static let radius12: CGFloat``</summary>


12pt
</details>
<details>

<summary>``static let radius14: CGFloat``</summary>


14pt
</details>
<details>

<summary>``static let radius16: CGFloat``</summary>


16pt
</details>
<details>

<summary>``static let radius20: CGFloat``</summary>


20pt
</details>
<details>

<summary>``static let radius24: CGFloat``</summary>


24pt
</details>
<details>

<summary>``static let radius4: CGFloat``</summary>


4pt
</details>
<details>

<summary>``static let radius8: CGFloat``</summary>


8pt
</details>
<details>

<summary>``static let spacing0: CGFloat``</summary>


0pt
</details>
<details>

<summary>``static let spacing1: CGFloat``</summary>


1pt
</details>
<details>

<summary>``static let spacing10: CGFloat``</summary>


10pt
</details>
<details>

<summary>``static let spacing12: CGFloat``</summary>


12pt
</details>
<details>

<summary>``static let spacing14: CGFloat``</summary>


14pt
</details>
<details>

<summary>``static let spacing16: CGFloat``</summary>


16pt (기본 간격)
</details>
<details>

<summary>``static let spacing2: CGFloat``</summary>


2pt
</details>
<details>

<summary>``static let spacing20: CGFloat``</summary>


20pt
</details>
<details>

<summary>``static let spacing24: CGFloat``</summary>


24pt
</details>
<details>

<summary>``static let spacing32: CGFloat``</summary>


32pt
</details>
<details>

<summary>``static let spacing4: CGFloat``</summary>


4pt
</details>
<details>

<summary>``static let spacing40: CGFloat``</summary>


40pt
</details>
<details>

<summary>``static let spacing48: CGFloat``</summary>


48pt
</details>
<details>

<summary>``static let spacing56: CGFloat``</summary>


56pt
</details>
<details>

<summary>``static let spacing6: CGFloat``</summary>


6pt
</details>
<details>

<summary>``static let spacing64: CGFloat``</summary>


64pt
</details>
<details>

<summary>``static let spacing72: CGFloat``</summary>


72pt
</details>
<details>

<summary>``static let spacing8: CGFloat``</summary>


8pt
</details>
<details>

<summary>``static let spacing80: CGFloat``</summary>


80pt
</details>

#### Type Methods

<details>

<summary>``static func opacity(Opacity) -> CGFloat``</summary>


Opacity 열거형 값에 해당하는 CGFloat 불투명도 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `opacityComponent` | 사용할 불투명도 열거형 값 |
- **Return Value**

  지정된 불투명도에 해당하는 CGFloat 값 (0.0 ~ 1.0 범위)
- **Discussion**

  디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

  ```swift
  let alpha = CGFloat.opacity(.p052) // 0.52
  ```

</details>

</details>

