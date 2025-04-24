**STRUCT**

# `Menu`

```swift
public struct Menu: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:items:onSelectCell:cellModifier:)</code></summary>

```swift
public init(
    variant: Variant,
    items: Binding<[Item]>,
    onSelectCell: ((Item) -> Void)? = nil,
    cellModifier: @escaping (_ index: Int, _ cell: Cell) -> Cell = { _, cell in cell }
)
```

</details>

<details><summary markdown="span"><code>menuActionArea(leadingContent:trailingContent:)</code></summary>

```swift
public func menuActionArea(
    leadingContent: @escaping () -> any View,
    trailingContent: @escaping () -> any View
) -> Self
```

</details>
