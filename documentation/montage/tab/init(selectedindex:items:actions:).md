Initializer

# init(selectedIndex:items:actions:) 

탭 컴포넌트를 초기화합니다.

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

현재 선택된 탭의 인덱스를 바인딩하는 변수

items

탭 항목 텍스트 배열

actions

탭 선택 시 호출되는 클로저, 선택된 인덱스를 파라미터로 받음 (기본값: 빈 클로저)

