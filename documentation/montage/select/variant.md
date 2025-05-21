---
title: Select.Variant
description: 다중 선택 가능여부를 나타내는 열거형입니다.
---

```swift
enum Variant
```

## Topics

### Enumeration Cases


``case multiple(render: Render, overflow: Bool, menuPrimaryButtonTitle: String)``

다중 선택 모드

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `render` | 선택된 항목 표시 방식 (텍스트 또는 칩), 기본값은 .text |
  | `overflow` | 선택된 항목이 여러 줄로 표시되는지 여부, 기본값은 false |
  | `menuPrimaryButtonTitle` | 확인 버튼 제목 |

``case single(selectionType: SingleSelectionType, menuPrimaryButtonTitle: String?)``

단일 선택 모드

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `selectionType` | 선택 표시 방식 (체크마크 또는 라디오 버튼), 기본값은 .radio |
  | `menuPrimaryButtonTitle` | 확인 버튼 제목 (nil일 경우 버튼 표시 안 함) |

