Type Method

# checkbox(state:text:onSelect:) 

상태 값을 이용해 체크박스와 텍스트를 생성합니다.

```swift
@MainActor
static func checkbox(
    state: Control.State,
    text: String,
    onSelect: ((Control.State) -> Void)? = nil
) -> Input
```

## Parameters 

state

체크박스의 초기 상태

text

표시할 텍스트

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 입력 컴포넌트

