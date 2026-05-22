---
title: Radius
description: 모서리 반경(corner radius)을 정의하는 시스템
---

```swift
enum Radius
```

## Overview

Radius는 컴포넌트의 둥근 모서리 반경을 일관되게 적용하기 위한 토큰입니다.

```swift
// SwiftUI
RoundedRectangle(cornerRadius: .radius(.r12))

// UIKit
view.layer.cornerRadius = .radius(.r12)
```

## Topics

### Enumeration Cases

<details>

<summary>``case r0``</summary>


0px (직각)
</details>
<details>

<summary>``case r10``</summary>


10px
</details>
<details>

<summary>``case r12``</summary>


12px
</details>
<details>

<summary>``case r14``</summary>


14px
</details>
<details>

<summary>``case r16``</summary>


16px
</details>
<details>

<summary>``case r20``</summary>


20px
</details>
<details>

<summary>``case r24``</summary>


24px
</details>
<details>

<summary>``case r4``</summary>


4px
</details>
<details>

<summary>``case r8``</summary>


8px
</details>

### Associated Extensions

<details>

<summary>``extension CGFloat``</summary>

<details>

<summary>``static func radius(Radius) -> CGFloat``</summary>


Radius 열거형 값에 해당하는 CGFloat 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `radius` | 사용할 Radius 열거형 값 |
- **Return Value**

  지정된 모서리 반경에 해당하는 CGFloat 값
</details>


</details>


<details>

<summary>``extension Float``</summary>

<details>

<summary>``static func radius(Radius) -> Float``</summary>


Radius 열거형 값에 해당하는 Float 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `radius` | 사용할 Radius 열거형 값 |
- **Return Value**

  지정된 모서리 반경에 해당하는 Float 값
</details>


</details>

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



