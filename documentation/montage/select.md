---
1title: select
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Select 

Select 컴포넌트는 사용자가 드롭다운 메뉴에서 하나 또는 여러 항목을 선택할 수 있는 UI 요소입니다. 단일 선택 또는 다중 선택 모드를 지원하며, 여러 시각적 변형과 맞춤 설정 옵션을 제공합니다.

```swift
@MainActor
struct Select
```

## 사용 예시: 

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

- [struct Item](/documentation/montage/select/item.md)

  아이템 타입입니다. Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.

### Initializers 

- [init(menuPresented: Binding<Bool>?, variant: Variant, items: Binding<[Item]>, onTapItem: ((Select.Item) -> Void)?)](/documentation/montage/select/init(menupresented:variant:items:ontapitem:).md)

  Select 컴포넌트 초기화

### Instance Properties 

- [var body: some View](/documentation/montage/select/body.md)

### Instance Methods 

- [func description(String) -> Select](/documentation/montage/select/description(_:).md)

  설명을 추가합니다.

- [func disable(Bool) -> Select](/documentation/montage/select/disable(_:).md)

  활성화 여부를 조정합니다.

- [func heading(String) -> Select](/documentation/montage/select/heading(_:).md)

  제목을 추가합니다.

- [func leadingContent(LeadingContent?) -> Select](/documentation/montage/select/leadingcontent(_:).md)

  왼쪽 컨텐츠를 추가합니다.

- [func menuResize(Modal.BottomSheet.Resize) -> Select](/documentation/montage/select/menuresize(_:).md)

  메뉴의 높이 detent를 지정합니다.

- [func negative(Bool) -> Select](/documentation/montage/select/negative(_:).md)

  negative 상태 여부를 조정합니다.

- [func placeholder(String) -> Select](/documentation/montage/select/placeholder(_:).md)

  선택된 항목들이 없는 경우 placeholder를 표시합니다.

- [func requiredBadge(Bool) -> Select](/documentation/montage/select/requiredbadge(_:).md)

  필수 표시 노출 여부를 조정합니다.

- [func shadowBackgroundColor(SwiftUI.Color) -> Select](/documentation/montage/select/shadowbackgroundcolor(_:).md)

  shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.

### Enumerations 

- [enum LeadingContent](/documentation/montage/select/leadingcontent.md)

  왼쪽에 표시될 컨텐트 타입입니다.

- [enum Render](/documentation/montage/select/render.md)

  variant가 multiple일 때 컴포넌트에 표시될 내용의 형태를 결정하는 열거형입니다.

- [enum SingleSelectionType](/documentation/montage/select/singleselectiontype.md)

  variant가 single일 때 아이템 선택 창에 아이템이 표시되는 방식을 결정하는 열거형입니다.

- [enum Variant](/documentation/montage/select/variant.md)

  다중 선택 가능여부를 나타내는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

