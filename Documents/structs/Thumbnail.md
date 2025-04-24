**STRUCT**

# `Thumbnail`

```swift
public struct Thumbnail: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(url:content:placeholder:)</code></summary>

```swift
public init(
    url: URL?,
    content: ((Image) -> any View)? = nil,
    placeholder: (() -> any View)? = nil
)
```

</details>

<details><summary markdown="span"><code>ratio(_:width:)</code></summary>

```swift
public func ratio(_ ratio: Ratio, width: CGFloat) -> Self
```

</details>

<details><summary markdown="span"><code>ratio(_:height:)</code></summary>

```swift
public func ratio(_ ratio: Ratio, height: CGFloat) -> Self
```

</details>

<details><summary markdown="span"><code>radius(_:)</code></summary>

```swift
public func radius(_ radius: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>border(_:)</code></summary>

```swift
public func border(_ border: Bool = true) -> Self
```

</details>