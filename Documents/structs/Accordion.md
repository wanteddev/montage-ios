**STRUCT**

# `Accordion`

```swift
public struct Accordion: View
```

접을 수 있는 컨텐츠를 제공하는 아코디언 컴포넌트입니다.

`Accordion`은 제목과 함께 접을 수 있는 컨텐츠를 제공하는 컴포넌트입니다.
제목을 탭하면 컨텐츠가 확장되거나 축소됩니다. 설명 텍스트와 커스텀 컨텐츠를 함께 표시할 수 있습니다.

## 개요
아코디언은 제한된 공간에서 많은 정보를 효율적으로 표시하기 위한 UI 패턴입니다.
사용자는 관심 있는 항목만 확장하여 볼 수 있습니다.

## 사용 예시
```swift
// 기본 사용법
Accordion(
    title: "아코디언 제목",
    description: "아코디언 설명 텍스트입니다."
)

// 커스텀 컨텐츠 추가
Accordion(
    title: "커스텀 컨텐츠",
    description: "설명 텍스트"
) {
    VStack(alignment: .leading, spacing: 8) {
        Text("커스텀 컨텐츠 1")
        Text("커스텀 컨텐츠 2")
    }
}

// 스타일 커스터마이징
Accordion(title: "커스텀 스타일")
    .title(.headline, weight: .semibold, color: .red)
    .verticalPadding(.small)
    .leadingIcon(.info)
    .fillWidth()
```

- Note: 아코디언은 기본적으로 하단에 구분선을 갖고 있으며, `hideDivider()` 수정자를 통해 제거할 수 있습니다.
- SeeAlso: ``VerticalPadding``

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:description:content:)</code></summary>

```swift
public init(
    title: String,
    description: String? = nil,
    content: (() -> any View)? = nil
)
```

아코디언을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| title | 아코디언의 제목 |
| description | 확장 시 표시될 설명 텍스트 (선택 사항) |
| content | 확장 시 표시될 커스텀 컨텐츠 뷰 (선택 사항) |




</details>

<details><summary markdown="span"><code>title(_:weight:color:)</code></summary>

```swift
public func title(
    _ variant: Typography.Variant = .body2,
    weight: Typography.Weight = .bold,
    color: SwiftUI.Color = .semantic(.labelNormal)
) -> Self
```

타이틀 텍스트의 타이포그래피 속성을 조정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 (기본값: `.body2`) |
| weight | 텍스트 굵기 (기본값: `.bold`) |
| color | 텍스트 색상 (기본값: `.semantic(.labelNormal)`) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>description(_:weight:color:)</code></summary>

```swift
public func description(
    _ variant: Typography.Variant = .label1,
    weight: Typography.Weight = .regular,
    color: SwiftUI.Color = .semantic(.labelNeutral)
) -> Self
```

설명 텍스트의 타이포그래피 속성을 조정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 (기본값: `.label1`) |
| weight | 텍스트 굵기 (기본값: `.regular`) |
| color | 텍스트 색상 (기본값: `.semantic(.labelNeutral)`) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>verticalPadding(_:)</code></summary>

```swift
public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self
```

아코디언 헤더의 상하 여백 크기를 조정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| verticalPadding | 상하 여백 크기 (기본값: `.large`) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>fillWidth(_:)</code></summary>

```swift
public func fillWidth(_ fillWidth: Bool = true) -> Self
```

아코디언이 부모 컨테이너의 너비를 채우도록 설정합니다.

이 수정자를 적용하면 좌우 20pt의 여백이 추가됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| fillWidth | 너비를 채울지 여부 (기본값: `true`) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>hideDivider(_:)</code></summary>

```swift
public func hideDivider(_ hideDivider: Bool = true) -> Self
```

아코디언 하단의 구분선을 숨깁니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| hideDivider | 구분선을 숨길지 여부 (기본값: `true`) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>leadingIcon(_:color:)</code></summary>

```swift
public func leadingIcon(_ leadingIcon: Icon? = nil, color: SwiftUI.Color? = nil) -> Self
```

아코디언 제목 앞에 아이콘을 추가합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| leadingIcon | 표시할 아이콘 |
| color | 아이콘 색상 (기본값: nil - 기본 색상 사용) |

#### Returns

수정된 아코디언 인스턴스



</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ trailingContent: (() -> any View)? = nil) -> Self
```

아코디언 헤더 우측에 커스텀 컨텐츠를 추가합니다.

이 수정자를 사용하면 기본 화살표 아이콘이 대체됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| trailingContent | 표시할 커스텀 컨텐츠 뷰 |

#### Returns

수정된 아코디언 인스턴스



</details>
