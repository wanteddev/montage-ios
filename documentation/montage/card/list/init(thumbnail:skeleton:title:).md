Initializer

# init(thumbnail:skeleton:title:) 

List 카드를 초기화합니다.

```swift
@MainActor
init(
    thumbnail: @escaping () -> Thumbnail,
    skeleton: Binding<Bool>,
    title: String
)
```

## Parameters 

thumbnail

카드에 표시할 썸네일 이미지

skeleton

스켈레톤 로딩 상태 바인딩

title

카드 제목으로 표시할 뷰

