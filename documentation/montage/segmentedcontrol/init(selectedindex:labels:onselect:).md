---
1title: init(selectedindex:labels:onselect:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(selectedIndex:labels:onSelect:) 

텍스트 배열을 이용해 세그먼트 컨트롤을 초기화합니다.

```swift
@MainActor
init(
    selectedIndex: Binding<Int>,
    labels: [String],
    onSelect: ((Int) -> Void)? = nil
)
```

## Parameters 

selectedIndex

현재 선택된 항목의 인덱스 바인딩

labels

표시할 텍스트 배열

onSelect

항목 선택 시 호출될 클로저 (기본값: nil)

