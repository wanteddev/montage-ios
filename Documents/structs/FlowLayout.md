**STRUCT**

# `FlowLayout`

```swift
public struct FlowLayout: Layout
```

## Methods
<details><summary markdown="span"><code>init(spacing:lineSpacing:)</code></summary>

```swift
public init(spacing: CGFloat? = nil, lineSpacing: CGFloat = 10.0)
```

</details>

<details><summary markdown="span"><code>makeCache(subviews:)</code></summary>

```swift
public func makeCache(subviews: Subviews) -> Cache
```



</details>

<details><summary markdown="span"><code>sizeThatFits(proposal:subviews:cache:)</code></summary>

```swift
public func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
) -> CGSize
```



</details>

<details><summary markdown="span"><code>placeSubviews(in:proposal:subviews:cache:)</code></summary>

```swift
public func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
)
```



</details>
