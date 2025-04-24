**STRUCT**

# `Modal.BottomSheetModifier`

```swift
public struct BottomSheetModifier: ViewModifier
```

## Methods
<details><summary markdown="span"><code>init(isPresented:_:needHandle:resize:ignoresEdgeInsets:navigation:actionAreaModel:)</code></summary>

```swift
public init(
    isPresented: Binding<Bool>,
    _ content: @escaping () -> any View,
    needHandle: Bool = true,
    resize: BottomSheet.Resize = .hug,
    ignoresEdgeInsets: Bool = false,
    navigation: ( () -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
