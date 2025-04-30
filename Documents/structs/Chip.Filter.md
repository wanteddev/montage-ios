**STRUCT**

# `Chip.Filter`

```swift
public struct Filter: View
```

필터링 기능을 제공하는 칩 컴포넌트입니다.

이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다.
다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.

**사용 예시**:
```swift
Chip.Filter(
    variant: .solid,
    size: .medium,
    text: "카테고리",
    state: $state
)
.backgroundColor(.semantic(.primary))
.fontColor(.semantic(.staticWhite))
.active(true)
.activeLabel("최신순")
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:size:text:state:handler:)</code></summary>

```swift
public init(
    variant: Variant = .solid,
    size: Size = .medium,
    text: String,
    state: Binding<State> = .constant(.normal),
    handler: (() -> Void)? = nil
)
```

필터 칩을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩의 외관 스타일, 기본값은 `.solid` |
| size | 칩의 크기, 기본값은 `.medium` |
| text | 칩에 표시할 텍스트 |
| state | 칩의 확장 상태 바인딩, 기본값은 `.constant(.normal)` |
| handler | 칩 클릭 시 실행할 핸들러, 기본값은 `nil` |




</details>

<details><summary markdown="span"><code>active(_:label:)</code></summary>

```swift
public func active(_ active: Bool, label: String? = nil) -> Self
```

칩의 활성화 상태와 레이블을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| active | 활성화 여부 |
| label | 활성화 상태일 때 표시할 레이블 |

#### Returns

수정된 칩 인스턴스



</details>

<details><summary markdown="span"><code>disabled(_:)</code></summary>

```swift
public func disabled(_ disable: Bool = true) -> Self
```

칩의 비활성화 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부 |

#### Returns

수정된 칩 인스턴스



</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ color: SwiftUI.Color) -> Self
```

칩의 배경색을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 적용할 배경색 |

#### Returns

수정된 칩 인스턴스



</details>

<details><summary markdown="span"><code>fontColor(_:)</code></summary>

```swift
public func fontColor(_ color: SwiftUI.Color) -> Self
```

칩의 텍스트 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 적용할 텍스트 색상 |

#### Returns

수정된 칩 인스턴스



</details>

<details><summary markdown="span"><code>activeColor(_:)</code></summary>

```swift
public func activeColor(_ color: SwiftUI.Color) -> Self
```

칩의 활성화 상태 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 활성화 상태일 때의 색상 |

#### Returns

수정된 칩 인스턴스



</details>

<details><summary markdown="span"><code>iconColor(_:)</code></summary>

```swift
public func iconColor(_ color: SwiftUI.Color) -> Self
```

아이콘의 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 아이콘에 적용할 색상 |
| Note | 기본값은 `.semantic(.labelAlternative)`입니다. |

#### Returns

수정된 칩 인스턴스



</details>
