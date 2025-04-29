Initializer

# init(text:focus:) 

텍스트 영역을 초기화합니다.

```swift
@MainActor
init(
    text: Binding<String>,
    focus: FocusState<Bool>.Binding? = nil
)
```

## Parameters 

text

텍스트 영역의 값을 바인딩

focus

텍스트 영역의 포커스 상태를 바인딩 (선택 사항)

## Return Value 

구성된 텍스트 영역 인스턴스

