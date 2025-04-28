**STRUCT**

# `Bar.TopNavigation.TopNavigationModifier`

```swift
public struct TopNavigationModifier: ViewModifier
```

컨텐츠 뷰에 TopNavigation을 적용하는 뷰 모디파이어입니다.

스크롤 감지 및 내비게이션 바 스타일링을 자동으로 처리합니다.

**사용 예시**:
```swift
contentView
    .modifier(
        Bar.TopNavigation.TopNavigationModifier(
            variant: .normal,
            title: "제목",
            leadingButton: .back { 
                // 뒤로가기 동작
            },
            trailingButtons: []
        )
    )
```

## Methods
<details><summary markdown="span"><code>init(variant:title:showIndicator:backgroundColorResolvable:leadingButton:trailingButtons:actionAreaModel:)</code></summary>

```swift
public init(
    variant: Variant,
    title: String,
    showIndicator: Bool = true,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton?,
    trailingButtons: [Resource.TrailingButton],
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

TopNavigationModifier를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 내비게이션 바의 외관 스타일 |
| title | 표시할 제목 |
| showIndicator | 인디케이터 표시 여부 |
| backgroundColorResolvable | 배경색 리졸버 |
| leadingButton | 좌측에 표시할 버튼 |
| trailingButtons | 우측에 표시할 버튼 배열 |
| actionAreaModel | 액션 영역 모델 |




</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
