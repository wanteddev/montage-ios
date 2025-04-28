**STRUCT**

# `ScrollView.ScrollStatus`

```swift
public struct ScrollStatus: Equatable
```

스크롤 뷰의 상태를 추적하는 구조체입니다.

스크롤 방향, 스크롤 뷰 크기, 콘텐츠 크기, 오프셋 등의 정보를 포함합니다.

## Properties
<details><summary markdown="span"><code>axis</code></summary>

```swift
public var axis: Axis
```

</details>

<details><summary markdown="span"><code>scrollViewSize</code></summary>

```swift
public var scrollViewSize: CGSize
```

</details>

<details><summary markdown="span"><code>contentSize</code></summary>

```swift
public var contentSize: CGSize
```

</details>

<details><summary markdown="span"><code>contentOffset</code></summary>

```swift
public var contentOffset: CGPoint
```

</details>

<details><summary markdown="span"><code>scrolledToMax</code></summary>

```swift
public var scrolledToMax: Bool
```

스크롤이 최대 위치에 도달했는지 여부입니다.

</details>

## Methods
<details><summary markdown="span"><code>init(axis:scrollViewSize:contentSize:contentOffset:)</code></summary>

```swift
public init(
    axis: Axis = .vertical,
    scrollViewSize: CGSize = .zero,
    contentSize: CGSize = .zero,
    contentOffset: CGPoint = .zero
)
```

스크롤 상태를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| axis | 스크롤 방향 (기본값: .vertical) |
| scrollViewSize | 스크롤 뷰 크기 (기본값: .zero) |
| contentSize | 콘텐츠 크기 (기본값: .zero) |
| contentOffset | 콘텐츠 오프셋 (기본값: .zero) |




</details>
