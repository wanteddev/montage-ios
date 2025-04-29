Initializer

# init(text:action:) 

기본 버튼 정보를 초기화합니다.

```swift
init(
    text: String,
    action: @escaping (() -> Void)
)
```

## Parameters 

text

버튼에 표시할 텍스트

action

버튼 클릭 시 실행할 액션

## Return Value 

구성된 ButtonInfo 인스턴스

