**STRUCT**

# `Card.List`

```swift
public struct List: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(thumbnail:skeleton:title:)</code></summary>

```swift
public init(
    thumbnail: @escaping () -> Thumbnail,
    skeleton: Binding<Bool>,
    title: @escaping () -> any View
)
```

</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>extraCaption(_:)</code></summary>

```swift
public func extraCaption(_ extraCaption: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>topContent(_:)</code></summary>

```swift
public func topContent(_ content: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>bottomContent(_:)</code></summary>

```swift
public func bottomContent(_ content: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>leadingContent(_:)</code></summary>

```swift
public func leadingContent(_ content: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ content: (() -> any View)? = nil) -> Self
```

</details>