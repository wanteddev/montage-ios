**STRUCT**

# `Bar.TopNavigation.TopNavigationModifier`

```swift
public struct TopNavigationModifier: ViewModifier
```

## Methods
<details><summary markdown="span"><code>init(variant:title:showIndicator:backgroundColorResolvable:leadingButton:trailingButtons:actionAreaModel:)</code></summary>

```swift
public init(
    variant: Variant,
    title: String,
    showIndicator: Bool = true,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton?,
    trailingButtons: [Resource.TrailingButton],
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
