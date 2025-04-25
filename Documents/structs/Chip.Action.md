**STRUCT**

# `Chip.Action`

```swift
public struct Action: UIViewRepresentable
```

액션 실행을 위한 칩 컴포넌트입니다.

이 컴포넌트는 사용자가 간단한 액션을 수행할 수 있는 콤팩트한 UI 요소입니다.
다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있고 이미지를 추가할 수 있습니다.

## 사용 예시
```swift
// 기본 액션 칩
Chip.Action(
    variant: .solid,
    size: .medium,
    text: "태그 추가",
    handler: { addTag() }
)

// 이미지가 있는 액션 칩
Chip.Action(
    variant: .outlined,
    text: "공유",
    active: true
)
.leadingImage(Image(systemName: "share"))
.imageColor(.blue)
```

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public var variant: Variant = .solid
```

칩의 외관 스타일입니다.

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public var size: Size = .medium
```

칩의 크기입니다.

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public var text = ""
```

칩에 표시할 텍스트입니다.

</details>

<details><summary markdown="span"><code>state</code></summary>

```swift
public var state: Decorate.Interaction.State = .normal
```

칩의 상호작용 상태입니다.

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

칩의 비활성화 상태입니다.

</details>

<details><summary markdown="span"><code>active</code></summary>

```swift
public var active = false
```

칩의 활성화 상태입니다.

</details>

<details><summary markdown="span"><code>backgroundColor</code></summary>

```swift
public var backgroundColor: SwiftUI.Color? = nil
```

배경 색상입니다. nil인 경우 기본 색상이 사용됩니다.

</details>

<details><summary markdown="span"><code>fontColor</code></summary>

```swift
public var fontColor: SwiftUI.Color? = nil
```

텍스트 색상입니다. nil인 경우 기본 색상이 사용됩니다.

</details>

<details><summary markdown="span"><code>activeColor</code></summary>

```swift
public var activeColor: SwiftUI.Color? = nil
```

활성화 상태일 때의 색상입니다. nil인 경우 기본 색상이 사용됩니다.

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

칩 클릭 시 실행할 핸들러입니다.

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

액션 칩 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩의 외관 스타일, 기본값은 `.solid` |
| size | 칩의 크기, 기본값은 `.medium` |
| text | 칩에 표시할 텍스트 |
| state | 칩의 상호작용 상태, 기본값은 `.normal` |
| disable | 칩의 비활성화 상태, 기본값은 `false` |
| active | 칩의 활성화 상태, 기본값은 `false` |
| backgroundColor | 배경 색상, 기본값은 `nil` |
| fontColor | 텍스트 색상, 기본값은 `nil` |
| activeColor | 활성화 상태일 때의 색상, 기본값은 `nil` |
| handler | 칩 클릭 시 실행할 핸들러, 기본값은 `nil` |

#### Returns

구성된 액션 칩 인스턴스



</details>

<details><summary markdown="span"><code>makeUIView(context:)</code></summary>

```swift
public func makeUIView(context _: Context) -> UIViewType
```



</details>

<details><summary markdown="span"><code>updateUIView(_:context:)</code></summary>

```swift
public func updateUIView(_ uiView: UIViewType, context _: Context)
```



</details>

<details><summary markdown="span"><code>sizeThatFits(_:uiView:context:)</code></summary>

```swift
public func sizeThatFits(
    _ proposal: ProposedViewSize,
    uiView: UIViewType,
    context _: Context
) -> CGSize?
```



</details>

<details><summary markdown="span"><code>fill(horizontal:vertical:)</code></summary>

```swift
public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self
```

칩이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| fillHorizontal | 수평 방향 채우기 여부 |
| fillVertical | 수직 방향 채우기 여부 |

#### Returns

수정된 액션 칩 인스턴스



</details>

<details><summary markdown="span"><code>leadingImage(_:)</code></summary>

```swift
public func leadingImage(_ image: Image) -> Self
```

칩의 좌측에 이미지를 추가합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| image | 표시할 이미지 |

#### Returns

수정된 액션 칩 인스턴스



</details>

<details><summary markdown="span"><code>trailingImage(_:)</code></summary>

```swift
public func trailingImage(_ image: Image) -> Self
```

칩의 우측에 이미지를 추가합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| image | 표시할 이미지 |

#### Returns

수정된 액션 칩 인스턴스



</details>

<details><summary markdown="span"><code>imageColor(_:)</code></summary>

```swift
public func imageColor(_ color: SwiftUI.Color) -> Self
```

이미지의 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 이미지에 적용할 색상 |
| Note | 기본값은 `.semantic(.labelAlternative)`입니다. |

#### Returns

수정된 액션 칩 인스턴스



</details>
