**STRUCT**

# `Modal.FullModifier`

```swift
public struct FullModifier: ViewModifier
```

## Methods
<details><summary markdown="span"><code>init(isPresented:ignoresEdgeInsets:_:navigation:actionAreaModel:)</code></summary>

```swift
public init(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
