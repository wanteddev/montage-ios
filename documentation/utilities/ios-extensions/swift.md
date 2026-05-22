---
title: Swift
---

## Topics

### Extended Structures

<details>

<summary>``extension Float``</summary>

#### Type Methods

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
<details>

<summary>``static func opacity(Opacity) -> Float``</summary>


Opacity 열거형 값에 해당하는 Float 불투명도 값을 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `opacityComponent` | 사용할 불투명도 열거형 값 |
- **Return Value**

  지정된 불투명도에 해당하는 Float 값 (0.0 ~ 1.0 범위)
- **Discussion**

  디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

  ```swift
  let alpha = Float.opacity(.p050) // 0.5
  ```

</details>
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

