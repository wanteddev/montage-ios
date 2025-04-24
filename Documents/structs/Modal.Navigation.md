**STRUCT**

# `Modal.Navigation`

```swift
public struct Navigation: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:scrollOffset:)</code></summary>

```swift
public init(title: String, scrollOffset: Binding<CGFloat> = .constant(0))
```

</details>

<details><summary markdown="span"><code>variant(_:)</code></summary>

```swift
public func variant(_ variant: Variant) -> Self
```

</details>

<details><summary markdown="span"><code>scrollOffset(_:)</code></summary>

```swift
public func scrollOffset(_ scrollOffset: Binding<CGFloat>) -> Self
```

</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ backgroundColor: SwiftUI.Color) -> Self
```

</details>

<details><summary markdown="span"><code>needHandleArea(_:)</code></summary>

```swift
public func needHandleArea(_ needHandleArea: Bool) -> Self
```

</details>

<details><summary markdown="span"><code>leadingButton(_:)</code></summary>

```swift
public func leadingButton(_ leadingButton: Bar.TopNavigation.Resource.LeadingButton?) -> Self
```

</details>

<details><summary markdown="span"><code>trailingButtons(_:)</code></summary>

```swift
public func trailingButtons(_ actions: [Bar.TopNavigation.Resource.TrailingButton]) -> Self
```

</details>