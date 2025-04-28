**STRUCT**

# `SectionHeader`

```swift
public struct SectionHeader: View
```

섹션 제목과 부가 정보를 표시하는 헤더 컴포넌트입니다.

`SectionHeader`는 콘텐츠를 논리적으로 구분하는 섹션 제목을 표시하며,
선택적으로 추가 액션이나 정보를 제공할 수 있습니다.

**사용 예시**:
```swift
// 기본 섹션 헤더
SectionHeader(title: "추천 콘텐츠")

// 부제목이 있는 섹션 헤더
SectionHeader(title: "인기 영화", subtitle: "이번 주 TOP 10")

// 더보기 버튼이 있는 섹션 헤더
SectionHeader(title: "최신 업데이트", hasMoreButton: true) {
    print("더보기 버튼 클릭됨")
}

// 커스텀 트레일링 컨텐츠가 있는 섹션 헤더
SectionHeader(title: "카테고리") {
    Text("필터")
        .font(.caption)
        .foregroundColor(.blue)
}
```

- Note: 본 컴포넌트는 타이틀, 서브타이틀, 더보기 버튼, 커스텀 트레일링 콘텐츠를
  조합하여 다양한 형태의 섹션 헤더를 구성할 수 있습니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:)</code></summary>

```swift
public init(title: String)
```

섹션 헤더를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| title | 표시할 섹션 제목 |




</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

섹션 헤더의 크기를 설정합니다.

크기에 따라 폰트 크기와 높이가 자동으로 조정됩니다.
`xsmall` 크기를 선택하면 타이틀 색상이 `.labelAlternative`로 변경됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 적용할 헤더 크기 |

#### Returns

수정된 SectionHeader 인스턴스

- Note: 기본값은 `.medium`입니다.



</details>

<details><summary markdown="span"><code>titleColor(_:)</code></summary>

```swift
public func titleColor(_ color: SwiftUI.Color) -> Self
```

타이틀 텍스트의 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 적용할 텍스트 색상 |

#### Returns

수정된 SectionHeader 인스턴스

- Note: 기본값은 `.semantic(.labelStrong)`입니다.



</details>

<details><summary markdown="span"><code>headingContent(_:)</code></summary>

```swift
public func headingContent(_ content: (() -> any View)? = nil) -> Self
```

헤더 타이틀 옆에 추가 콘텐츠를 표시합니다.

타이틀 텍스트 바로 옆(오른쪽)에 추가 콘텐츠나 뱃지를 표시할 때 사용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 표시할 콘텐츠를 생성하는 클로저 |

#### Returns

수정된 SectionHeader 인스턴스



</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ content: (() -> any View)? = nil) -> Self
```

헤더의 오른쪽에 추가적인 콘텐츠를 표시합니다.

더보기 버튼이나 필터 등의 추가 기능을 제공할 때 사용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 표시할 콘텐츠를 생성하는 클로저 |

#### Returns

수정된 SectionHeader 인스턴스



</details>
