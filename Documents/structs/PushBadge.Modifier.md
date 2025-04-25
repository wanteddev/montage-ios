**STRUCT**

# `PushBadge.Modifier`

```swift
public struct Modifier: ViewModifier
```

다른 뷰에 PushBadge를 적용하기 위한 뷰 모디파이어입니다.

이 모디파이어를 사용하면 기존 뷰의 특정 위치에 뱃지를 표시할 수 있습니다.

**사용 예시**:
```swift
IconButton(icon: .home)
    .modifier(
        PushBadge.Modifier(
            variant: .number(3),
            size: .small,
            position: .top(.trailing)
        )
    )
```

## Methods
<details><summary markdown="span"><code>init(variant:size:fontColor:backgroundColor:position:inset:)</code></summary>

```swift
public init(
    variant: Variant = .dot,
    size: Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: Position = .top(.trailing),
    inset: CGSize = .zero
)
```

PushBadge 모디파이어를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 뱃지의 표시 형태 (기본값: .dot) |
| size | 뱃지 크기 (기본값: .xsmall) |
| fontColor | 텍스트 색상 (기본값: staticWhite) |
| backgroundColor | 배경 색상 (기본값: primaryNormal) |
| position | 뱃지 위치 (기본값: .top(.trailing)) |
| inset | 위치 조정을 위한 여백 (기본값: .zero) |




</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
