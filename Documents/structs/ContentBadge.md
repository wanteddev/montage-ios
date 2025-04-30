**STRUCT**

# `ContentBadge`

```swift
public struct ContentBadge: View
```

텍스트와 아이콘을 포함할 수 있는 뱃지 컴포넌트입니다.

다양한 크기와 스타일, 색상을 제공하며 텍스트 앞뒤로 아이콘을 추가할 수 있습니다.
솔리드와 아웃라인 스타일을 지원합니다.

**사용 예시**:
```swift
// 기본 솔리드 뱃지
ContentBadge(text: "New")

// 아웃라인 스타일 뱃지
ContentBadge(variant: .outlined, text: "Updated")
    .size(.medium)
    .colorStyle(.accent(SwiftUI.Color.blue))
    .leadingIcon(.check)
```

- SeeAlso: `ContentBadge.Variant`, `ContentBadge.Size`, `ContentBadge.ColorStyle`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:text:)</code></summary>

```swift
public init(variant: Variant = .solid, text: String)
```

ContentBadge를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 뱃지의 스타일 (solid 또는 outlined) |
| text | 뱃지에 표시할 텍스트 |




</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

뱃지의 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 뱃지 크기 |

#### Returns

변경된 크기가 적용된 ContentBadge



</details>

<details><summary markdown="span"><code>colorStyle(_:)</code></summary>

```swift
public func colorStyle(_ colorStyle: ColorStyle) -> Self
```

뱃지의 색상 스타일을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| colorStyle | 색상 스타일 |

#### Returns

변경된 색상 스타일이 적용된 ContentBadge



</details>

<details><summary markdown="span"><code>leadingIcon(_:)</code></summary>

```swift
public func leadingIcon(_ leadingIcon: Icon) -> Self
```

뱃지 텍스트 앞에 표시될 아이콘을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| leadingIcon | 선행 아이콘 |

#### Returns

선행 아이콘이 추가된 ContentBadge



</details>

<details><summary markdown="span"><code>trailingIcon(_:)</code></summary>

```swift
public func trailingIcon(_ trailingIcon: Icon) -> Self
```

뱃지 텍스트 뒤에 표시될 아이콘을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| trailingIcon | 후행 아이콘 |

#### Returns

후행 아이콘이 추가된 ContentBadge



</details>
