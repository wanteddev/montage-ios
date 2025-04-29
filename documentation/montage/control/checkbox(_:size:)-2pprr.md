Type Method

# checkbox(_:size:) 

불리언 바인딩을 이용해 체크박스를 생성합니다.

```swift
@MainActor
static func checkbox(
    _ checked: Binding<Bool>,
    size: Size = .medium
) -> Control
```

## Parameters 

checked

체크박스 선택 상태와 연결된 바인딩

size

체크박스 크기 (기본값: .medium)

## Return Value 

구성된 체크박스 컨트롤

