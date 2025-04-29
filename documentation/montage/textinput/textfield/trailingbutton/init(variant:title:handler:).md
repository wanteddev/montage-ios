Initializer

# init(variant:title:handler:) 

트레일링 버튼을 초기화합니다.

```swift
init(
    variant: Button.Outlined.Variant,
    title: String,
    handler: (() -> Void)? = nil
)
```

## Parameters 

variant

버튼의 변형 스타일

title

버튼에 표시할 텍스트

handler

버튼 클릭 시 실행할 핸들러

## Return Value 

구성된 트레일링 버튼 인스턴스

