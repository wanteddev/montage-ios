Type Method

# checkbox(checked:size:onSelect:) 

불리언 값을 이용해 체크박스를 생성합니다.

```swift
@MainActor
static func checkbox(
    checked: Bool,
    size: Size = .medium,
    onSelect: ((Bool) -> Void)? = nil
) -> Control
```

## Parameters 

checked

체크박스의 초기 선택 상태

size

체크박스 크기 (기본값: .medium)

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 체크박스 컨트롤

