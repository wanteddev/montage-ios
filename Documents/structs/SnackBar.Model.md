**STRUCT**

# `SnackBar.Model`

```swift
public struct Model: Equatable
```

## Methods
<details><summary markdown="span"><code>init(duration:heading:description:extraContents:action:)</code></summary>

```swift
public init(
    duration: Duration = .short,
    heading: String? = nil,
    description: String? = nil,
    extraContents: (() -> any View)? = nil,
    action: String
)
```

</details>

<details><summary markdown="span"><code>==(_:_:)</code></summary>

```swift
public static func == (lhs: Self, rhs: Self) -> Bool
```



</details>
