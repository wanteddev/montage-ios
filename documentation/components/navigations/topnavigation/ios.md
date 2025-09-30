---
title: Top navigation
description: 상단에 표시되는 내비게이션 바 컴포넌트입니다.
---

```swift
@MainActor struct TopNavigation
```

## Overview

제목, 뒤로가기, 추가 액션 버튼 등을 포함할 수 있으며, 다양한 외관 스타일을 지원합니다. 스크롤 시 배경색과 구분선의 불투명도가 자동으로 조절됩니다.

```swift
TopNavigation(
    scrollOffset: $scrollOffset,
    backgroundColor: .white
)
.variant(.normal)
.title ( /* 제목 텍스트 */ )
.leadingContent { /* 왼쪽 영역 컴포넌트 */ }
.trailingContents(
    { /* 컴포넌트1 },
    { /* 컴포넌트2 } ...
)
```

```swift
TopNavigation(
   scrollOffset: $scrollOffset,
   backgroundColor: .white
)
.variant(.floating())
.title { /* 제목 컴포넌트 */ }
.leadingContent { /* 왼쪽 영역 컴포넌트 */ }
.trailingContents(
   { /* 컴포넌트1 },
   { /* 컴포넌트2 } ...
)
```

## Topics

### Structures

<details>

<summary>``struct LeadingButton``</summary>

내비게이션 바의 왼쪽(leading) 영역에 위치하는 기본 버튼입니다.
#### Initializers

<details>

<summary>``init(Resource.LeadingButtonInfo?, Bool, Bool)``</summary>
</details>

#### Instance Properties

<details>

<summary>``var body: some View``</summary>
</details>

#### Default Implementations


[View Implementations](/docs/utilities/ios/view-implementations)

[View Implementations](/docs/utilities/ios/view-implementations)

</details>
<details>

<summary>``struct TitleView``</summary>

내비게이션 바의 제목 컴포넌트입니다.
#### Initializers

<details>

<summary>``init(variant: Variant, title: String)``</summary>
</details>

#### Instance Properties

<details>

<summary>``var body: some View``</summary>
</details>

#### Default Implementations


[View Implementations](/docs/utilities/ios/view-implementations)

[View Implementations](/docs/utilities/ios/view-implementations)

</details>
<details>

<summary>``struct TrailingIconButton``</summary>

내비게이션 바의 오른쪽(trailing)에 위치하는 아이콘 버튼입니다.
#### Initializers

<details>

<summary>``init(icon: Icon, disable: Bool, background: Bool, alternative: Bool, showPushBadge: Bool, action: () -> Void)``</summary>
</details>

#### Instance Properties

<details>

<summary>``var body: some View``</summary>
</details>

#### Default Implementations


[View Implementations](/docs/utilities/ios/view-implementations)

[View Implementations](/docs/utilities/ios/view-implementations)

</details>
<details>

<summary>``struct TrailingTextButton``</summary>

내비게이션 바의 오른쪽(trailing)에 위치하는 텍스트 버튼입니다.
#### Initializers

<details>

<summary>``init(text: String, background: Bool, alternative: Bool, disable: Bool, action: () -> Void)``</summary>
</details>

#### Instance Properties

<details>

<summary>``var body: some View``</summary>
</details>

#### Default Implementations


[View Implementations](/docs/utilities/ios/view-implementations)

[View Implementations](/docs/utilities/ios/view-implementations)

</details>

___
### Initializers

<details>

<summary>``init(scrollOffset: CGFloat, backgroundColor: SwiftUI.Color?)``</summary>

TopNavigation을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `scrollOffset` | 스크롤 오프셋 값 |
  | `backgroundColor` | 배경색 |
</details>

___
### Instance Properties

<details>

<summary>``var body: some View``</summary>
</details>

___
### Instance Methods

<details>

<summary>``func leadingContent<V>(content: () -> V) -> TopNavigation``</summary>

내비게이션 영역의 왼쪽(leadingContent) 영역에 표시할 뷰를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `content` | leadingContent 영역에 표시할 뷰를 반환하는 클로저 |
- **Return Value**

  수정된 인스턴스를 반환합니다.
- **Discussion**

  주로 아이콘이나 취소 버튼 등을 배치할 수 있으며, ViewBuilder를 통해 정의됩니다.
</details>
<details>

<summary>``func title<V>(content: () -> V) -> TopNavigation``</summary>

내비게이션 영역의 타이틀 뷰를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `content` | 표시할 타이틀 뷰를 반환하는 클로저 |
- **Return Value**

  수정된 인스턴스를 반환합니다.
- **Discussion**

  타이틀에는 텍스트 또는 커스텀 뷰를 사용할 수 있으며, ViewBuilder를 통해 정의됩니다.
</details>
<details>

<summary>``func title(text: String) -> TopNavigation``</summary>

텍스트 기반 타이틀을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 타이틀에 표시할 문자열 |
- **Return Value**

  수정된 내비게이션 바 인스턴스
- **Discussion**

  전달된 텍스트는 `TopNavigation.TitleView`로 감싸져 렌더링됩니다.
</details>
<details>

<summary>``func trailingContents((() -> any View)...) -> TopNavigation``</summary>

내비게이션 영역의 오른쪽(trailing) 영역에 표시할 뷰들을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | Trailing 영역에 표시할 뷰들을 반환하는 클로저들 |
- **Return Value**

  수정된 인스턴스를 반환합니다.
- **Discussion**

  최대 3개까지의 뷰를 클로저를 , 로 구분하여 전달할 수 있으며, 각 클로저는 다양한 타입의 View를 반환할 수 있습니다 (`any View`). 내부적으로는 모든 View를 `AnyView`로 타입을 지운 후 렌더링합니다.
</details>
<details>

<summary>``func trailingContents([() -> any View]) -> TopNavigation``</summary>

내비게이션 영역의 오른쪽(trailing) 영역에 표시할 뷰들을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | Trailing 영역에 표시할 뷰들을 반환하는 클로저 배열 |
- **Return Value**

  수정된 인스턴스를 반환합니다.
- **Discussion**

  최대 3개까지의 뷰를 클로저 배열로 전달할 수 있으며, 각 클로저는 다양한 타입의 View를 반환할 수 있습니다 (`any View`). 내부적으로는 모든 View를 `AnyView`로 타입을 지운 후 렌더링합니다.
</details>
<details>

<summary>``func variant(Variant) -> TopNavigation``</summary>

내비게이션 바의 스타일(Variant)을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 적용할 내비게이션 스타일 |
- **Return Value**

  수정된 내비게이션 바 인스턴스
- **Discussion**

  `.normal`, `.extended`, `.floating`, `.emphasized` 중 하나의 스타일을 지정할 수 있으며, 스타일에 따라 내비게이션의 외형과 정렬 방식 등이 달라집니다.
</details>

___
### Enumerations

<details>

<summary>``enum Resource``</summary>

TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.
#### Enumerations

<details>

<summary>``enum LeadingButtonInfo``</summary>

TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
##### Enumeration Cases

<details>

<summary>``case back(action: () -> Void)``</summary>

뒤로가기 버튼
- **Discussion**
</details>
<details>

<summary>``case icon(Icon, action: () -> Void)``</summary>

아이콘 버튼
- **Discussion**
</details>
<details>

<summary>``case text(String, action: () -> Void)``</summary>

텍스트 버튼
- **Discussion**
</details>

</details>
<details>

<summary>``enum TrailingButtonInfo``</summary>

TopNavigation의 우측에 표시될 내용들의 열거형입니다.
##### Operators

<details>

<summary>``static func == (TopNavigation.Resource.TrailingButtonInfo, TopNavigation.Resource.TrailingButtonInfo) -> Bool``</summary>
</details>

##### Enumeration Cases

<details>

<summary>``case icon(Icon, disable: Bool, showPushBadge: Bool, action: () -> Void)``</summary>

icon 형태의 Action입니다.
- **Discussion**
</details>
<details>

<summary>``case text(String, disable: Bool, action: () -> Void)``</summary>

text 형태의 Action입니다.
- **Discussion**
</details>

##### Instance Methods

<details>

<summary>``func hash(into: inout Hasher)``</summary>
</details>

##### Default Implementations


[Equatable Implementations](/docs/utilities/ios/equatable-implementations)

</details>

</details>
<details>

<summary>``enum Variant``</summary>

TopNavigation의 외관을 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case extended``</summary>

확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)
</details>
<details>

<summary>``case floating(alternative: Bool, background: Bool)``</summary>

플로팅 스타일의 내비게이션 바
</details>
<details>

<summary>``case normal``</summary>

기본 내비게이션 바 스타일
</details>

#### Default Implementations


[Equatable Implementations](/docs/utilities/ios/equatable-implementations)

</details>

___
### Default Implementations


[View Implementations](/docs/utilities/ios/view-implementations)

[View Implementations](/docs/utilities/ios/view-implementations)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



