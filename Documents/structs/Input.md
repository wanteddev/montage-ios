**STRUCT**

# `Input`

```swift
public struct Input: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>checkbox(state:text:onSelect:)</code></summary>

```swift
public static func checkbox(
    state: Control.State,
    text: String,
    onSelect: ((Control.State) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(checked:text:onSelect:)</code></summary>

```swift
public static func checkbox(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>checkmark(checked:text:onSelect:)</code></summary>

```swift
public static func checkmark(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Self
```

</details>

<details><summary markdown="span"><code>radio(checked:text:onSelect:)</code></summary>

```swift
public static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(_:text:)</code></summary>

```swift
public static func checkbox(_ state: Binding<Control.State>, text: String) -> Self
```

</details>

<details><summary markdown="span"><code>checkbox(_:text:)</code></summary>

```swift
public static func checkbox(_ checked: Binding<Bool>, text: String) -> Self
```

</details>

<details><summary markdown="span"><code>checkmark(_:text:)</code></summary>

```swift
public static func checkmark(_ checked: Binding<Bool>, text: String) -> Self
```

</details>

<details><summary markdown="span"><code>radio(_:text:)</code></summary>

```swift
public static func radio(_ checked: Binding<Bool>, text: String) -> Self
```

</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Control.Size) -> Self
```

사이즈를 조정합니다. 기본값은 `.medium`입니다.

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ isDisable: Bool = true) -> Self
```

비활성화합니다.

</details>

<details><summary markdown="span"><code>title(_:weight:color:)</code></summary>

```swift
public func title(
    _ variant: Typography.Variant? = nil,
    weight: Typography.Weight? = nil,
    color: SwiftUI.Color? = nil
) -> Self
```

타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.regular`, `.semantic(.labelNormal)`입니다.

</details>

<details><summary markdown="span"><code>bold(_:)</code></summary>

```swift
public func bold(_ isBold: Bool = true) -> Self
```

타이틀을 볼드체로 변경합니다.

</details>

<details><summary markdown="span"><code>tight(_:)</code></summary>

```swift
public func tight(_ tight: Bool = true) -> Self
```

</details>