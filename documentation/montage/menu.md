---
title: Menu
description: 드롭다운이나 컨텍스트 메뉴로 사용할 수 있는 메뉴 컴포넌트입니다.
---

```swift
@MainActor struct Menu
```

## Overview

일반, 라디오 버튼, 체크박스 형태로 메뉴 항목을 표시할 수 있으며, 메뉴 하단에 추가 액션 영역을 포함할 수 있습니다.

```swift
// 기본 메뉴
@State private var items: [Menu.Item] = [
    .init(title: "항목 1"),
    .init(title: "항목 2"),
    .init(title: "항목 3")
]

Menu(
    variant: .normal,
    items: $items,
    onSelectCell: { item in
        print("선택된 항목: \(item.title)")
    }
)

// 라디오 메뉴 (단일 선택)
@State private var radioItems: [Menu.Item] = [
    .init(title: "옵션 1", isSelected: true),
    .init(title: "옵션 2"),
    .init(title: "옵션 3")
]

Menu(
    variant: .radio,
    items: $radioItems
)
```

>  See Also
>
> `Menu.Variant`, `Menu.Item`

## Topics

### Structures


[``struct Item``](/documentation/montage/menu/item.md)

메뉴 항목의 데이터를 정의하는 구조체입니다.

### Initializers


``init(variant: Variant, items: Binding<[Item]>, onSelectCell: ((Item) -> Void)?, cellModifier: (_ index: Int, _ cell: Cell) -> Cell)``

메뉴 컴포넌트를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 메뉴의 표시 형태 (normal, radio, checkbox) |
  | `items` | 메뉴 항목 배열에 대한 바인딩 |
  | `onSelectCell` | 항목 선택 시 호출될 클로저 (선택 사항) |
  | `cellModifier` | 각 셀을 커스터마이징하기 위한 클로저 (기본값: 수정 없음) |

### Instance Properties


``var body: some View``

### Instance Methods


``func menuActionArea(leadingContent: () -> any View, trailingContent: () -> any View) -> Menu``

메뉴 하단에 액션 버튼 영역을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `leadingContent` | 왼쪽에 표시할 콘텐츠를 반환하는 클로저 |
  | `trailingContent` | 오른쪽에 표시할 콘텐츠를 반환하는 클로저 |
- **Return Value**

  액션 영역이 추가된 Menu
- **Discussion**

  왼쪽과 오른쪽에 버튼이나 다른 뷰를 배치할 수 있습니다.

### Enumerations


[``enum Variant``](/documentation/montage/menu/variant.md)

메뉴의 표시 형태를 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/menu/view-implementations.md)

[View Implementations](/documentation/montage/menu/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



