---
1title: colorstyle
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# ContentBadge.ColorStyle 

뱃지의 색상을 결정하는 열거형입니다.

```swift
enum ColorStyle
```

## Overview 

- neutral: 중립적인 회색 계열 뱃지
- accent: 강조 색상을 사용하는 뱃지

**사용 예시**:

```swift
ContentBadge(text: "이벤트")
    .colorStyle(.accent(SwiftUI.Color.red))
```

## Topics 

### Enumeration Cases 

- [case accent(SwiftUI.Color, background: SwiftUI.Color?)](/documentation/montage/contentbadge/colorstyle/accent(_:background:).md)

  강조 색상 뱃지

- [case neutral(SwiftUI.Color?)](/documentation/montage/contentbadge/colorstyle/neutral(_:).md)

  중립 색상 뱃지

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/contentbadge/colorstyle/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

