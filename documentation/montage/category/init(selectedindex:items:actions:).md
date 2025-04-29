Initializer

# init(selectedIndex:items:actions:) 

카테고리 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    selectedIndex: Binding<Int>,
    items: [String],
    actions: @escaping (Int) -> Void = { _ in }
)
```

## Parameters 

selectedIndex

현재 선택된 항목의 인덱스 바인딩

items

표시할 카테고리 항목 배열

actions

항목 선택 시 호출될 클로저 (기본값: 빈 클로저)

