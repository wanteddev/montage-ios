**STRUCT**

# `Chip.Filter`

```swift
public struct Filter: UIViewRepresentable
```

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public var variant: Variant = .solid
```

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public var size: Size = .medium
```

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public var text = ""
```

</details>

<details><summary markdown="span"><code>state</code></summary>

```swift
public var state: State = .normal
```

</details>

<details><summary markdown="span"><code>interactionState</code></summary>

```swift
public var interactionState: Decorate.Interaction.State = .normal
```

</details>

<details><summary markdown="span"><code>active</code></summary>

```swift
public var active = false
```

</details>

<details><summary markdown="span"><code>activeLabel</code></summary>

```swift
public var activeLabel: String? = nil
```

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

</details>

<details><summary markdown="span"><code>iconColor</code></summary>

```swift
public var iconColor: SwiftUI.Color? = nil
```

</details>

<details><summary markdown="span"><code>fontColor</code></summary>

```swift
public var fontColor: SwiftUI.Color? = nil
```

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:size:text:state:interactionState:active:activeLabel:disable:iconColor:fontColor:handler:)</code></summary>

```swift
public init(
    variant: Variant = .solid,
    size: Size = .medium,
    text: String,
    state: State = .normal,
    interactionState: Decorate.Interaction.State = .normal,
    active: Bool = false,
    activeLabel: String? = nil,
    disable: Bool = false,
    iconColor: SwiftUI.Color? = nil,
    fontColor: SwiftUI.Color? = nil,
    handler: (() -> Void)? = nil
)
```

</details>

<details><summary markdown="span"><code>makeUIView(context:)</code></summary>

```swift
public func makeUIView(context _: Context) -> UIViewType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| context | A context structure containing information about the current state of the system. |

</details>

<details><summary markdown="span"><code>updateUIView(_:context:)</code></summary>

```swift
public func updateUIView(_ uiView: UIViewType, context _: Context)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| uiView | Your custom view object. |
| context | A context structure containing information about the current state of the system. |

</details>

<details><summary markdown="span"><code>sizeThatFits(_:uiView:context:)</code></summary>

```swift
public func sizeThatFits(
    _ proposal: ProposedViewSize,
    uiView: UIViewType,
    context _: Context
) -> CGSize?
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| proposal | The proposed size for the view. |
| uiView | Your custom view object. |
| context | A context structure containing information about the current state of the system. |

</details>

<details><summary markdown="span"><code>fill(horizontal:vertical:)</code></summary>

```swift
public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self
```

</details>