**STRUCT**

# `Menu`

```swift
public struct Menu: View
```

드롭다운이나 컨텍스트 메뉴로 사용할 수 있는 메뉴 컴포넌트입니다.

일반, 라디오 버튼, 체크박스 형태로 메뉴 항목을 표시할 수 있으며,
메뉴 하단에 추가 액션 영역을 포함할 수 있습니다.

**사용 예시**:
```swift
// 기본 메뉴
@State private var items: [Menu.Item] = [
    .init(title: "항목 1"),
    .init(title: "항목 2"),
    .init(title: "항목 3")
]

Menu(
    variant: .normal,
    items: $items,
    onSelectCell: { item in
        print("선택된 항목: \(item.title)")
    }
)

// 라디오 메뉴 (단일 선택)
@State private var radioItems: [Menu.Item] = [
    .init(title: "옵션 1", isSelected: true),
    .init(title: "옵션 2"),
    .init(title: "옵션 3")
]

Menu(
    variant: .radio,
    items: $radioItems
)
```

- SeeAlso: `Menu.Variant`, `Menu.Item`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:items:onSelectCell:cellModifier:)</code></summary>

```swift
public init(
    variant: Variant,
    items: Binding<[Item]>,
    onSelectCell: ((Item) -> Void)? = nil,
    cellModifier: @escaping (_ index: Int, _ cell: Cell) -> Cell = { _, cell in cell }
)
```

메뉴 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 메뉴의 표시 형태 (normal, radio, checkbox) |
| items | 메뉴 항목 배열에 대한 바인딩 |
| onSelectCell | 항목 선택 시 호출될 클로저 (선택 사항) |
| cellModifier | 각 셀을 커스터마이징하기 위한 클로저 (기본값: 수정 없음) |




</details>

<details><summary markdown="span"><code>menuActionArea(leadingContent:trailingContent:)</code></summary>

```swift
public func menuActionArea(
    leadingContent: @escaping () -> any View,
    trailingContent: @escaping () -> any View
) -> Self
```

메뉴 하단에 액션 버튼 영역을 추가합니다.

왼쪽과 오른쪽에 버튼이나 다른 뷰를 배치할 수 있습니다.

**사용 예시**:
```swift
Menu(variant: .normal, items: $items)
    .menuActionArea(
        leadingContent: {
            Button.transparent(text: "취소")
        },
        trailingContent: {
            Button.filled(text: "확인")
        }
    )
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| leadingContent | 왼쪽에 표시할 콘텐츠를 반환하는 클로저 |
| trailingContent | 오른쪽에 표시할 콘텐츠를 반환하는 클로저 |

#### Returns

액션 영역이 추가된 Menu



</details>
