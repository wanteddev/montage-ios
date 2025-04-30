**STRUCT**

# `Tab`

```swift
public struct Tab: View
```

선택 가능한 탭 메뉴를 표시하는 컴포넌트입니다.

`Tab`은 여러 항목 중 하나를 선택할 수 있는 수평 탭 메뉴를 제공합니다.
선택된 탭은 하단에 강조 표시되며, 탭 너비와 크기를 다양하게 커스터마이징할 수 있습니다.

**사용 예시**:
```swift
@State private var selectedTab = 0
let tabItems = ["전체", "인기", "최신", "추천"]

Tab(selectedIndex: $selectedTab, items: tabItems) { index in
    print("탭 \(index) 선택됨")
}
.size(.medium)
.resize(.fill)
.horizontalPadding(true)
```

- Note: 탭 컴포넌트는 스크롤 가능한 형태로 제공되며, 다수의 탭 항목을 지원합니다.
  `.resize(.hug)` 설정 시 항목 너비가 콘텐츠에 맞게 조정되고, `.resize(.fill)` 설정 시
  전체 너비를 균등하게 분할합니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(selectedIndex:items:actions:)</code></summary>

```swift
public init(
    selectedIndex: Binding<Int>,
    items: [String],
    actions: @escaping (Int) -> Void = { _ in }
)
```

탭 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| selectedIndex | 현재 선택된 탭의 인덱스를 바인딩하는 변수 |
| items | 탭 항목 텍스트 배열 |
| actions | 탭 선택 시 호출되는 클로저, 선택된 인덱스를 파라미터로 받음 (기본값: 빈 클로저) |




</details>

<details><summary markdown="span"><code>resize(_:)</code></summary>

```swift
public func resize(_ resize: Resize) -> Self
```

탭 아이템의 너비 조정 방식을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| resize | 탭 아이템 너비 조정 방식 |

#### Returns

수정된 Tab 인스턴스

- Note: 기본값은 `.hug`입니다.



</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

탭 컴포넌트의 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 적용할 탭 크기 |

#### Returns

수정된 Tab 인스턴스

- Note: 기본값은 `.medium`입니다.



</details>

<details><summary markdown="span"><code>horizontalPadding(_:)</code></summary>

```swift
public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self
```

탭 컴포넌트의 좌우 여백 사용 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontalPadding | 좌우 여백 사용 여부 (기본값: true) |

#### Returns

수정된 Tab 인스턴스

- Note: 기본값은 `false`입니다. `true`로 설정 시 좌우에 20pt 여백이 적용됩니다.



</details>

<details><summary markdown="span"><code>iconButton(_:action:)</code></summary>

```swift
public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self
```

탭 컴포넌트의 오른쪽에 아이콘 버튼을 추가합니다.

`.resize(.hug)` 모드에서만 표시됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| icon | 표시할 아이콘 |
| action | 아이콘 버튼 탭 시 실행될 클로저 |

#### Returns

수정된 Tab 인스턴스



</details>
