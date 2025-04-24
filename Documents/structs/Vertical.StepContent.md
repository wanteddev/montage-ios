**STRUCT**

# `Vertical.StepContent`

```swift
public struct StepContent: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(label:labelAccessoryView:contentView:)</code></summary>

```swift
public init(
    label: String = "",
    labelAccessoryView: (() -> any View)? = nil,
    contentView: (() -> any View)? = nil
)
```

</details>