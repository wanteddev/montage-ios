Initializer

# init(_:variant:size:onTap:) 

아바타를 초기화합니다.

```swift
@MainActor
init(
    _ imageUrl: String,
    variant: Variant,
    size: Size = .small,
    onTap: (() -> Void)? = nil
)
```

## Parameters 

imageUrl

표시할 이미지의 URL 문자열

variant

아바타 유형 (.person, .company, .academy)

size

아바타 크기 (기본값: .small)

onTap

탭 시 실행할 액션 (기본값: nil)

