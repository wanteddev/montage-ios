Type Method

# checkbox(checked:text:onSelect:) 

불리언 값을 이용해 체크박스와 텍스트를 생성합니다.

```swift
@MainActor
static func checkbox(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Input
```

## Parameters 

checked

체크박스의 초기 선택 상태

text

표시할 텍스트

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 입력 컴포넌트

