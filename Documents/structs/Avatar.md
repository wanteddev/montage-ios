**STRUCT**

# `Avatar`

```swift
public struct Avatar: View
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
public init(_ imageUrl: String, variant: Variant, size: Size = .small, onTap: (() -> Void)? = nil)
```

</details>

<details><summary markdown="span"><code>pushBadge(_:)</code></summary>

```swift
public func pushBadge(_ pushBadge: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>border(color:width:)</code></summary>

```swift
public func border(color: SwiftUI.Color = .semantic(.lineAlternative), width: CGFloat = 1) -> Self
```

</details>