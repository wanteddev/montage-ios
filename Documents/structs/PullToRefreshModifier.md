**STRUCT**

# `PullToRefreshModifier`

```swift
public struct PullToRefreshModifier: ViewModifier
```

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