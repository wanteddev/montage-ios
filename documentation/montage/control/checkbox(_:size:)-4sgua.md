Type Method

# checkbox(_:size:) 

상태 바인딩을 이용해 체크박스를 생성합니다.

```swift
@MainActor
static func checkbox(
    _ state: Binding<State>,
    size: Size = .medium
) -> Control
```

## Parameters 

state

체크박스 상태와 연결된 바인딩

size

체크박스 크기 (기본값: .medium)

## Return Value 

구성된 체크박스 컨트롤

