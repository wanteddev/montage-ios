**STRUCT**

# `Control.Switch`

```swift
public struct Switch: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:size:onChange:)</code></summary>

```swift
public init(
    _ isOn: Binding<Bool>,
    size: Size = .small,
    onChange: @escaping (Bool) -> Void = { _ in }
)
```

</details>