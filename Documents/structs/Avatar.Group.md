**STRUCT**

# `Avatar.Group`

```swift
public struct Group: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:variant:size:onTap:)</code></summary>

```swift
public init(
    _ imageUrls: [String],
    variant: Avatar.Variant,
    size: Size,
    onTap: ((_ index: Int) -> Void)? = nil
)
```

</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ trailingContent: @escaping () -> any View) -> Self
```

</details>