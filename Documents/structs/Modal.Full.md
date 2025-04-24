**STRUCT**

# `Modal.Full`

```swift
public struct Full: View
```

Modal/Full Component 입니다.

.fullScreenCover(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
```
.fullScreenCover(
  isPresented: Binding<Bool>,
  content: {
      Modal.Full {...}
})
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:)</code></summary>

```swift
public init(_ content: @escaping () -> any View)
```

</details>

<details><summary markdown="span"><code>ignoresEdgeInsets(_:)</code></summary>

```swift
public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>modalNavigation(_:)</code></summary>

```swift
public func modalNavigation(_ navigation: (() -> Montage.Modal.Navigation)?) -> Self
```

</details>

<details><summary markdown="span"><code>modalActionArea(_:)</code></summary>

```swift
public func modalActionArea(_ actionAreaModel: ActionAreaModifier.Model?) -> Self
```

</details>