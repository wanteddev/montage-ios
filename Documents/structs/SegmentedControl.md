**STRUCT**

# `SegmentedControl`

```swift
public struct SegmentedControl: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(selectedIndex:items:onSelect:)</code></summary>

```swift
public init(selectedIndex: Binding<Int>, items: [Item], onSelect: ((Int) -> Void)? = nil)
```

</details>

<details><summary markdown="span"><code>init(selectedIndex:labels:onSelect:)</code></summary>

```swift
public init(selectedIndex: Binding<Int>, labels: [String], onSelect: ((Int) -> Void)? = nil)
```

</details>

<details><summary markdown="span"><code>variant(_:)</code></summary>

```swift
public func variant(_ variant: Variant) -> Self
```

</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

</details>
