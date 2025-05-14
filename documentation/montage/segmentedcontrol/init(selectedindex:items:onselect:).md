---
1title: init(selectedindex:items:onselect:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(selectedIndex:items:onSelect:) 

항목 배열을 이용해 세그먼트 컨트롤을 초기화합니다.

```swift
@MainActor
init(
    selectedIndex: Binding<Int>,
    items: [Item],
    onSelect: ((Int) -> Void)? = nil
)
```

## Parameters 

selectedIndex

현재 선택된 항목의 인덱스 바인딩

items

표시할 항목 배열

onSelect

항목 선택 시 호출될 클로저 (기본값: nil)

