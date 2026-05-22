---
title: Dimension
description: 컴포넌트의 너비/높이를 정의하는 시스템
---

```swift
enum Dimension
```

## Overview

Dimension은 아이콘, 아바타, 컨트롤 등 컴포넌트의 고정 치수(width/height)에 일관된 값을 적용하기 위한 토큰입니다.

```swift
// SwiftUI
Image(systemName: "star")
    .frame(width: .dimension(.d24), height: .dimension(.d24))

// UIKit
imageView.widthAnchor.constraint(equalToConstant: .dimension(.d24)).isActive = true
```

## Topics

### Enumeration Cases

<details>

<summary>``case d14``</summary>


14px
</details>
<details>

<summary>``case d16``</summary>


16px
</details>
<details>

<summary>``case d18``</summary>


18px
</details>
<details>

<summary>``case d20``</summary>


20px
</details>
<details>

<summary>``case d24``</summary>


24px
</details>
<details>

<summary>``case d32``</summary>


32px
</details>
<details>

<summary>``case d40``</summary>


40px
</details>
<details>

<summary>``case d48``</summary>


48px
</details>
<details>

<summary>``case d56``</summary>


56px
</details>
<details>

<summary>``case d64``</summary>


64px
</details>

### Associated Extensions

<details>

<summary>``extension CGFloat``</summary>

<details>

<summary>``static func dimension(Dimension) -> CGFloat``</summary>


Dimension 열거형 값에 해당하는 CGFloat 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `dimension` | 사용할 Dimension 열거형 값 |
- **Return Value**

  지정된 치수에 해당하는 CGFloat 값
</details>


</details>


<details>

<summary>``extension Float``</summary>

<details>

<summary>``static func dimension(Dimension) -> Float``</summary>


Dimension 열거형 값에 해당하는 Float 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `dimension` | 사용할 Dimension 열거형 값 |
- **Return Value**

  지정된 치수에 해당하는 Float 값
</details>


</details>

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



