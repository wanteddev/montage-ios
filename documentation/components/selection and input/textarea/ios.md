---
title: Text area
description: 여러 줄의 텍스트 입력을 위한 컴포넌트입니다.
---

```swift
@MainActor struct TextArea
```

## Overview

이 컴포넌트는 사용자가 여러 줄의 텍스트를 입력할 수 있는 영역을 제공합니다. 사이즈, 리사이즈 옵션, 하단 리소스 등 다양한 기능을 지원합니다.

```swift
@State private var longText = ""
@FocusState private var isFocused: Bool

// 기본 텍스트 영역
TextArea(text: $longText, focus: $isFocused)
    .placeholder("의견을 입력해주세요")

// 중간 사이즈와 고정 크기를 가진 텍스트 영역
TextArea(text: $longText)
    .size(.medium)
    .resize(.fixed(min: 108, max: 200))

// 입력 글자 수를 추적하는 텍스트 영역
@State private var characterCount = 0
TextArea(text: $longText)
    .maxLength(100)
    .onTextChange { characterCount = $0.count }
```

## Topics

### Initializers

<details>

<summary>``init(text: Binding<String>, focus: FocusState<Bool>.Binding?)``</summary>


텍스트 영역을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 텍스트 영역의 값을 바인딩 |
  | `focus` | 텍스트 영역의 포커스 상태를 바인딩, 생략하면 기본값으로 `nil` 적용 |
</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func bottomResources(leading: [Resource], trailing: [Resource], leadingResourceSpacing: CGFloat, trailingResourceSpacing: CGFloat) -> TextArea``</summary>


텍스트 영역 하단에 표시할 UI 요소를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `leadingResources` | 왼쪽에 표시할 UI 요소 배열 (최대 3개) |
  | `trailingResources` | 오른쪽에 표시할 UI 요소 배열 (최대 3개) |
  | `leadingResourceSpacing` | 왼쪽 요소 간의 간격 |
  | `trailingResourceSpacing` | 오른쪽 요소 간의 간격 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**
  >  **Note**
  >
  > `button`·`primaryIconButton`은 디자인 가이드상 trailing 전용이므로 leading에 전달되면 무시됩니다.

</details>
<details>

<summary>``func disable(Bool) -> TextArea``</summary>


텍스트 영역의 활성화 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
</details>
<details>

<summary>``func inputTransform(((String) -> String)?) -> TextArea``</summary>


입력되는 텍스트를 입력 시점에 변환할 클로저를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `transform` | 입력 조각을 변환하는 클로저, nil이면 변환하지 않음 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**

  사용자가 입력하거나 붙여넣는 텍스트(replacement) 조각에 적용됩니다. emoji 제거 등 도메인별 정규화에 사용합니다. 사후 변형이 아닌 입력 단계에서 적용되므로 UITextView의 텍스트와 UndoManager가 일관되게 유지됩니다.
</details>
<details>

<summary>``func maxLength(Int?) -> TextArea``</summary>


최대 글자 수를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `limit` | 최대 글자 수, nil이면 제한 없음 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**

  카운터 UI를 표시하지 않고 입력 길이만 제한합니다. 사후 변형이 아닌 입력 단계에서 제한하므로 UITextView의 텍스트와 UndoManager가 일관되게 유지되며, 초과 입력/붙여넣기는 허용분만 잘라서 삽입됩니다.
</details>
<details>

<summary>``func negative(Bool) -> TextArea``</summary>


텍스트 영역의 오류 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `negative` | 오류 상태 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**

  오류 상태일 때는 텍스트 영역이 적색 테두리로 강조됩니다.
</details>
<details>

<summary>``func onTextChange((String) -> Void) -> TextArea``</summary>


텍스트가 변경될 때마다 호출할 클로저를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `handler` | 변경된 텍스트를 전달받는 클로저 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**

  변경된 전체 텍스트를 전달하므로 글자 수 계산(`text.count`), 유효성 검사 등 다양한 후처리에 사용할 수 있습니다.
</details>
<details>

<summary>``func placeholder(String?) -> TextArea``</summary>


텍스트 영역에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placeholder` | 표시할 플레이스홀더 텍스트 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
</details>
<details>

<summary>``func resize(Resize) -> TextArea``</summary>


텍스트 영역의 크기 조절 방식을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `resize` | 크기 조절 방식 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
</details>
<details>

<summary>``func size(Size) -> TextArea``</summary>


텍스트 영역의 사이즈를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 텍스트 영역의 사이즈 |
- **Return Value**

  수정된 텍스트 영역 인스턴스
</details>

### Enumerations

<details>

<summary>``enum Resize``</summary>


텍스트 영역의 크기 조절 방식을 정의합니다.
#### Enumeration Cases

<details>

<summary>``case fixed(min: CGFloat, max: CGFloat)``</summary>


텍스트 영역의 최소 및 최대 높이를 지정합니다. 초과 부분은 스크롤할 수 있습니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `min` | 최소 높이 |
  | `max` | 최대 높이 |
</details>
<details>

<summary>``case limit``</summary>


최대 6줄까지 표시되며, 초과 부분은 스크롤할 수 있습니다. 최소 높이는 2줄 기준입니다.
</details>
<details>

<summary>``case normal``</summary>


줄 수 제한이 없으며, 입력된 텍스트에 따라 영역이 자동으로 확장됩니다. 최소 높이는 2줄 기준입니다.
</details>

</details>
<details>

<summary>``enum Resource``</summary>


텍스트 영역 하단(Bottom Content)에 표시할 수 있는 UI 요소를 정의합니다.
#### Enumeration Cases

<details>

<summary>``case button(color: Button.Color, title: String, handler: (() -> Void)?)``</summary>


텍스트 버튼(Outlined)

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 버튼 색상, 생략하면 기본값으로 `.assistive` 적용 |
  | `title` | 버튼 텍스트 |
  | `handler` | 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용 |
</details>
<details>

<summary>``case contentBadge(ContentBadge.Variant, title: String)``</summary>


콘텐츠 뱃지

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 뱃지 변형 스타일, 생략하면 기본값으로 `.solid` 적용 |
  | `title` | 뱃지 텍스트 |
</details>
<details>

<summary>``case icon(Icon, tintColor: SwiftUI.Color)``</summary>


단순 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
  | `tintColor` | 아이콘 색상, 생략하면 기본값으로 `.semantic(.labelAssistive)` 적용 |
</details>
<details>

<summary>``case iconButton(icon: Icon, tintColor: SwiftUI.Color, handler: (() -> Void)?)``</summary>


아이콘 버튼(배경 없음)

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 버튼 아이콘 |
  | `tintColor` | 아이콘 색상, 생략하면 기본값으로 `.semantic(.labelAlternative)` 적용 |
  | `handler` | 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용 |
</details>
<details>

<summary>``case primaryIconButton(icon: Icon, handler: (() -> Void)?)``</summary>


Primary 아이콘 버튼(Solid)

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 버튼 아이콘 |
  | `handler` | 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용 |
</details>
<details>

<summary>``case segmentedControl(selectedIndex: Binding<Int>, icons: [Icon], accessibilityLabels: [String], onSelect: ((Int) -> Void)?)``</summary>


세그먼트 컨트롤(아이콘 전용). Bottom Content 전용 크기로 렌더링되며 정방형 아이콘만 받습니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `selectedIndex` | 선택된 세그먼트 인덱스 바인딩 |
  | `icons` | 세그먼트 아이콘 배열 |
  | `accessibilityLabels` | 세그먼트별 VoiceOver 라벨 배열, 생략하면 기본값으로 `[]` 적용 |
  | `onSelect` | 선택 변경 핸들러, 생략하면 기본값으로 `nil` 적용 |
- **Discussion**

  아이콘만 노출되므로 VoiceOver 사용자를 위해 세그먼트별 `accessibilityLabels`를 함께 전달하는 것을 권장합니다. 라벨을 생략하거나 개수가 부족하면 해당 세그먼트는 아이콘 이름으로 대체됩니다.
</details>
<details>

<summary>``case slotView(() -> AnyView)``</summary>


임의 뷰. `.slot { ... }` 팩토리로 생성합니다.
</details>

#### Instance Properties

<details>

<summary>``var isLeadingAllowed: Bool``</summary>


leading(왼쪽)에 배치할 수 있는 리소스인지 여부. `button`·`primaryIconButton`은 trailing 전용입니다.
</details>

#### Type Methods

<details>

<summary>``static func slot<V>(() -> V) -> Resource``</summary>


임의 뷰를 Bottom Content에 배치합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `content` | 표시할 뷰를 생성하는 클로저 |
- **Return Value**

  구성된 리소스
</details>

</details>
<details>

<summary>``enum Size``</summary>


텍스트 영역의 사이즈를 정의합니다.
#### Enumeration Cases

<details>

<summary>``case large``</summary>


큰 사이즈 (입력 `body2`, 최소 콘텐츠 높이 48)
</details>
<details>

<summary>``case medium``</summary>


중간 사이즈 (입력 `label1`, 최소 콘텐츠 높이 44)
</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



