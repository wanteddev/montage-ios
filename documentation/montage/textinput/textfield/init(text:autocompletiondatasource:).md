Initializer

# init(text:autoCompletionDataSource:) 

텍스트 필드를 초기화합니다.

```swift
@MainActor
init(
    text: Binding<String>,
    autoCompletionDataSource: Binding<AutoCompletionDataSource?> = .constant(
                nil
            )
)
```

## Parameters 

text

텍스트 필드의 값을 바인딩

autoCompletionDataSource

자동완성 데이터 소스를 바인딩, 기본값은 nil

## Return Value 

구성된 텍스트 필드 인스턴스

