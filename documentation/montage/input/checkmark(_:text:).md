Type Method

# checkmark(_:text:) 

불리언 바인딩을 이용해 체크마크와 텍스트를 생성합니다.

```swift
@MainActor
static func checkmark(
    _ checked: Binding<Bool>,
    text: String
) -> Input
```

## Parameters 

checked

체크마크 선택 상태와 연결된 바인딩

text

표시할 텍스트

## Return Value 

구성된 입력 컴포넌트

