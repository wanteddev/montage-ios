**STRUCT**

# `Chip.Filter`

```swift
public struct Filter: UIViewRepresentable
```

필터링 기능을 제공하는 칩 컴포넌트입니다.

이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다.
다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.

## 사용 예시
```swift
// 기본 필터 칩
Chip.Filter(
    variant: .solid,
    size: .medium,
    text: "카테고리",
    handler: { toggleFilter() }
)

// 활성화된 확장 가능한 필터 칩
Chip.Filter(
    variant: .outlined,
    text: "정렬",
    state: .expand,
    active: true,
    activeLabel: "최신순"
)
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
public var state: State = .normal
```

칩의 확장 상태입니다.

</details>

<details><summary markdown="span"><code>interactionState</code></summary>

```swift
public var interactionState: Decorate.Interaction.State = .normal
```

칩의 상호작용 상태입니다.

</details>

<details><summary markdown="span"><code>active</code></summary>

```swift
public var active = false
```

칩의 활성화 상태입니다.

</details>

<details><summary markdown="span"><code>activeLabel</code></summary>

```swift
public var activeLabel: String? = nil
```

활성화 상태일 때 표시할 레이블입니다.

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

칩의 비활성화 상태입니다.

</details>

<details><summary markdown="span"><code>iconColor</code></summary>

```swift
public var iconColor: SwiftUI.Color? = nil
```

아이콘 색상입니다.

</details>

<details><summary markdown="span"><code>fontColor</code></summary>

```swift
public var fontColor: SwiftUI.Color? = nil
```

텍스트 색상입니다.

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

칩 클릭 시 실행할 핸들러입니다.

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

필터 칩 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩의 외관 스타일, 기본값은 `.solid` |
| size | 칩의 크기, 기본값은 `.medium` |
| text | 칩에 표시할 텍스트 |
| state | 칩의 확장 상태, 기본값은 `.normal` |
| interactionState | 칩의 상호작용 상태, 기본값은 `.normal` |
| active | 칩의 활성화 상태, 기본값은 `false` |
| activeLabel | 활성화 상태일 때 표시할 레이블, 기본값은 `nil` |
| disable | 칩의 비활성화 상태, 기본값은 `false` |
| iconColor | 아이콘 색상, 기본값은 `nil` |
| fontColor | 텍스트 색상, 기본값은 `nil` |
| handler | 칩 클릭 시 실행할 핸들러, 기본값은 `nil` |

#### Returns

구성된 필터 칩 인스턴스



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

수정된 필터 칩 인스턴스



</details>
