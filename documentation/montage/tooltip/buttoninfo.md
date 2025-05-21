---
title: Tooltip.ButtonInfo
description: 툴팁에 표시되는 버튼의 정보를 정의하는 구조체입니다.
---

```swift
struct ButtonInfo
```

## Overview

툴팁 내용 아래에 표시되는 버튼의 제목과 동작을 정의합니다.

```swift
Tooltip.ButtonInfo(
    title: "더 알아보기",
    action: {
        // 상세 정보 페이지로 이동
    }
)
```

## Topics

### Initializers


``init(title: String, action: () -> Void)``

ButtonInfo를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `title` | 버튼에 표시될 텍스트 |
  | `action` | 버튼 클릭 시 실행될 동작 |

### Instance Properties


``let action: () -> Void``

``let title: String``

