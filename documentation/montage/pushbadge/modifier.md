---
1title: modifier
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# PushBadge.Modifier 

다른 뷰에 PushBadge를 적용하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct Modifier
```

## Overview 

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

## Topics 

### Initializers 

- [init(variant: Variant, size: Size, fontColor: SwiftUI.Color, backgroundColor: SwiftUI.Color, position: Position, inset: CGSize)](/documentation/montage/pushbadge/modifier/init(variant:size:fontcolor:backgroundcolor:position:inset:).md)

  PushBadge 모디파이어를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/pushbadge/modifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/pushbadge/modifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

