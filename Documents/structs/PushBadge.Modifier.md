**STRUCT**

# `PushBadge.Modifier`

```swift
public struct Modifier: ViewModifier
```

## Methods
<details><summary markdown="span"><code>init(variant:size:fontColor:backgroundColor:position:inset:)</code></summary>

```swift
public init(
    variant: Variant = .dot,
    size: Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: Position = .top(.trailing),
    inset: CGSize = .zero
)
```

</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
