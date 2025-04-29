Structure

# Accordion 

접을 수 있는 컨텐츠를 제공하는 아코디언 컴포넌트입니다.

```swift
@MainActor
struct Accordion
```

## Overview 

Accordion은 제목과 함께 접을 수 있는 컨텐츠를 제공하는 컴포넌트입니다. 제목을 탭하면 컨텐츠가 확장되거나 축소됩니다. 설명 텍스트와 커스텀 컨텐츠를 함께 표시할 수 있습니다.

## 개요 

아코디언은 제한된 공간에서 많은 정보를 효율적으로 표시하기 위한 UI 패턴입니다. 사용자는 관심 있는 항목만 확장하여 볼 수 있습니다.

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

> **Note**
>
> 아코디언은 기본적으로 하단에 구분선을 갖고 있으며, hideDivider() 수정자를 통해 제거할 수 있습니다.

> **See Also**
>
> Accordion.VerticalPadding

## Topics 

### Initializers 

- [init(title: String, description: String?, content: (() -> any View)?)](/documentation/montage/accordion/init(title:description:content:).md)

  아코디언을 생성합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/accordion/body.md)

### Instance Methods 

- [func description(Typography.Variant, weight: Typography.Weight, color: SwiftUI.Color) -> Accordion](/documentation/montage/accordion/description(_:weight:color:).md)

  설명 텍스트의 타이포그래피 속성을 조정합니다.

- [func fillWidth(Bool) -> Accordion](/documentation/montage/accordion/fillwidth(_:).md)

  아코디언이 부모 컨테이너의 너비를 채우도록 설정합니다.

- [func hideDivider(Bool) -> Accordion](/documentation/montage/accordion/hidedivider(_:).md)

  아코디언 하단의 구분선을 숨깁니다.

- [func leadingIcon(Icon?, color: SwiftUI.Color?) -> Accordion](/documentation/montage/accordion/leadingicon(_:color:).md)

  아코디언 제목 앞에 아이콘을 추가합니다.

- [func title(Typography.Variant, weight: Typography.Weight, color: SwiftUI.Color) -> Accordion](/documentation/montage/accordion/title(_:weight:color:).md)

  타이틀 텍스트의 타이포그래피 속성을 조정합니다.

- [func trailingContent((() -> any View)?) -> Accordion](/documentation/montage/accordion/trailingcontent(_:).md)

  아코디언 헤더 우측에 커스텀 컨텐츠를 추가합니다.

- [func verticalPadding(VerticalPadding) -> Accordion](/documentation/montage/accordion/verticalpadding(_:).md)

  아코디언 헤더의 상하 여백 크기를 조정합니다.

### Enumerations 

- [enum VerticalPadding](/documentation/montage/accordion/verticalpadding.md)

  아코디언의 상하 여백을 나타내는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

