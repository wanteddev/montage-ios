Instance Method

# scrollable(_:contentOffset:) 

뷰에 자동 스크롤 기능을 적용하는 modifier입니다.MontageSwiftUICore

```swift
@MainActor
func scrollable(
    _ axis: Axis,
    contentOffset: Binding<CGPoint>
) -> some View
```

## Parameters 

axis

스크롤 방향 (.horizontal 또는 .vertical)

contentOffset

콘텐츠 오프셋을 바인딩하는 CGPoint 값

## Return Value 

자동 스크롤 기능이 적용된 뷰

## Discussion 

콘텐츠 오프셋을 추적하고 스크롤이 필요한 경우에만 스크롤을 활성화합니다. 콘텐츠가 스크롤 뷰보다 작은 경우 스크롤이 비활성화됩니다.

