**STRUCT**

# `Chip.Action`

```swift
public struct Action: UIViewRepresentable
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
public var state: Decorate.Interaction.State = .normal
```

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

</details>

<details><summary markdown="span"><code>active</code></summary>

```swift
public var active = false
```

</details>

<details><summary markdown="span"><code>backgroundColor</code></summary>

```swift
public var backgroundColor: SwiftUI.Color? = nil
```

</details>

<details><summary markdown="span"><code>fontColor</code></summary>

```swift
public var fontColor: SwiftUI.Color? = nil
```

</details>

<details><summary markdown="span"><code>activeColor</code></summary>

```swift
public var activeColor: SwiftUI.Color? = nil
```

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:size:text:state:disable:active:backgroundColor:fontColor:activeColor:handler:)</code></summary>

```swift
public init(
    variant: Variant = .solid,
    size: Size = .medium,
    text: String,
    state: Decorate.Interaction.State = .normal,
    disable: Bool = false,
    active: Bool = false,
    backgroundColor: SwiftUI.Color? = nil,
    fontColor: SwiftUI.Color? = nil,
    activeColor: SwiftUI.Color? = nil,
    handler: ( () -> Void)? = nil
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

<details><summary markdown="span"><code>leadingImage(_:)</code></summary>

```swift
public func leadingImage(_ image: Image) -> Self
```

좌측 이미지를 지정합니다.

</details>

<details><summary markdown="span"><code>trailingImage(_:)</code></summary>

```swift
public func trailingImage(_ image: Image) -> Self
```

우측 이미지를 지정합니다.

</details>

<details><summary markdown="span"><code>imageColor(_:)</code></summary>

```swift
public func imageColor(_ color: SwiftUI.Color) -> Self
```

이미지 색상을 지정합니다. 기본값은 .semantic(.labelAlternative) 입니다.

</details>