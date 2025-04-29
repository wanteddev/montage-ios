Initializer

# init(_:variant:size:onTap:) 

그룹 아바타를 초기화합니다.

```swift
@MainActor
init(
    _ imageUrls: [String],
    variant: Avatar.Variant,
    size: Size,
    onTap: ((_ index: Int) -> Void)? = nil
)
```

## Parameters 

imageUrls

표시할 이미지의 URL 문자열 배열 (최대 5개)

variant

아바타 유형 (.person, .company, .academy)

size

그룹 아바타 크기

onTap

각 아바타 탭 시 실행할 액션 (인덱스가 전달됨) (기본값: nil)

