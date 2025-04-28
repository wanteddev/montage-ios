**STRUCT**

# `PullToRefreshModifier`

```swift
public struct PullToRefreshModifier: ViewModifier
```

스크롤 뷰에 풀-투-리프레시(Pull-to-Refresh) 기능을 추가하는 뷰 모디파이어

사용자가 스크롤 뷰를 아래로 당기면 애니메이션과 함께 리프레시 기능을 제공합니다.
iOS 18 이상에서 사용 가능하며, 로딩 애니메이션과 함께 당김 정도에 따른 시각적 피드백을 제공합니다.

**사용 예시**:
```swift
ScrollView {
    content
}
.modifier(PullToRefreshModifier(
    scrollYOffset: $scrollYOffset,
    refresh: {
        // 리프레시 작업을 수행합니다
        await loadData()
    }
))
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| scrollYOffset | 스크롤 뷰의 Y축 오프셋 바인딩. 당김 정도를 감지하는 데 사용됩니다. |
| refresh | 리프레시가 트리거될 때 실행될 비동기 클로저입니다. |


- Note: 이 모디파이어는 스크롤 뷰의 오프셋을 감지하고, 특정 임계값 이상으로 당겨질 때 리프레시 동작을 트리거합니다.
- Important: 사용하기 위해서는 스크롤 뷰의 Y축 오프셋을 추적해야 합니다.

## Methods
<details><summary markdown="span"><code>init(scrollYOffset:refresh:)</code></summary>

```swift
public init(scrollYOffset: Binding<CGFloat>, refresh: @escaping () async -> Void)
```

</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
