Type Method

# checkmark(_:size:) 

불리언 바인딩을 이용해 체크마크를 생성합니다.

```swift
@MainActor
static func checkmark(
    _ checked: Binding<Bool>,
    size: Size = .medium
) -> Control
```

## Parameters 

checked

체크마크 선택 상태와 연결된 바인딩

size

체크마크 크기 (기본값: .medium)

## Return Value 

구성된 체크마크 컨트롤

