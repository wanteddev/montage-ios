**EXTENSION**

# `NSAttributedString`
```swift
public extension NSAttributedString
```

## Methods
<details><summary markdown="span"><code>montage(_:variant:weight:colorResolver:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

</details>

<details><summary markdown="span"><code>montage(_:variant:weight:semantic:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    semantic: Color.Semantic,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

</details>

<details><summary markdown="span"><code>montage(_:variant:weight:atomic:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    atomic: Color.Atomic,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

</details>

<details><summary markdown="span"><code>montage(_:variant:weight:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular
) -> NSAttributedString
```

</details>

<details><summary markdown="span"><code>montage(_:)</code></summary>

```swift
static func montage(
    _ string: String
) -> NSAttributedString
```

</details>
