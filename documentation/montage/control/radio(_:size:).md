Type Method

# radio(_:size:) 

불리언 바인딩을 이용해 라디오 버튼을 생성합니다.

```swift
@MainActor
static func radio(
    _ checked: Binding<Bool>,
    size: Size = .medium
) -> Control
```

## Parameters 

checked

라디오 버튼 선택 상태와 연결된 바인딩

size

라디오 버튼 크기 (기본값: .medium)

## Return Value 

구성된 라디오 버튼 컨트롤

