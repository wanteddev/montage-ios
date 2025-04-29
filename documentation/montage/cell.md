Structure

# Cell 

텍스트와 콘텐츠를 포함하는 리스트 아이템 컴포넌트입니다.

```swift
@MainActor
struct Cell
```

## Overview 

Cell은 앱 내에서 리스트 형태로 정보를 표시할 때 사용되는 기본 컴포넌트입니다. 타이틀, 부가 설명, 좌측 콘텐츠, 우측 콘텐츠 등을 포함할 수 있으며 다양한 스타일로 커스터마이징할 수 있습니다.

**사용 예시**:

```swift
// 기본 셀
Cell(title: "기본 셀")

// 추가 설명이 있는 셀
Cell(title: "설명이 있는 셀")
    .caption("부가 설명 텍스트")

// 리딩 콘텐츠와 액티브 상태의 셀
Cell(title: "커스텀 셀")
    .leadingContent {
        Image.montage(.user)
            .frame(width: 24, height: 24)
    }
    .active(true)
    .chevron(true)
    .onTap {
        print("셀이 탭되었습니다")
    }
```

> **Note**
>
> Cell은 인터랙션 효과, 구분선, 강조 표시 등 다양한 시각적 요소를 지원합니다.

## Topics 

### Initializers 

- [init(title: String, onTap: (() -> Void)?)](/documentation/montage/cell/init(title:ontap:).md)

  셀 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/cell/body.md)

### Instance Methods 

- [func active(Bool) -> Cell](/documentation/montage/cell/active(_:).md)

  셀을 활성화 상태로 설정합니다.

- [func caption(String?) -> Cell](/documentation/montage/cell/caption(_:).md)

  셀에 부가 설명(캡션)을 추가합니다.

- [func chevron(Bool) -> Cell](/documentation/montage/cell/chevron(_:).md)

  셀 우측에 화살표(chevron) 아이콘을 추가합니다.

- [func disable(Bool) -> Cell](/documentation/montage/cell/disable(_:).md)

  셀의 비활성화 상태를 설정합니다.

- [func divider(Bool) -> Cell](/documentation/montage/cell/divider(_:).md)

  셀 하단에 구분선을 추가합니다.

- [func fillWidth(Bool) -> Cell](/documentation/montage/cell/fillwidth(_:).md)

  셀의 좌우 여백 사용 여부를 설정합니다.

- [func highlight(String) -> Cell](/documentation/montage/cell/highlight(_:).md)

  타이틀의 특정 텍스트를 강조 표시합니다.

- [func interactionPadding(CGFloat) -> Cell](/documentation/montage/cell/interactionpadding(_:).md)

  셀의 인터랙션 효과 영역의 좌우 패딩을 조정합니다.

- [func leadingContent((() -> any View)?) -> Cell](/documentation/montage/cell/leadingcontent(_:).md)

  셀 좌측에 추가 콘텐츠를 표시합니다.

- [func textEllipsis(Bool) -> Cell](/documentation/montage/cell/textellipsis(_:).md)

  타이틀 텍스트의 생략 처리 여부를 설정합니다.

- [func titleColor(Color.Semantic) -> Cell](/documentation/montage/cell/titlecolor(_:).md)

  타이틀 텍스트의 color 속성을 조정합니다.

- [func titleVariant(Typography.Variant) -> Cell](/documentation/montage/cell/titlevariant(_:).md)

  타이틀 텍스트의 variant 속성을 조정합니다.

- [func titleWeight(Typography.Weight) -> Cell](/documentation/montage/cell/titleweight(_:).md)

  타이틀 텍스트의 weight 속성을 조정합니다.

- [func trailingContent(((Bool) -> any View)?) -> Cell](/documentation/montage/cell/trailingcontent(_:).md)

  셀 우측에 추가 콘텐츠를 표시합니다.

- [func verticalAlign(VerticalAlignment) -> Cell](/documentation/montage/cell/verticalalign(_:).md)

  셀 내 콘텐츠의 수직 정렬을 조정합니다.

- [func verticalPadding(VerticalPadding) -> Cell](/documentation/montage/cell/verticalpadding(_:).md)

  상하 여백의 크기를 조정합니다.

### Enumerations 

- [enum VerticalPadding](/documentation/montage/cell/verticalpadding.md)

  상하 여백을 나타내는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

