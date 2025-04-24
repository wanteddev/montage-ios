**STRUCT**

# `Card.Normal`

```swift
public struct Normal: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(thumbnail:skeleton:title:)</code></summary>

```swift
public init(
    thumbnail: @escaping () -> Thumbnail,
    skeleton: Binding<Bool>,
    title: @escaping () -> any View
)
```

</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>extraCaption(_:)</code></summary>

```swift
public func extraCaption(_ extraCaption: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>overlay(caption:buttonIcon:onTapButton:)</code></summary>

```swift
public func overlay(
    caption: String? = nil,
    buttonIcon: Montage.Icon? = nil,
    onTapButton: (() -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>topContent(_:)</code></summary>

```swift
public func topContent(_ content: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>bottomContent(_:)</code></summary>

```swift
public func bottomContent(_ content: (() -> any View)? = nil) -> Self
```

</details>