**STRUCT**

# `Select`

```swift
public struct Select: View
```

`Select` 컴포넌트는 사용자가 드롭다운 메뉴에서 하나 또는 여러 항목을 선택할 수 있는 UI 요소입니다.
단일 선택 또는 다중 선택 모드를 지원하며, 여러 시각적 변형과 맞춤 설정 옵션을 제공합니다.

## 사용 예시:
```swift
@State private var items = [
    .init(text: "Option 1"),
    .init(text: "Option 2"),
    .init(text: "Option 3")
]

Select(
    variant: .single(.checkmark, nil),
    placeholder: "선택하세요",
    items: $items
)
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(menuPresented:variant:items:onTapItem:)</code></summary>

```swift
public init(
    menuPresented: Binding<Bool>? = nil,
    variant: Variant,
    items: Binding<[Item]>,
    onTapItem: ((Select.Item) -> Void)? = nil
)
```

Select 컴포넌트 초기화
#### Parameters

| Name | Description |
| ---- | ----------- |
| menuPresented | 메뉴 표시 상태 바인딩 (기본값: nil) |
| variant | 컴포넌트의 시각적/기능적 변형 |
| items | 선택 가능한 항목 배열 (바인딩) |
| onTapItem | 항목 선택 시 호출되는 클로저 (기본값: nil) |




</details>

<details><summary markdown="span"><code>negative(_:)</code></summary>

```swift
public func negative(_ negative: Bool = true) -> Self
```

negative 상태 여부를 조정합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| negative | 부정적 상태 여부 (기본값: true) |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String) -> Self
```

선택된 항목들이 없는 경우 placeholder를 표시합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| placeholder | 표시할 플레이스홀더 텍스트 |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

활성화 여부를 조정합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부 (기본값: true) |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String) -> Self
```

제목을 추가합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| heading | 표시할 제목 텍스트 |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool = true) -> Self
```

필수 표시 노출 여부를 조정합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| requiredBadge | 필수 표시 여부 (기본값: true) |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>description(_:)</code></summary>

```swift
public func description(_ description: String) -> Self
```

설명을 추가합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| description | 표시할 설명 텍스트 |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>shadowBackgroundColor(_:)</code></summary>

```swift
public func shadowBackgroundColor(_ shadowBackgroundColor: SwiftUI.Color) -> Self
```

shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| shadowBackgroundColor | 설정할 배경색 |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>leadingContent(_:)</code></summary>

```swift
public func leadingContent(_ content: LeadingContent?) -> Self
```

왼쪽 컨텐츠를 추가합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 표시할 선행 콘텐츠 |

#### Returns

수정된 Select 인스턴스



</details>

<details><summary markdown="span"><code>menuResize(_:)</code></summary>

```swift
public func menuResize(_ menuResize: Modal.BottomSheet.Resize) -> Self
```

메뉴의 높이 detent를 지정합니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| menuResize | 메뉴 크기 조정 방식 |

#### Returns

수정된 Select 인스턴스



</details>
