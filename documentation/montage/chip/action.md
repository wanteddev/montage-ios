Structure

# Chip.Action 

액션 칩 컴포넌트입니다.

```swift
@MainActor
struct Action
```

## Overview 

텍스트와 이미지를 포함하는 칩 형태의 버튼입니다. 다양한 크기와 스타일을 지원하며, 탭 이벤트를 처리할 수 있습니다.

**사용 예시**:

```swift
Chip.Action(
    variant: .solid,
    size: .medium,
    text: "액션"
)
.backgroundColor(.semantic(.primary))
.fontColor(.semantic(.staticWhite))
.leadingImage(Image(systemName: "heart"))
```

> **Note**
>
> 기본적으로 8pt의 패딩과 12pt의 모서리 반경을 가집니다.

## Topics 

### Initializers 

- [init(variant: Variant, size: Size, text: String, handler: (() -> Void)?)](/documentation/montage/chip/action/init(variant:size:text:handler:).md)

  액션 칩을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/chip/action/body.md)

- [let handler: (() -> Void)?](/documentation/montage/chip/action/handler.md)

- [let size: Size](/documentation/montage/chip/action/size-swift.property)

- [let text: String](/documentation/montage/chip/action/text.md)

- [let variant: Variant](/documentation/montage/chip/action/variant-swift.property)

### Instance Methods 

- [func active(Bool) -> Chip.Action](/documentation/montage/chip/action/active(_:).md)

  칩의 선택 상태를 설정합니다.

- [func activeColor(SwiftUI.Color) -> Chip.Action](/documentation/montage/chip/action/activecolor(_:).md)

  칩의 활성화 상태 색상을 설정합니다.

- [func backgroundColor(SwiftUI.Color) -> Chip.Action](/documentation/montage/chip/action/backgroundcolor(_:).md)

  칩의 배경색을 설정합니다.

- [func disabled(Bool) -> Chip.Action](/documentation/montage/chip/action/disabled(_:).md)

  칩의 비활성화 여부를 설정합니다.

- [func fontColor(SwiftUI.Color) -> Chip.Action](/documentation/montage/chip/action/fontcolor(_:).md)

  칩의 텍스트 색상을 설정합니다.

- [func imageColor(SwiftUI.Color) -> Chip.Action](/documentation/montage/chip/action/imagecolor(_:).md)

  이미지의 색상을 설정합니다.

- [func leadingImage(Image) -> Chip.Action](/documentation/montage/chip/action/leadingimage(_:).md)

  칩의 좌측에 이미지를 추가합니다.

- [func trailingImage(Image) -> Chip.Action](/documentation/montage/chip/action/trailingimage(_:).md)

  칩의 우측에 이미지를 추가합니다.

### Enumerations 

- [enum Size](/documentation/montage/chip/action/size-swift.enum)

  칩의 크기를 정의합니다.

- [enum Variant](/documentation/montage/chip/action/variant-swift.enum)

  칩의 외관을 결정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

