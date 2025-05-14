---
1title: init(variant:items:onselectcell:cellmodifier:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(variant:items:onSelectCell:cellModifier:) 

메뉴 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    variant: Variant,
    items: Binding<[Item]>,
    onSelectCell: ((Item) -> Void)? = nil,
    cellModifier: @escaping (_ index: Int,
    _ cell: Cell) -> Cell = { _, cell in cell }
)
```

## Parameters 

variant

메뉴의 표시 형태 (normal, radio, checkbox)

items

메뉴 항목 배열에 대한 바인딩

onSelectCell

항목 선택 시 호출될 클로저 (선택 사항)

cellModifier

각 셀을 커스터마이징하기 위한 클로저 (기본값: 수정 없음)

