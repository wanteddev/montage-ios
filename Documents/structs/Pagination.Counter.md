**STRUCT**

# `Pagination.Counter`

```swift
public struct Counter: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(selectedPage:totalPages:)</code></summary>

```swift
public init(selectedPage: Binding<Int>, totalPages: Int)
```

</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

</details>

<details><summary markdown="span"><code>alternative(_:)</code></summary>

```swift
public func alternative(_ alternative: Bool = true) -> Self
```

</details>