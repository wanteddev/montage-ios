**EXTENSION**

# `View`
```swift
extension View
```

## Methods
<details><summary markdown="span"><code>recognizeViewForPreview(_:fill:)</code></summary>

```swift
public func recognizeViewForPreview(_ color: SwiftUI.Color = .blue, fill: Bool = false) -> some View
```

</details>

<details><summary markdown="span"><code>carveLogForPreview(_:font:alignment:)</code></summary>

```swift
public func carveLogForPreview(
    _ message: String,
    font: Font? = nil,
    alignment: Alignment = .center
) -> some View
```

</details>

<details><summary markdown="span"><code>printValue(_:_:)</code></summary>

```swift
public func printValue<V: Equatable>(_ value: V, _ label: String = "Unknown") -> some View
```

</details>

<details><summary markdown="span"><code>printSize(_:)</code></summary>

```swift
public func printSize(_ label: String = "Unknown") -> some View
```

</details>

<details><summary markdown="span"><code>measureForPreview(axis:)</code></summary>

```swift
public func measureForPreview(axis: Axis) -> some View
```

</details>

<details><summary markdown="span"><code>measureBoxForPreview()</code></summary>

```swift
public func measureBoxForPreview() -> some View
```

</details>

<details><summary markdown="span"><code>if(_:_:else:)</code></summary>

```swift
public func `if`(
    _ condition: Bool,
    _ transform: (Self) -> any View,
    else alternative: ((Self) -> any View)? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>if(_:)</code></summary>

```swift
public func `if`(_ condition: Bool) -> some View
```

</details>

<details><summary markdown="span"><code>modifying(_:)</code></summary>

```swift
public func modifying(_ transform: (Self) -> any View) -> some View
```

</details>

<details><summary markdown="span"><code>modifying(_:)</code></summary>

```swift
public func modifying(_ transform: (Self) -> Self) -> Self
```

</details>

<details><summary markdown="span"><code>asUIImage()</code></summary>

```swift
public func asUIImage() -> UIImage
```

</details>

<details><summary markdown="span"><code>elevation(_:)</code></summary>

```swift
public func elevation(_ elevation: Elevation) -> Self
```

</details>

<details><summary markdown="span"><code>paragraph(variant:)</code></summary>

```swift
public func paragraph(variant: Typography.Variant) -> some View
```

</details>

<details><summary markdown="span"><code>toast(_:location:duration:)</code></summary>

```swift
public func toast(
    _ model: Binding<Toast.Model?>,
    location: Toast.Location = .bottom(offset: 0),
    duration: Toast.Duration = .short
) -> some View
```

</details>

<details><summary markdown="span"><code>snackBar(_:handler:)</code></summary>

```swift
public func snackBar(_ model: Binding<SnackBar.Model?>, handler: @escaping () -> Void) -> some View
```

</details>

<details><summary markdown="span"><code>tooltip(isPresented:position:message:showArrow:showCloseButton:buttonInfo:)</code></summary>

```swift
public func tooltip(
    isPresented: Binding<Bool>,
    position: Tooltip.Position,
    message: String,
    showArrow: Bool = true,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>tooltip(isPresented:message:showCloseButton:buttonInfo:)</code></summary>

```swift
public func tooltip(
    isPresented: Binding<Bool>,
    message: String,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>topNavigation(variant:title:backgroundColorResolvable:leadingButton:trailingButtons:withBottom:)</code></summary>

```swift
public func topNavigation(
    variant: Bar.TopNavigation.Variant = .normal,
    title: String,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Bar.TopNavigation.Resource.LeadingButton? = nil,
    trailingButtons: [Bar.TopNavigation.Resource.TrailingButton] = [],
    withBottom model: ActionAreaModifier.Model? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>skeleton(isPresented:skeletonView:)</code></summary>

```swift
public func skeleton(
    isPresented: Bool,
    @ViewBuilder skeletonView: @escaping () -> any View
) -> some View
```

</details>

<details><summary markdown="span"><code>skeleton(isPresented:kind:color:opacity:size:)</code></summary>

```swift
public func skeleton(
    isPresented: Bool,
    kind: Skeleton.Kind,
    color: SwiftUI.Color? = nil,
    opacity: CGFloat? = nil,
    size: CGSize? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>loading(_:type:dimmedColor:)</code></summary>

```swift
public func loading(
    _ isLoading: Binding<Bool>,
    type: Loading.Kind,
    dimmedColor: SwiftUI.Color = .clear
) -> some View
```

</details>

<details><summary markdown="span"><code>userInteractionDisabled(_:)</code></summary>

```swift
public func userInteractionDisabled(_ disabled: Bool) -> some View
```

</details>

<details><summary markdown="span"><code>disableSwipeBack(_:)</code></summary>

```swift
public func disableSwipeBack(_ disabled: Bool) -> some View
```

</details>

<details><summary markdown="span"><code>scrollable(_:contentOffset:)</code></summary>

```swift
public func scrollable(_ axis: Axis, contentOffset: Binding<CGPoint>) -> some View
```

</details>

<details><summary markdown="span"><code>pullToRefresh(scrollYOffset:refresh:)</code></summary>

```swift
public func pullToRefresh(
    scrollYOffset: Binding<CGFloat>,
    refresh: @escaping () async -> Void
) -> some View
```

</details>

<details><summary markdown="span"><code>actionArea(model:)</code></summary>

```swift
public func actionArea(model: ActionAreaModifier.Model) -> some View
```

</details>

<details><summary markdown="span"><code>popupModal(isPresented:ignoresEdgeInsets:actionAreaModel:_:navigation:)</code></summary>

```swift
public func popupModal(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>bottomSheetModal(isPresented:needHandle:resize:actionAreaModel:_:navigation:)</code></summary>

```swift
public func bottomSheetModal(
    isPresented: Binding<Bool>,
    needHandle: Bool = true,
    resize: Modal.BottomSheet.Resize = .hug,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>fullModal(isPresented:actionAreaModel:_:navigation:)</code></summary>

```swift
public func fullModal(
    isPresented: Binding<Bool>,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

</details>

<details><summary markdown="span"><code>pushBadge(variant:size:fontColor:backgroundColor:position:inset:)</code></summary>

```swift
public func pushBadge(
    variant: PushBadge.Variant = .dot,
    size: PushBadge.Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: PushBadge.Position = .top(.trailing),
    inset: CGSize = .zero
) -> some View
```

</details>