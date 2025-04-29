Initializer

# init(title:description:content:) 

아코디언을 생성합니다.

```swift
@MainActor
init(
    title: String,
    description: String? = nil,
    content: (() -> any View)? = nil
)
```

## Parameters 

title

아코디언의 제목

description

확장 시 표시될 설명 텍스트 (선택 사항)

content

확장 시 표시될 커스텀 컨텐츠 뷰 (선택 사항)

