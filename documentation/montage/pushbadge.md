---
1title: pushbadge
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# PushBadge 

푸시 알림이나 알림 표시를 위한 뱃지 컴포넌트입니다.

```swift
@MainActor
struct PushBadge
```

## Overview 

작은 점, ‘N’ 표시, 또는 숫자를 표시할 수 있으며 다양한 크기와 위치를 지원합니다. 주로 아이콘이나 버튼 주변에 새로운 알림이나 메시지가 있음을 나타내기 위해 사용됩니다.

**사용 예시**:

```swift
// 기본 점 형태 뱃지
PushBadge(variant: .dot)

// 'N' 표시 뱃지
PushBadge(variant: .new)
    .size(.small)

// 숫자 표시 뱃지
PushBadge(variant: .number(5))
    .backgroundColor(.red)
```

> **See Also**
>
> PushBadge.Modifier, PushBadge.Variant, PushBadge.Size, PushBadge.Position

## Topics 

### Structures 

- [struct Modifier](/documentation/montage/pushbadge/modifier.md)

  다른 뷰에 PushBadge를 적용하기 위한 뷰 모디파이어입니다.

### Initializers 

- [init(variant: Variant)](/documentation/montage/pushbadge/init(variant:).md)

  PushBadge를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/pushbadge/body.md)

### Instance Methods 

- [func backgroundColor(SwiftUI.Color) -> PushBadge](/documentation/montage/pushbadge/backgroundcolor(_:).md)

  배경 색상을 설정합니다.

- [func fontColor(SwiftUI.Color) -> PushBadge](/documentation/montage/pushbadge/fontcolor(_:).md)

  텍스트 색상을 설정합니다.

- [func size(Size) -> PushBadge](/documentation/montage/pushbadge/size(_:).md)

  뱃지의 크기를 설정합니다.

### Enumerations 

- [enum Position](/documentation/montage/pushbadge/position.md)

  뱃지의 위치를 정의하는 열거형입니다.

- [enum Size](/documentation/montage/pushbadge/size.md)

  뱃지의 크기를 정의하는 열거형입니다.

- [enum Variant](/documentation/montage/pushbadge/variant.md)

  뱃지의 표시 형태를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

