**STRUCT**

# `IconButton`

```swift
public struct IconButton: View
```

다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.

아이콘만 표시하는 간결한 버튼으로, 여러 변형과 스타일을 지원합니다:
- 기본형(normal): 배경 없이 아이콘만 표시
- 배경형(background): 반투명 배경을 가진 아이콘
- 외곽선형(outlined): 테두리로 둘러싸인 아이콘
- 솔리드형(solid): 배경색이 채워진 아이콘

```swift
IconButton(
    variant: .default,
    icon: .arrowLeft,
    handler: { print("뒤로 가기 버튼 탭됨") }
)
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:icon:disable:showPushBadge:padding:iconColor:backgroundColor:borderColor:handler:)</code></summary>

```swift
public init(
    variant: IconButton.Variant = .default,
    icon: Icon,
    disable: Bool = false,
    showPushBadge: Bool = false,
    padding: CGFloat = .zero,
    iconColor: SwiftUI.Color? = nil,
    backgroundColor: SwiftUI.Color? = nil,
    borderColor: SwiftUI.Color? = nil,
    handler: (() -> Void)? = nil
)
```

아이콘 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 외관 스타일, 기본값은 `.default`
  - icon: 표시할 아이콘
  - disable: 비활성화 여부, 기본값은 `false`
  - showPushBadge: 푸시 뱃지 표시 여부, 기본값은 `false` (normal 변형에서만 적용)
  - padding: 추가 패딩, 기본값은 `0` (outlined, solid 변형에서만 적용)
  - iconColor: 아이콘 색상 커스터마이징, 기본값은 `nil`
  - backgroundColor: 배경 색상 커스터마이징, 기본값은 `nil` (outlined, solid 변형에서만 적용)
  - borderColor: 테두리 색상 커스터마이징, 기본값은 `nil` (outlined 변형에서만 적용)
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 아이콘 버튼 뷰

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 외관 스타일, 기본값은 `.default` |
| icon | 표시할 아이콘 |
| disable | 비활성화 여부, 기본값은 `false` |
| showPushBadge | 푸시 뱃지 표시 여부, 기본값은 `false` (normal 변형에서만 적용) |
| padding | 추가 패딩, 기본값은 `0` (outlined, solid 변형에서만 적용) |
| iconColor | 아이콘 색상 커스터마이징, 기본값은 `nil` |
| backgroundColor | 배경 색상 커스터마이징, 기본값은 `nil` (outlined, solid 변형에서만 적용) |
| borderColor | 테두리 색상 커스터마이징, 기본값은 `nil` (outlined 변형에서만 적용) |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>