---
title: BottomSheetModal.Resize
description: 바텀 시트의 크기를 정의하는 열거형입니다.
---

```swift
enum Resize
```

## Topics

### Enumeration Cases


``case fill``

화면 전체를 채웁니다.

``case fixedHeight(CGFloat)``

지정한 높이로 고정됩니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `height` | 높이 |

``case fixedRatio(CGFloat)``

화면 높이의 특정 비율로 고정됩니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `ratio` | 비율 (0.0 ~ 1.0) |

``case flexible``

사용자가 드래그하여 크기를 조절할 수 있습니다.

``case hug``

컨텐츠 크기에 맞게 자동 조절됩니다.

