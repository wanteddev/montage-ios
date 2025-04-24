**STRUCT**

# `ScrollView.ScrollStatus`

```swift
public struct ScrollStatus: Equatable
```

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

</details>
