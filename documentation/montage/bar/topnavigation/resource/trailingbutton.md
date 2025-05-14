---
1title: trailingbutton
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Bar.TopNavigation.Resource.TrailingButton 

TopNavigation의 우측에 표시될 내용들의 열거형입니다.

```swift
enum TrailingButton
```

## Overview 

아이콘 버튼과 텍스트 버튼을 지원합니다.

**사용 예시**:

```swift
Bar.TopNavigation(
    trailingButtons: [
        .icon(.search) {
            // 검색 동작
        },
        .text("완료") {
            // 완료 동작
        }
    ]
)
```

## Topics 

### Operators 

- [static func == (Bar.TopNavigation.Resource.TrailingButton, Bar.TopNavigation.Resource.TrailingButton) -> Bool](/documentation/montage/bar/topnavigation/resource/trailingbutton/==(_:_:).md)

### Enumeration Cases 

- [case icon(Icon, disable: Bool, showPushBadge: Bool, action: () -> Void)](/documentation/montage/bar/topnavigation/resource/trailingbutton/icon(_:disable:showpushbadge:action:).md)

  icon 형태의 Action입니다.

- [case text(String, disable: Bool, action: () -> Void)](/documentation/montage/bar/topnavigation/resource/trailingbutton/text(_:disable:action:).md)

  text 형태의 Action입니다.

### Instance Methods 

- [func hash(into: inout Hasher)](/documentation/montage/bar/topnavigation/resource/trailingbutton/hash(into:).md)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/bar/topnavigation/resource/trailingbutton/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

