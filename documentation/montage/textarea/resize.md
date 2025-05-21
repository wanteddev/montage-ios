---
title: TextArea.Resize
description: 텍스트 영역의 크기 조절 방식을 정의합니다.
---

```swift
enum Resize
```

## Topics

### Enumeration Cases


``case fixed(min: CGFloat, max: CGFloat)``

텍스트 영역의 최소 및 최대 높이를 지정합니다. 초과 부분은 스크롤할 수 있습니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `min` | 최소 높이 |
  | `max` | 최대 높이 |

``case limit``

최대 8줄까지 표시되며, 초과 부분은 스크롤할 수 있습니다.

``case normal``

줄 수 제한이 없으며, 입력된 텍스트에 따라 영역이 자동으로 확장됩니다.

