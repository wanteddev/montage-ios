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

#### Parameters

| Name | Description |
| ---- | ----------- |
| subviews | A collection of proxy instances that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you calculate values to store in the cache. |

</details>

<details><summary markdown="span"><code>sizeThatFits(proposal:subviews:cache:)</code></summary>

```swift
public func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
) -> CGSize
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| proposal | A size proposal for the container. The container’s parent view that calls this method might call the method more than once with different proposals to learn more about the container’s flexibility before deciding which proposal to use for placement. |
| subviews | A collection of proxies that represent the views that the container arranges. You can use the proxies in the collection to get information about the subviews as you determine how much space the container needs to display them. |
| cache | Optional storage for calculated data that you can share among the methods of your custom layout container. See `makeCache(subviews:)` for details. |

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

#### Parameters

| Name | Description |
| ---- | ----------- |
| bounds | The region that the container view’s parent allocates to the container view, specified in the parent’s coordinate space. Place all the container’s subviews within the region. The size of this region matches a size that your container previously returned from a call to the `sizeThatFits(proposal:subviews:cache:)` method. |
| proposal | The size proposal from which the container generated the size that the parent used to create the `bounds` parameter. The parent might propose more than one size before calling the placement method, but it always uses one of the proposals and the corresponding returned size when placing the container. |
| subviews | A collection of proxies that represent the views that the container arranges. Use the proxies in the collection to get information about the subviews and to tell the subviews where to appear. |
| cache | Optional storage for calculated data that you can share among the methods of your custom layout container. See `makeCache(subviews:)` for details. |

</details>