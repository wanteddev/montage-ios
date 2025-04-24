**STRUCT**

# `ActionArea`

```swift
public struct ActionArea: View, KeyboardReadable
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:)</code></summary>

```swift
public init(variant: Variant)
```

</details>

<details><summary markdown="span"><code>clearBackground(_:)</code></summary>

```swift
public func clearBackground(_ clearBackground: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: String?) -> Self
```

</details>

<details><summary markdown="span"><code>extra(_:divider:)</code></summary>

```swift
public func extra(_ content: (() -> any View)?, divider: Bool = true) -> Self
```

</details>
