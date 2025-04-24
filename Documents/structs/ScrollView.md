**STRUCT**

# `ScrollView`

```swift
public struct ScrollView: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(scrollStatus:onOffsetChanged:content:)</code></summary>

```swift
public init(
    scrollStatus: Binding<ScrollStatus>? = nil,
    onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: @escaping () -> any View
)
```

</details>

<details><summary markdown="span"><code>axis(_:)</code></summary>

```swift
public func axis(_ axis: Axis) -> Self
```

</details>

<details><summary markdown="span"><code>hidesIndicators(_:)</code></summary>

```swift
public func hidesIndicators(_ hidesIndicators: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>onRefresh(_:)</code></summary>

```swift
public func onRefresh(_ perform: @escaping () async -> Void) -> Self
```

</details>