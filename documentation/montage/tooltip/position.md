---
title: Tooltip.Position
description: 툴팁이 표시될 위치를 정의하는 열거형입니다.
---

```swift
enum Position
```

## Overview

툴팁의 방향(상단, 하단, 왼쪽, 오른쪽)과 화살표의 위치를 함께 지정할 수 있습니다.

```swift
// 상단에 표시되고 화살표는 중앙에 위치
.position(.top())

// 왼쪽에 표시되고 화살표는 상단에 위치
.position(.leading(arrowPosition: .top))

// 하단에 표시되고 화살표는 오른쪽에 위치
.position(.bottom(arrowPosition: .trailing))
```

## Topics

### Enumeration Cases


``case bottom(arrowPosition: HorizontalAlignment)``

하단에 툴팁 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `arrowPosition` | 화살표의 수평 위치 (기본값: .center) |

``case leading(arrowPosition: VerticalAlignment)``

왼쪽에 툴팁 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `arrowPosition` | 화살표의 수직 위치 (기본값: .center) |

``case top(arrowPosition: HorizontalAlignment)``

상단에 툴팁 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `arrowPosition` | 화살표의 수평 위치 (기본값: .center) |

``case trailing(arrowPosition: VerticalAlignment)``

오른쪽에 툴팁 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `arrowPosition` | 화살표의 수직 위치 (기본값: .center) |

