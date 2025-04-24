**STRUCT**

# `Slider`

```swift
public struct Slider: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(range:labelFormat:onChanged:)</code></summary>

```swift
public init(
    range: ClosedRange<CGFloat> = 0 ... 1,
    labelFormat: ((CGFloat) -> String)? = nil,
    onChanged: ((CGFloat, CGFloat) -> Void)? = nil
)
```

</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>label(_:)</code></summary>

```swift
public func label(_ label: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

</details>