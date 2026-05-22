---
title: Spacing
description: UI 요소 간의 간격(gap, padding)을 정의하는 시스템
---

```swift
enum Spacing
```

## Overview

Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된 간격을 제공하기 위한 규격화된 값들을 정의합니다.

```swift
// UIKit에서 사용
let padding = CGFloat.spacing(.s16)
view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

// SwiftUI에서 사용
Text("Hello, World!")
    .padding(.horizontal, .spacing(.s24))
    .padding(.vertical, .spacing(.s16))
```

>  **Note**
>
> 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다. 예를 들어 s16은 16포인트의 간격을 의미합니다.

## Topics

### Enumeration Cases

<details>

<summary>``case s0``</summary>


0px
</details>
<details>

<summary>``case s1``</summary>


1px
</details>
<details>

<summary>``case s10``</summary>


10px
</details>
<details>

<summary>``case s12``</summary>


12px
</details>
<details>

<summary>``case s14``</summary>


14px
</details>
<details>

<summary>``case s16``</summary>


16px (기본 간격)
</details>
<details>

<summary>``case s2``</summary>


2px
</details>
<details>

<summary>``case s20``</summary>


20px
</details>
<details>

<summary>``case s24``</summary>


24px
</details>
<details>

<summary>``case s32``</summary>


32px
</details>
<details>

<summary>``case s4``</summary>


4px
</details>
<details>

<summary>``case s40``</summary>


40px
</details>
<details>

<summary>``case s48``</summary>


48px
</details>
<details>

<summary>``case s56``</summary>


56px
</details>
<details>

<summary>``case s6``</summary>


6px
</details>
<details>

<summary>``case s64``</summary>


64px
</details>
<details>

<summary>``case s72``</summary>


72px
</details>
<details>

<summary>``case s8``</summary>


8px
</details>
<details>

<summary>``case s80``</summary>


80px
</details>

### Associated Extensions

<details>

<summary>``extension CGFloat``</summary>

<details>

<summary>``static func spacing(Spacing) -> CGFloat``</summary>


Spacing 열거형 값에 해당하는 CGFloat 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `spacing` | 사용할 간격 열거형 값 |
- **Return Value**

  지정된 간격에 해당하는 CGFloat 값
- **Discussion**

  디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.

  ```swift
  let padding = CGFloat.spacing(.s16) // 16.0
  ```

</details>


</details>


<details>

<summary>``extension Float``</summary>

<details>

<summary>``static func spacing(Spacing) -> Float``</summary>


Spacing 열거형 값에 해당하는 Float 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `spacing` | 사용할 간격 열거형 값 |
- **Return Value**

  지정된 간격에 해당하는 Float 값
- **Discussion**

  디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.

  ```swift
  let padding = Float.spacing(.s16) // 16.0
  ```

</details>


</details>

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



