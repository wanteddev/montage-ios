---
1title: pulltorefresh(scrollyoffset:refresh:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# pullToRefresh(scrollYOffset:refresh:) 

스크롤 뷰에 풀-투-리프레시(Pull-to-Refresh) 기능을 추가합니다.MontageSwiftUICoreiOS 18.0+iPadOS 18.0+Mac Catalyst 18.0+

```swift
@MainActor
func pullToRefresh(
    scrollYOffset: Binding<CGFloat>,
    refresh: @escaping () async -> Void
) -> some View
```

## Parameters 

scrollYOffset

스크롤 뷰의 Y축 오프셋 바인딩. 당김 정도를 감지하는 데 사용됩니다.

refresh

리프레시가 트리거될 때 실행될 비동기 클로저입니다.

## Return Value 

풀-투-리프레시 기능이, 추가된 뷰

## Discussion 

사용자가 스크롤 뷰를 아래로 당기면 애니메이션과 함께 리프레시 기능을 제공합니다. iOS 18 이상에서 사용 가능하며, 로딩 애니메이션과 함께 당김 정도에 따른 시각적 피드백을 제공합니다.

**사용 예시**:

```swift
@State private var scrollYOffset: CGFloat = 0

ScrollView {
    content
}
.scrollable(.vertical, contentOffset: $contentOffset)
.onChange(of: contentOffset) { newValue in
    scrollYOffset = newValue.y
}
.pullToRefresh(scrollYOffset: $scrollYOffset) {
    await loadData()
}
```

