Type Method

# checkbox(_:text:) 

상태 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

```swift
@MainActor
static func checkbox(
    _ state: Binding<Control.State>,
    text: String
) -> Input
```

## Parameters 

state

체크박스 상태와 연결된 바인딩

text

표시할 텍스트

## Return Value 

구성된 입력 컴포넌트

