---
title: Select
description:   컴포넌트는 사용자가 드롭다운 메뉴에서 하나 또는 여러 항목을 선택할 수 있는 UI 요소입니다.   단일 선택 또는 다중 선택 모드를 지원하며, 여러 시각적 변형과 맞춤 설정 옵션을 제공합니다.
---

```swift
@MainActor struct Select
```

## Overview

```swift
@State private var items = [
    .init(text: "Option 1"),
    .init(text: "Option 2"),
    .init(text: "Option 3")
]

Select(
    variant: .single(.checkmark, nil),
    placeholder: "선택하세요",
    items: $items
)
```

## Topics

### Structures


[``struct Item``](/documentation/montage/select/item.md)

Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.

### Initializers


``init(menuPresented: Binding<Bool>?, variant: Variant, items: Binding<[Item]>, onTapItem: ((Select.Item) -> Void)?)``

Select 컴포넌트 초기화

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `menuPresented` | 메뉴 표시 상태 바인딩 (기본값: nil) |
  | `variant` | 컴포넌트의 시각적/기능적 변형 |
  | `items` | 선택 가능한 항목 배열 (바인딩) |
  | `onTapItem` | 항목 선택 시 호출되는 클로저 (기본값: nil) |

### Instance Properties


``var body: some View``

### Instance Methods


``func description(String) -> Select``

설명을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `description` | 표시할 설명 텍스트 |
- **Return Value**

  수정된 Select 인스턴스

``func disable(Bool) -> Select``

활성화 여부를 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부 (기본값: true) |
- **Return Value**

  수정된 Select 인스턴스

``func heading(String) -> Select``

제목을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `heading` | 표시할 제목 텍스트 |
- **Return Value**

  수정된 Select 인스턴스

``func leadingContent(LeadingContent?) -> Select``

왼쪽 컨텐츠를 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `content` | 표시할 선행 콘텐츠 |
- **Return Value**

  수정된 Select 인스턴스

``func menuResize(BottomSheetModal.Resize) -> Select``

메뉴의 높이 detent를 지정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `menuResize` | 메뉴 크기 조정 방식 |
- **Return Value**

  수정된 Select 인스턴스

``func negative(Bool) -> Select``

negative 상태 여부를 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `negative` | 부정적 상태 여부 (기본값: true) |
- **Return Value**

  수정된 Select 인스턴스

``func placeholder(String) -> Select``

선택된 항목들이 없는 경우 placeholder를 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placeholder` | 표시할 플레이스홀더 텍스트 |
- **Return Value**

  수정된 Select 인스턴스

``func requiredBadge(Bool) -> Select``

필수 표시 노출 여부를 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `requiredBadge` | 필수 표시 여부 (기본값: true) |
- **Return Value**

  수정된 Select 인스턴스

``func shadowBackgroundColor(SwiftUI.Color) -> Select``

shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `shadowBackgroundColor` | 설정할 배경색 |
- **Return Value**

  수정된 Select 인스턴스

### Enumerations


[``enum LeadingContent``](/documentation/montage/select/leadingcontent.md)

왼쪽에 표시될 컨텐트 타입입니다.

[``enum Render``](/documentation/montage/select/render.md)

variant가 multiple일 때 컴포넌트에 표시될 내용의 형태를 결정하는 열거형입니다.

[``enum SingleSelectionType``](/documentation/montage/select/singleselectiontype.md)

variant가 single일 때 아이템 선택 창에 아이템이 표시되는 방식을 결정하는 열거형입니다.

[``enum Variant``](/documentation/montage/select/variant.md)

다중 선택 가능여부를 나타내는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/select/view-implementations.md)

[View Implementations](/documentation/montage/select/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



