**STRUCT**

# `Bar.TopNavigation`

```swift
public struct TopNavigation: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:title:scrollOffset:backgroundColorResolvable:leadingButton:trailingButtons:)</code></summary>

```swift
public init(
    variant: Variant = .normal,
    title: String = "",
    scrollOffset: CGFloat = .zero,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton? = nil,
    trailingButtons: [Resource.TrailingButton] = []
)
```

</details>