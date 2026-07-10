---
title: Form control
description: 입력 컨트롤에 제목(Label)과 도움말(Message)을 붙여 주고, 라벨 ↔ 입력 ↔ 메시지의 접근성 연결을 자동으로 처리하는 래퍼(wrapper) 컴포넌트입니다.
---

```swift
@MainActor struct FormControl
```

## Overview

FormControl은 단독으로 값을 입력받지 않습니다. 내부 슬롯(`input`)에 실제 입력 컴포넌트를 조합해 사용하며, 라벨·필수 표시(`*`)·도움말/에러 메시지·액세서리(글자 수 카운트 등)를 일관된 레이아웃으로 감싸 줍니다.

슬롯 클로저는 현재 [FormControl.Context](/documentation/montage/formcontrol/context.md)(크기·상태)를 전달받습니다. 입력 컴포넌트가 이를 반영하면 FormControl의 `.size(_:)`·`.status(_:)` 한 번 설정만으로 내부 입력까지 일관되게 그려집니다.

```swift
FormControl { context in
    TextField(text: $email)
        .size(context.size == .medium ? .medium : .large)
        .status(context.status.textFieldStatus)
        .placeholder("이메일을 입력하세요")
}
.label("이메일", required: true)
.message("회사 이메일을 입력해 주세요.")

// 에러 상태 — FormControl에만 .status(.negative)를 주면 메시지 색과 입력 상태가 함께 바뀐다.
FormControl { context in
    TextField(text: $email).status(context.status.textFieldStatus)
}
.size(.medium)
.status(.negative)
.label("이메일", required: true)
.message("올바른 이메일 형식이 아닙니다.")
.accessory {
    Text("\(email.count)/100")
        .typography(variant: .caption1, weight: .regular, semantic: .labelAlternative)
}

// 라벨을 입력 왼쪽에 배치
FormControl { _ in
    TextField(text: $name)
}
.labelPlacement(.leading)
.label("이름")
```

## Topics

### Structures

<details>

<summary>``struct Context``</summary>


입력 슬롯 클로저에 전달되는 FormControl의 현재 상태 컨텍스트입니다.
#### Instance Properties

<details>

<summary>``let size: Size``</summary>


현재 FormControl 크기.
</details>
<details>

<summary>``let status: Status``</summary>


현재 FormControl 상태.
</details>

</details>

### Initializers

<details>

<summary>``init<Input>(input: (Context) -> Input)``</summary>


입력 컴포넌트를 슬롯으로 받아 FormControl을 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `input` | 현재 [FormControl.Context](/documentation/montage/formcontrol/context.md)를 받아 감쌀 입력 컴포넌트를 반환하는 뷰 빌더 |
- **Discussion**

  클로저는 현재 [FormControl.Context](/documentation/montage/formcontrol/context.md)(크기·상태)를 전달받으므로, 입력 컴포넌트가 FormControl의 크기·상태를 그대로 반영할 수 있습니다. (예: FormControl에 `.status(.negative)`만 설정하면 내부 입력도 에러 상태로 그릴 수 있음)
</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func accessory<Accessory>(() -> Accessory) -> FormControl``</summary>


Footer 우측(trailing)에 표시할 액세서리 뷰를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `accessory` | 표시할 액세서리 뷰 빌더 |
- **Return Value**

  수정된 FormControl 컴포넌트
- **Discussion**

  글자 수 카운트, 타이머 등 입력 아래에 붙는 보조 요소를 자유롭게 구성할 수 있습니다. 스타일(타이포그래피·색)은 호출부에서 지정합니다.
</details>
<details>

<summary>``func label(String?, required: Bool) -> FormControl``</summary>


라벨 텍스트와 필수 표시 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 라벨 텍스트. `nil`이거나 비어 있으면 라벨을 표시하지 않습니다. |
  | `required` | 필수 입력 표시(`*`) 여부. 생략하면 기본값으로 `false` 적용 |
- **Return Value**

  수정된 FormControl 컴포넌트
</details>
<details>

<summary>``func labelPlacement(LabelPlacement) -> FormControl``</summary>


라벨 위치를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placement` | 라벨 위치. 생략하면 기본값으로 `.top` 적용 |
- **Return Value**

  수정된 FormControl 컴포넌트
</details>
<details>

<summary>``func labelWidth(CGFloat) -> FormControl``</summary>


leading 배치에서 이 컨트롤의 라벨 폭을 명시적으로 고정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `width` | 라벨 열 폭(pt). |
- **Return Value**

  수정된 FormControl 컴포넌트
- **Discussion**

  주 용도는 두 가지입니다. (1) 단독 leading FormControl에서 라벨 폭을 스펙값으로 맞출 때, 그리고 (2) [FormControlGroup](/documentation/montage/formcontrolgroup.md) 안에서 특정 행 하나만 다른 폭으로 둘 때(per-control 값이 컨테이너 폭보다 우선).

  컬럼 전체를 고정 폭으로 맞추려면 각 컨트롤에 반복하지 말고 [FormControlGroup](/documentation/montage/formcontrolgroup.md)의 `labelWidth`를 쓰세요. [FormControl.LabelPlacement.top](/documentation/montage/formcontrol/labelplacement/top.md) 배치에는 영향이 없습니다.
</details>
<details>

<summary>``func message(String?) -> FormControl``</summary>


도움말/에러 메시지를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 메시지 텍스트. `nil`이거나 비어 있으면 메시지를 표시하지 않습니다. |
- **Return Value**

  수정된 FormControl 컴포넌트
- **Discussion**
  >  **Note**
  >
  > 메시지 색은 [status(_:)](/documentation/montage/formcontrol/status(_:).md)에 따라 결정됩니다. `.negative`에서만 강조 색으로 표시됩니다.

</details>
<details>

<summary>``func size(Size) -> FormControl``</summary>


크기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | FormControl 크기. 생략하면 기본값으로 `.large` 적용 |
- **Return Value**

  수정된 FormControl 컴포넌트
</details>
<details>

<summary>``func status(Status) -> FormControl``</summary>


상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `status` | FormControl 상태. 생략하면 기본값으로 `.normal` 적용 |
- **Return Value**

  수정된 FormControl 컴포넌트
</details>

### Enumerations

<details>

<summary>``enum LabelPlacement``</summary>


라벨의 위치입니다.
#### Enumeration Cases

<details>

<summary>``case leading``</summary>


라벨을 입력의 leading 쪽에 가로로 배치하고, 입력 슬롯의 첫 줄에 맞춥니다. (단일 행 입력은 입력 세로 중앙과 같고, 다중 행 입력은 입력 전체가 아니라 첫 줄을 기준으로 정렬됩니다.)
</details>
<details>

<summary>``case top``</summary>


라벨을 입력 위에 세로로 배치합니다. (기본)
</details>

</details>
<details>

<summary>``enum Size``</summary>


FormControl의 크기입니다. 라벨 타이포그래피를 결정합니다.
#### Enumeration Cases

<details>

<summary>``case large``</summary>


큰 크기 (라벨 `label1`)
</details>
<details>

<summary>``case medium``</summary>


중간 크기 (라벨 `label2`)
</details>

</details>
<details>

<summary>``enum Status``</summary>


FormControl의 상태입니다. 메시지의 색을 결정합니다.
#### Enumeration Cases

<details>

<summary>``case negative``</summary>


에러 상태. 메시지는 강조 색(`statusNegative`)으로 표시됩니다.
</details>
<details>

<summary>``case normal``</summary>


기본 상태. 메시지는 도움말 색(`labelAlternative`)으로 표시됩니다.
</details>
<details>

<summary>``case positive``</summary>


성공 상태. 메시지는 기본 도움말과 동일한 색(`labelAlternative`)으로 표시됩니다.
</details>

#### Instance Properties

<details>

<summary>``var textFieldStatus: TextField.Status``</summary>


같은 의미의 TextField 상태 값으로 변환합니다.
- **Discussion**

  슬롯에 [TextField](/documentation/montage/textfield.md)를 둘 때 [status](/documentation/montage/formcontrol/context/status.md)를 그대로 전달하기 위한 편의 변환입니다.
</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



