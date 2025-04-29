Structure

# Menu 

드롭다운이나 컨텍스트 메뉴로 사용할 수 있는 메뉴 컴포넌트입니다.

```swift
@MainActor
struct Menu
```

## Overview 

일반, 라디오 버튼, 체크박스 형태로 메뉴 항목을 표시할 수 있으며, 메뉴 하단에 추가 액션 영역을 포함할 수 있습니다.

**사용 예시**:

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

> **See Also**
>
> Menu.Variant, Menu.Item

## Topics 

### Structures 

- [struct Item](/documentation/montage/menu/item.md)

  메뉴 항목의 데이터를 정의하는 구조체입니다.

### Initializers 

- [init(variant: Variant, items: Binding<[Item]>, onSelectCell: ((Item) -> Void)?, cellModifier: (_ index: Int, _ cell: Cell) -> Cell)](/documentation/montage/menu/init(variant:items:onselectcell:cellmodifier:).md)

  메뉴 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/menu/body.md)

### Instance Methods 

- [func menuActionArea(leadingContent: () -> any View, trailingContent: () -> any View) -> Menu](/documentation/montage/menu/menuactionarea(leadingcontent:trailingcontent:).md)

  메뉴 하단에 액션 버튼 영역을 추가합니다.

### Enumerations 

- [enum Variant](/documentation/montage/menu/variant.md)

  메뉴의 표시 형태를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

