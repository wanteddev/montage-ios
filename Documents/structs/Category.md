**STRUCT**

# `Category`

```swift
public struct Category: View
```

카테고리 선택 옵션을 가로로 나열하는 컴포넌트입니다.

사용자가 카테고리 목록에서 하나의 항목을 선택할 수 있는 스크롤 가능한 컴포넌트입니다.
다양한 크기와 스타일을 지원하며, 선택된 항목에 대한 시각적 피드백을 제공합니다.

**사용 예시**:
```swift
@State private var selectedIndex = 0
let categories = ["전체", "디자인", "개발", "마케팅", "경영"]

Category(
    selectedIndex: $selectedIndex,
    items: categories,
    actions: { index in
        print("선택된 카테고리: \(categories[index])")
    }
)
.variant(.alternative)
.size(.medium)
.horizontalPadding()
```

- Note: 측면 그라데이션 효과와 아이콘 버튼을 추가할 수 있어 스크롤 가능한 콘텐츠임을 시각적으로 나타냅니다.

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

카테고리 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| selectedIndex | 현재 선택된 항목의 인덱스 바인딩 |
| items | 표시할 카테고리 항목 배열 |
| actions | 항목 선택 시 호출될 클로저 (기본값: 빈 클로저) |




</details>

<details><summary markdown="span"><code>variant(_:)</code></summary>

```swift
public func variant(_ variant: Variant) -> Self
```

카테고리 아이템 스타일을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 아이템 스타일 (.normal 또는 .alternative) |

#### Returns

수정된 카테고리 인스턴스



</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

카테고리 아이템 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 아이템 크기 (.small, .medium, .large, .xlarge) |

#### Returns

수정된 카테고리 인스턴스



</details>

<details><summary markdown="span"><code>horizontalPadding(_:)</code></summary>

```swift
public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self
```

카테고리 컴포넌트의 좌우 패딩을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontalPadding | 패딩 적용 여부 (기본값: true) |

#### Returns

수정된 카테고리 인스턴스



</details>

<details><summary markdown="span"><code>verticalPadding(_:)</code></summary>

```swift
public func verticalPadding(_ verticalPadding: Bool = true) -> Self
```

카테고리 컴포넌트의 상하 패딩을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| verticalPadding | 패딩 적용 여부 (기본값: true) |

#### Returns

수정된 카테고리 인스턴스



</details>

<details><summary markdown="span"><code>iconButton(_:action:)</code></summary>

```swift
public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self
```

카테고리 컴포넌트 오른쪽에 표시할 아이콘 버튼을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| icon | 표시할 아이콘 |
| action | 버튼 클릭 시 실행할 액션 |

#### Returns

수정된 카테고리 인스턴스



</details>
