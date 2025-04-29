Instance Method

# tight(_:) 

컨트롤을 더 조밀한 레이아웃으로 표시합니다.

```swift
@MainActor
func tight(_ tight: Bool = true) -> Control
```

## Parameters 

tight

조밀한 레이아웃 적용 여부 (기본값: true)

## Return Value 

수정된 컨트롤 인스턴스

## Discussion 

이 수정자를 적용하면 컨트롤의 가로 너비가 줄어듭니다.

- medium: 24px → 20px
- small: 20px → 16px

