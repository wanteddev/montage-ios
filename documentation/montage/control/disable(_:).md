Instance Method

# disable(_:) 

컨트롤을 비활성화합니다.

```swift
@MainActor
func disable(_ disable: Bool = true) -> Control
```

## Parameters 

disable

비활성화 여부 (기본값: true)

## Return Value 

수정된 컨트롤 인스턴스

## Discussion 

비활성화된 컨트롤은 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

