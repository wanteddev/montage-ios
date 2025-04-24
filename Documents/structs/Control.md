**STRUCT**

# `Control`

```swift
public struct Control: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>checkbox(state:size:onSelect:)</code></summary>

```swift
public static func checkbox(
    state: State, size: Size = .medium, onSelect: ((State) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(checked:size:onSelect:)</code></summary>

```swift
public static func checkbox(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>checkmark(checked:size:onSelect:)</code></summary>

```swift
public static func checkmark(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>radio(checked:size:onSelect:)</code></summary>

```swift
public static func radio(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(_:size:)</code></summary>

```swift
public static func checkbox(_ state: Binding<State>, size: Size = .medium) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(_:size:)</code></summary>

```swift
public static func checkbox(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

</details>

<details><summary markdown="span"><code>checkmark(_:size:)</code></summary>

```swift
public static func checkmark(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

</details>

<details><summary markdown="span"><code>radio(_:size:)</code></summary>

```swift
public static func radio(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

</details>

<details><summary markdown="span"><code>tight(_:)</code></summary>

```swift
public func tight(_ tight: Bool = true) -> Self
```

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

</details>