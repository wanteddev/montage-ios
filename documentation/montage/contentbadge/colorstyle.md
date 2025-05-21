---
title: ContentBadge.ColorStyle
description: 뱃지의 색상을 결정하는 열거형입니다.
---

```swift
enum ColorStyle
```

## Overview

```swift
ContentBadge(text: "이벤트")
    .colorStyle(.accent(SwiftUI.Color.red))
```

## Topics

### Enumeration Cases


``case accent(SwiftUI.Color, background: SwiftUI.Color?)``

강조 색상 뱃지

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contentColor` | 콘텐츠 색상 |
  | `background` | 배경 색상 (nil일 경우 contentColor의 투명도를 조절하여 사용) |

``case neutral(SwiftUI.Color?)``

중립 색상 뱃지

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contentColor` | 콘텐츠 색상 (nil일 경우 기본 색상 사용) |

### Default Implementations


[Equatable Implementations](/documentation/montage/contentbadge/colorstyle/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



