**STRUCT**

# `Bar.TopNavigation`

```swift
public struct TopNavigation: View
```

상단에 표시되는 내비게이션 바 컴포넌트입니다.

제목, 뒤로가기 버튼, 추가 액션 버튼 등을 포함할 수 있으며, 다양한 외관 스타일을 지원합니다.
스크롤 시 배경색과 구분선의 불투명도가 자동으로 조절됩니다.

**사용 예시**:
```swift
Bar.TopNavigation(
    variant: .normal,
    title: "제목",
    leadingButton: .back {
        // 뒤로가기 동작
    },
    trailingButtons: [
        .icon(.search) {
            // 검색 동작
        }
    ]
)
```

- SeeAlso: `Bar.TopNavigation.Variant`, `Bar.TopNavigation.Resource`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:title:scrollOffset:backgroundColorResolvable:leadingButton:trailingButtons:)</code></summary>

```swift
public init(
    variant: Variant = .normal,
    title: String = "",
    scrollOffset: CGFloat = .zero,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton? = nil,
    trailingButtons: [Resource.TrailingButton] = []
)
```

TopNavigation을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 내비게이션 바의 외관 스타일 |
| title | 표시할 제목 |
| scrollOffset | 스크롤 오프셋 값 |
| backgroundColorResolvable | 배경색 리졸버 |
| leadingButton | 좌측에 표시할 버튼 |
| trailingButtons | 우측에 표시할 버튼 배열 (최대 3개까지 표시) |




</details>
