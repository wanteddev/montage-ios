---
title: Icon button
description: 다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.
---

```swift
@MainActor struct IconButton
```

## Overview

아이콘만 표시하는 간결한 버튼으로, 네 가지 variant를 지원합니다:

- 기본형(normal): 배경 없이 아이콘만 표시
- 배경형(background): 반투명·블러 배경 위 floating 액션
- 외곽선형(outlined): 테두리만 가진 보조 액션
- 솔리드형(solid): 채워진 배경의 강조 액션



- `normal` / `background`: _아이콘 크기_를 지정합니다. 컨테이너는 `nearestDimensionToken(icon × 1.5)` 으로 자동 산출되며, `normal`은 WCAG 2.2 SC 2.5.8 Target Size를 위해 박스 최소 24×24가 보장됩니다. `normal`의 corner radius는 `nearestRadiusToken(box × 0.3, tie→down)`.
- `outlined` / `solid`: _컨테이너 크기_를 지정합니다. 아이콘은 `box − 12` 로 자동 산출되며 박스 최소 24×24가 보장됩니다.

hit area는 항상 컨테이너와 동일합니다(이전의 확장된 hit area 정책 제거).

```swift
IconButton(
    icon: .arrowLeft,
    handler: { print("뒤로 가기 버튼 탭됨") }
)
```

## Topics

### Initializers

<details>

<summary>``init(variant: IconButton.Variant, icon: Icon, handler: (() -> Void)?)``</summary>


아이콘 버튼을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 버튼의 외관 스타일, 생략하면 기본값으로 `.normal(size: .xlarge)` 적용 |
  | `icon` | 표시할 아이콘 |
  | `handler` | 버튼 탭 시 실행할 핸들러 |
</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func backgroundColor(SwiftUI.Color) -> IconButton``</summary>


배경 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |
- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  >  **Note**
  >
  > Outlined, solid variant에서만 사용 가능합니다.

</details>
<details>

<summary>``func borderColor(SwiftUI.Color) -> IconButton``</summary>


테두리 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |
- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  >  **Note**
  >
  > Outlined 에서만 사용 가능합니다.

</details>
<details>

<summary>``func disable(Bool) -> IconButton``</summary>


버튼의 비활성화 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `value` | 비활성화 여부, true이면 버튼이 비활성화됩니다. |
- **Return Value**

  수정된 IconButton 인스턴스
</details>
<details>

<summary>``func iconColor(SwiftUI.Color) -> IconButton``</summary>


아이콘 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |
- **Return Value**

  수정된 IconButton 인스턴스
</details>
<details>

<summary>``func padding(CGFloat) -> IconButton``</summary>


버튼의 추가 패딩을 설정합니다(컨테이너 외곽을 그만큼 확장).

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `value` | 패딩 값 |
- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  >  **Note**
  >
  > Outlined, solid variant에서만 사용 가능합니다.

</details>
<details>

<summary>``func showPushBadge(Bool) -> IconButton``</summary>


푸시 뱃지 표시 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `value` | 푸시 뱃지 표시 여부 |
- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  >  **Note**
  >
  > Normal variant에서만 사용 가능합니다.

</details>

### Enumerations

<details>

<summary>``enum NormalSize``</summary>


`normal` variant의 아이콘 사이즈를 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case custom(size: Int)``</summary>


사용자 지정 크기

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (포인트) |
</details>
<details>

<summary>``case large``</summary>


큰 크기 (20pt)
</details>
<details>

<summary>``case medium``</summary>


중간 크기 (18pt)
</details>
<details>

<summary>``case small``</summary>


작은 크기 (16pt)
</details>
<details>

<summary>``case xlarge``</summary>


가장 큰 크기 (24pt)
</details>

</details>
<details>

<summary>``enum Size``</summary>


`outlined`·`solid` variant의 컨테이너 사이즈를 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case custom(size: Int)``</summary>


사용자 지정 크기

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 크기 (포인트). `box < 24`이면 24로 clamp됩니다. |
</details>
<details>

<summary>``case medium``</summary>


중간 크기 (40×40, 아이콘 18pt)
</details>
<details>

<summary>``case small``</summary>


작은 크기 (32×32, 아이콘 16pt)
</details>

</details>
<details>

<summary>``enum Variant``</summary>


버튼의 외관을 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case background(size: Int, isAlternative: Bool)``</summary>


배경형 아이콘 버튼 - 반투명·블러 배경을 가진 floating 액션

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (포인트). 생략하면 `20`이 적용됩니다. |
  | `isAlternative` | 다크 배경 위에서 사용하는 대체 스타일 여부, 생략하면 `false` |
</details>
<details>

<summary>``case normal(size: NormalSize)``</summary>


기본형 아이콘 버튼 - 배경 없이 아이콘만 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (`NormalSize`) |
</details>
<details>

<summary>``case outlined(size: Size)``</summary>


외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 크기 (`Size`). 아이콘은 `box − 12`로 자동 산출됩니다. |
</details>
<details>

<summary>``case solid(size: Size)``</summary>


솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 크기 (`Size`). 아이콘은 `box − 12`로 자동 산출됩니다. |
</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



