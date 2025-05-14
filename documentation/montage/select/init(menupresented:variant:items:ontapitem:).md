---
1title: init(menupresented:variant:items:ontapitem:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(menuPresented:variant:items:onTapItem:) 

Select 컴포넌트 초기화

```swift
@MainActor
init(
    menuPresented: Binding<Bool>? = nil,
    variant: Variant,
    items: Binding<[Item]>,
    onTapItem: ((Select.Item) -> Void)? = nil
)
```

## Parameters 

menuPresented

메뉴 표시 상태 바인딩 (기본값: nil)

variant

컴포넌트의 시각적/기능적 변형

items

선택 가능한 항목 배열 (바인딩)

onTapItem

항목 선택 시 호출되는 클로저 (기본값: nil)

