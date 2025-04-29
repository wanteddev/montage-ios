Initializer

# init(scrollStatus:onOffsetChanged:content:) 

스크롤 뷰를 초기화합니다.

```swift
@MainActor
init(
    scrollStatus: Binding<ScrollStatus>? = nil,
    onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: @escaping () -> any View
)
```

## Parameters 

scrollStatus

스크롤 상태를 추적하기 위한 바인딩 (선택 사항)

onOffsetChanged

스크롤 오프셋이 변경될 때 호출되는 클로저 (기본값: 빈 클로저)

content

스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저

