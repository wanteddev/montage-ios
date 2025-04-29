Initializer

# init(kind:size:) 

Loading 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    kind: Kind,
    size: CGSize? = nil
)
```

## Parameters 

kind

로딩 애니메이션의 종류 (.wanted 또는 .circular)

size

로딩 애니메이션의 크기 (nil일 경우 기본 크기 사용)

