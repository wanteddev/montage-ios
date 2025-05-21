---
title: IconButton.Variant
description: 버튼의 외관을 결정하는 열거형입니다.
---

```swift
enum Variant
```

## Overview

아이콘 버튼의 다양한 스타일과 크기를 정의합니다.

## Topics

### Enumeration Cases


``case background(size: Int, isAlternative: Bool)``

배경형 아이콘 버튼 - 반투명 배경을 가진 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (픽셀) |
  | `isAlternative` | 대체 스타일 사용 여부 |

``case normal(size: Int)``

기본형 아이콘 버튼 - 배경 없이 아이콘만 표시

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (픽셀) |

``case outlined(size: Size)``

외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (Size 열거형) |

``case solid(size: Size)``

솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (Size 열거형) |

### Type Properties


``static let `default`: IconButton.Variant``

normal(size: 24)의 기본 variant입니다.

