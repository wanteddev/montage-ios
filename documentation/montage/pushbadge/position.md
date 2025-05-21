---
title: PushBadge.Position
description: 뱃지의 위치를 정의하는 열거형입니다.
---

```swift
enum Position
```

## Overview

수직 위치(top, center, bottom)와 수평 위치(leading, center, trailing)를 함께 지정할 수 있습니다.

```swift
// 우측 상단에 위치
.modifier(PushBadge.Modifier(position: .top(.trailing)))

// 좌측 하단에 위치
.modifier(PushBadge.Modifier(position: .bottom(.leading)))
```

## Topics

### Enumeration Cases


``case bottom(HorizontalPosition)``

하단 위치

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `horizontalPosition` | 수평 위치 (기본값: center) |

``case center(HorizontalPosition)``

중앙 위치

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `horizontalPosition` | 수평 위치 (기본값: center) |

``case top(HorizontalPosition)``

상단 위치

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `horizontalPosition` | 수평 위치 (기본값: center) |

### Enumerations


[``enum HorizontalPosition``](/documentation/montage/pushbadge/position/horizontalposition.md)

수평 위치를 정의하는 열거형입니다.

