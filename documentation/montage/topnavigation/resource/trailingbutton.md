---
title: TopNavigation.Resource.TrailingButton
description: TopNavigation의 우측에 표시될 내용들의 열거형입니다.
---

```swift
enum TrailingButton
```

## Overview

아이콘 버튼과 텍스트 버튼을 지원합니다.

```swift
TopNavigation(
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


``static func == (TopNavigation.Resource.TrailingButton, TopNavigation.Resource.TrailingButton) -> Bool``

### Enumeration Cases


``case icon(Icon, disable: Bool, showPushBadge: Bool, action: () -> Void)``

icon 형태의 Action입니다.
- **Discussion**

``case text(String, disable: Bool, action: () -> Void)``

text 형태의 Action입니다.
- **Discussion**

### Instance Methods


``func hash(into: inout Hasher)``

### Default Implementations


[Equatable Implementations](/documentation/montage/topnavigation/resource/trailingbutton/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



