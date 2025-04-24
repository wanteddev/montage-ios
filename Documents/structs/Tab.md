**STRUCT**

# `Tab`

```swift
public struct Tab: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(selectedIndex:items:actions:)</code></summary>

```swift
public init(
    selectedIndex: Binding<Int>,
    items: [String],
    actions: @escaping (Int) -> Void = { _ in }
)
```

</details>

<details><summary markdown="span"><code>resize(_:)</code></summary>

```swift
public func resize(_ resize: Resize) -> Self
```

</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

</details>

<details><summary markdown="span"><code>horizontalPadding(_:)</code></summary>

```swift
public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>iconButton(_:action:)</code></summary>

```swift
public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self
```

</details>