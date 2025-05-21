---
title: Control
description: 체크박스, 체크마크, 라디오 버튼과 같은 선택 컨트롤을 제공하는 컴포넌트입니다.
---

```swift
@MainActor struct Control
```

## Overview

다양한 유형의 선택 컨트롤을 통일된 인터페이스로 제공합니다. 선택 상태 변경 시 콜백을 받을 수 있으며, 크기와 스타일을 조정할 수 있습니다.

```swift
// 체크박스
Control.checkbox(checked: true) { isChecked in
    print("체크박스 선택 상태: \(isChecked)")
}

// 라디오 버튼
Control.radio(checked: false)
    .tight()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Control.checkmark($isChecked)
```

>  Note
>
> 모든 컨트롤은 상태에 따라 적절한 시각적 피드백을 제공합니다.

## Topics

### Structures


[``struct Switch``](/documentation/montage/control/switch.md)

켜기/끄기 상태 전환이 가능한 스위치 컴포넌트입니다.

### Instance Properties


``var body: some View``

### Instance Methods


``func disable(Bool) -> Control``

컨트롤을 비활성화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부 (기본값: true) |
- **Return Value**

  수정된 컨트롤 인스턴스
- **Discussion**

  비활성화된 컨트롤은 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

``func tight(Bool) -> Control``

컨트롤을 더 조밀한 레이아웃으로 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `tight` | 조밀한 레이아웃 적용 여부 (기본값: true) |
- **Return Value**

  수정된 컨트롤 인스턴스
- **Discussion**

  이 수정자를 적용하면 컨트롤의 가로 너비가 줄어듭니다.

### Type Methods


``static func checkbox(Binding<Bool>, size: Size) -> Control``

불리언 바인딩을 이용해 체크박스를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크박스 선택 상태와 연결된 바인딩 |
  | `size` | 체크박스 크기 (기본값: .medium) |
- **Return Value**

  구성된 체크박스 컨트롤

``static func checkbox(Binding<State>, size: Size) -> Control``

상태 바인딩을 이용해 체크박스를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 체크박스 상태와 연결된 바인딩 |
  | `size` | 체크박스 크기 (기본값: .medium) |
- **Return Value**

  구성된 체크박스 컨트롤

``static func checkbox(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control``

불리언 값을 이용해 체크박스를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크박스의 초기 선택 상태 |
  | `size` | 체크박스 크기 (기본값: .medium) |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 체크박스 컨트롤

``static func checkbox(state: State, size: Size, onSelect: ((State) -> Void)?) -> Control``

상태 값을 이용해 체크박스를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 체크박스의 초기 상태 |
  | `size` | 체크박스 크기 (기본값: .medium) |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 체크박스 컨트롤

``static func checkmark(Binding<Bool>, size: Size) -> Control``

불리언 바인딩을 이용해 체크마크를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크마크 선택 상태와 연결된 바인딩 |
  | `size` | 체크마크 크기 (기본값: .medium) |
- **Return Value**

  구성된 체크마크 컨트롤

``static func checkmark(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control``

불리언 값을 이용해 체크마크를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 체크마크의 초기 선택 상태 |
  | `size` | 체크마크 크기 (기본값: .medium) |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 체크마크 컨트롤

``static func radio(Binding<Bool>, size: Size) -> Control``

불리언 바인딩을 이용해 라디오 버튼을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 라디오 버튼 선택 상태와 연결된 바인딩 |
  | `size` | 라디오 버튼 크기 (기본값: .medium) |
- **Return Value**

  구성된 라디오 버튼 컨트롤

``static func radio(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control``

불리언 값을 이용해 라디오 버튼을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `checked` | 라디오 버튼의 초기 선택 상태 |
  | `size` | 라디오 버튼 크기 (기본값: .medium) |
  | `onSelect` | 선택 상태 변경 시 호출되는 클로저 |
- **Return Value**

  구성된 라디오 버튼 컨트롤

### Enumerations


[``enum Size``](/documentation/montage/control/size.md)

컨트롤의 크기를 정의하는 열거형입니다.

[``enum State``](/documentation/montage/control/state.md)

컨트롤의 상태를 정의하는 열거형입니다.

[``enum Variant``](/documentation/montage/control/variant.md)

컨트롤의 종류를 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/control/view-implementations.md)

[View Implementations](/documentation/montage/control/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



