Type Method

# checkbox(state:size:onSelect:) 

상태 값을 이용해 체크박스를 생성합니다.

```swift
@MainActor
static func checkbox(
    state: State,
    size: Size = .medium,
    onSelect: ((State) -> Void)? = nil
) -> Control
```

## Parameters 

state

체크박스의 초기 상태

size

체크박스 크기 (기본값: .medium)

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 체크박스 컨트롤

