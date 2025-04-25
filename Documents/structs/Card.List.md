**STRUCT**

# `Card.List`

```swift
public struct List: View
```

썸네일과 콘텐츠를 수평으로 배치한 리스트 형태의 카드 컴포넌트입니다.

썸네일 이미지와 텍스트 콘텐츠를 수평 방향으로 배치한 카드로, 리스트 항목으로 사용하기 적합합니다.
스켈레톤 로딩 상태를 지원하고 다양한 콘텐츠를 배치할 수 있습니다.

**사용 예시**:
```swift
@State private var isLoading = false

Card.List(
    thumbnail: { Thumbnail(.image(Image("sample")), variant: .square) },
    skeleton: $isLoading,
    title: { Text("리스트 카드 제목").montage(variant: .heading4) }
)
.caption { Text("부제목").montage(variant: .body2) }
.trailingContent { IconButton(icon: .arrowForward) }
```

- Note: 리스트 형태의 UI에 적합하며, 선택적으로 앞뒤에 추가 콘텐츠를 배치할 수 있습니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(thumbnail:skeleton:title:)</code></summary>

```swift
public init(
    thumbnail: @escaping () -> Thumbnail,
    skeleton: Binding<Bool>,
    title: @escaping () -> any View
)
```

List 카드를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| thumbnail | 카드에 표시할 썸네일 이미지 |
| skeleton | 스켈레톤 로딩 상태 바인딩 |
| title | 카드 제목으로 표시할 뷰 |




</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: (() -> any View)? = nil) -> Self
```

카드의 캡션(부제목)을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| caption | 표시할 캡션 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>

<details><summary markdown="span"><code>extraCaption(_:)</code></summary>

```swift
public func extraCaption(_ extraCaption: (() -> any View)? = nil) -> Self
```

카드의 추가 캡션을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| extraCaption | 표시할 추가 캡션 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>

<details><summary markdown="span"><code>topContent(_:)</code></summary>

```swift
public func topContent(_ content: (() -> any View)? = nil) -> Self
```

카드 상단에 표시할 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 상단에 표시할 콘텐츠 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>

<details><summary markdown="span"><code>bottomContent(_:)</code></summary>

```swift
public func bottomContent(_ content: (() -> any View)? = nil) -> Self
```

카드 하단에 표시할 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 하단에 표시할 콘텐츠 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>

<details><summary markdown="span"><code>leadingContent(_:)</code></summary>

```swift
public func leadingContent(_ content: (() -> any View)? = nil) -> Self
```

카드 왼쪽(썸네일 앞)에 표시할 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 왼쪽에 표시할 콘텐츠 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ content: (() -> any View)? = nil) -> Self
```

카드 오른쪽에 표시할 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 오른쪽에 표시할 콘텐츠 뷰를 반환하는 클로저 |

#### Returns

수정된 카드 인스턴스



</details>
