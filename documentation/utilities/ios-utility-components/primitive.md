---
title: Primitive
description: 모든 치수 토큰의 원시 척도(Primitive scale)
---

```swift
enum Primitive
```

## Overview

Primitive는 Spacing, Radius, Dimension 등 상위 토큰의 기반이 되는 원시 수치 값입니다. 일반적으로 컴포넌트 구현에서 직접 사용하지 말고, 의도가 명시된 상위 토큰 (`Spacing`, `Radius`, `Dimension`)을 사용하세요.

```swift
// 권장: 의도가 명시된 상위 토큰 사용
let padding = CGFloat.spacing(.s16)

// 예외: 적합한 상위 토큰이 없을 때만 Primitive 사용
let custom = CGFloat.primitive(.p18)
```

## Topics

### Enumeration Cases

<details>

<summary>``case p0``</summary>


0px
</details>
<details>

<summary>``case p1``</summary>


1px
</details>
<details>

<summary>``case p10``</summary>


10px
</details>
<details>

<summary>``case p12``</summary>


12px
</details>
<details>

<summary>``case p14``</summary>


14px
</details>
<details>

<summary>``case p16``</summary>


16px
</details>
<details>

<summary>``case p18``</summary>


18px
</details>
<details>

<summary>``case p2``</summary>


2px
</details>
<details>

<summary>``case p20``</summary>


20px
</details>
<details>

<summary>``case p24``</summary>


24px
</details>
<details>

<summary>``case p32``</summary>


32px
</details>
<details>

<summary>``case p4``</summary>


4px
</details>
<details>

<summary>``case p40``</summary>


40px
</details>
<details>

<summary>``case p48``</summary>


48px
</details>
<details>

<summary>``case p56``</summary>


56px
</details>
<details>

<summary>``case p6``</summary>


6px
</details>
<details>

<summary>``case p64``</summary>


64px
</details>
<details>

<summary>``case p72``</summary>


72px
</details>
<details>

<summary>``case p8``</summary>


8px
</details>
<details>

<summary>``case p80``</summary>


80px
</details>
<details>

<summary>``case p9999``</summary>


9999px (pill/원형 등 사실상 무한대 값)
</details>

### Associated Extensions

<details>

<summary>``extension CGFloat``</summary>

<details>

<summary>``static func primitive(Primitive) -> CGFloat``</summary>


Primitive 열거형 값에 해당하는 CGFloat 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `primitive` | 사용할 Primitive 열거형 값 |
- **Return Value**

  지정된 Primitive에 해당하는 CGFloat 값
</details>


</details>


<details>

<summary>``extension Float``</summary>

<details>

<summary>``static func primitive(Primitive) -> Float``</summary>


Primitive 열거형 값에 해당하는 Float 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `primitive` | 사용할 Primitive 열거형 값 |
- **Return Value**

  지정된 Primitive에 해당하는 Float 값
</details>


</details>

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



