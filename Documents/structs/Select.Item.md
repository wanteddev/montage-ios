**STRUCT**

# `Select.Item`

```swift
public struct Item: Equatable
```

아이템 타입입니다.

## Properties
<details><summary markdown="span"><code>text</code></summary>

```swift
public let text: String
```

</details>

<details><summary markdown="span"><code>icon</code></summary>

```swift
public let icon: Icon?
```

</details>

<details><summary markdown="span"><code>isNegative</code></summary>

```swift
public let isNegative: Bool
```

</details>

<details><summary markdown="span"><code>isSelected</code></summary>

```swift
public var isSelected: Bool
```

</details>

## Methods
<details><summary markdown="span"><code>init(text:icon:isNegative:isSelected:)</code></summary>

```swift
public init(
    text: String,
    icon: Icon? = nil,
    isNegative: Bool = false,
    isSelected: Bool = false
)
```

</details>