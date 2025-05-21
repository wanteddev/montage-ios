---
title: Input
description: 텍스트와 함께 표시되는 선택 컨트롤 컴포넌트입니다.
---

```swift
@MainActor struct Input
```

## Overview

체크박스, 체크마크, 라디오 버튼과 같은 컨트롤을 텍스트 레이블과 함께 표시합니다. 사용자가 텍스트를 클릭하여 컨트롤의 상태를 변경할 수 있습니다.

```swift
// 체크박스와 텍스트
Input.checkbox(checked: true, text: "이용약관에 동의합니다") { isChecked in
    print("동의 상태: \(isChecked)")
}

// 라디오 버튼과 텍스트
Input.radio(checked: false, text: "옵션 1")
    .bold()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Input.checkmark($isChecked, text: "완료됨")
```

>  Note
>
> 컨트롤과 텍스트는 수직 정렬되어 표시됩니다.

## Topics

### Instance Properties


``var body: some View``

### Instance Methods


``func bold(Bool) -> Input``

텍스트를 볼드체로 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `isBold` | 볼드 적용 여부 (기본값: true) |
- **Return Value**

  수정된 입력 컴포넌트

``func disable(Bool) -> Input``

컴포넌트를 비활성화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `isDisable` | 비활성화 여부 (기본값: true) |
- **Return Value**

  수정된 입력 컴포넌트
- **Discussion**

  비활성화된 컴포넌트는 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

``func size(Control.Size) -> Input``

컨트롤 사이즈를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 컨트롤 크기 (.medium 또는 .small) |
- **Return Value**

  수정된 입력 컴포넌트

``func tight(Bool) -> Input``

컨트롤을 더 조밀한 레이아웃으로 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `tight` | 조밀한 레이아웃 적용 여부 (기본값: true) |
- **Return Value**

  수정된 입력 컴포넌트

``func title(Typography.Variant?, weight: Typography.Weight?, color: SwiftUI.Color?) -> Input``

텍스트의 타이포그래피 속성을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 텍스트 변형 (.body2 또는 .label1) |
  | `weight` | 텍스트 굵기 |
  | `color` | 텍스트 색상 |
- **Return Value**

  수정된 입력 컴포넌트

### Type Methods


``static func checkbox(Binding<Control.State>, text: String) -> Input``

상태 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 체크박스 상태와 연결된 바인딩 |
  | `text` | 표시할 텍스트 |
- **Return Value**

  구성된 입력 컴포넌트

``static func checkbox(Binding<Bool>, text: String) -> Input``

불리언 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크박스 선택 상태와 연결된 바인딩 |
  | `text` | 표시할 텍스트 |
- **Return Value**

  구성된 입력 컴포넌트

``static func checkbox(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input``

불리언 값을 이용해 체크박스와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크박스의 초기 선택 상태 |
  | `text` | 표시할 텍스트 |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 입력 컴포넌트

``static func checkbox(state: Control.State, text: String, onSelect: ((Control.State) -> Void)?) -> Input``

상태 값을 이용해 체크박스와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 체크박스의 초기 상태 |
  | `text` | 표시할 텍스트 |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 입력 컴포넌트

``static func checkmark(Binding<Bool>, text: String) -> Input``

불리언 바인딩을 이용해 체크마크와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크마크 선택 상태와 연결된 바인딩 |
  | `text` | 표시할 텍스트 |
- **Return Value**

  구성된 입력 컴포넌트

``static func checkmark(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input``

불리언 값을 이용해 체크마크와 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크마크의 초기 선택 상태 |
  | `text` | 표시할 텍스트 |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 입력 컴포넌트

``static func radio(Binding<Bool>, text: String) -> Input``

불리언 바인딩을 이용해 라디오 버튼과 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 라디오 버튼 선택 상태와 연결된 바인딩 |
  | `text` | 표시할 텍스트 |
- **Return Value**

  구성된 입력 컴포넌트

``static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input``

불리언 값을 이용해 라디오 버튼과 텍스트를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 라디오 버튼의 초기 선택 상태 |
  | `text` | 표시할 텍스트 |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 입력 컴포넌트

### Default Implementations


[View Implementations](/documentation/montage/input/view-implementations.md)

[View Implementations](/documentation/montage/input/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



