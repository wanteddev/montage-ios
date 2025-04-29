**STRUCT**

# `Chip.Action`

```swift
public struct Action: View
```

액션 칩 컴포넌트입니다.

텍스트와 이미지를 포함하는 칩 형태의 버튼입니다.
다양한 크기와 스타일을 지원하며, 탭 이벤트를 처리할 수 있습니다.

**사용 예시**:
```swift
Chip.Action(
    variant: .solid,
    size: .medium,
    text: "액션"
)
.backgroundColor(.semantic(.primary))
.fontColor(.semantic(.staticWhite))
.leadingImage(Image(systemName: "heart"))
```

- Note: 기본적으로 8pt의 패딩과 12pt의 모서리 반경을 가집니다.

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public let variant: Variant
```

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public let size: Size
```

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public let text: String
```

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public let handler: (() -> Void)?
```

</details>

<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:size:text:handler:)</code></summary>

```swift
public init(
    variant: Variant = .solid,
    size: Size = .medium,
    text: String,
    handler: (() -> Void)? = nil
)
```

액션 칩을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩의 외관 스타일, 기본값은 `.solid` |
| size | 칩의 크기, 기본값은 `.medium` |
| text | 칩에 표시할 텍스트 |
| handler | 칩 클릭 시 실행할 핸들러, 기본값은 `nil` |

#### Returns

구성된 액션 칩 인스턴스



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

<details><summary markdown="span"><code>active(_:)</code></summary>

```swift
public func active(_ active: Bool = true) -> Self
```

칩의 선택 상태를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| active | 선택 상태 여부 |

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

수정된 칩 인스턴스



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

수정된 칩 인스턴스



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

수정된 칩 인스턴스



</details>
