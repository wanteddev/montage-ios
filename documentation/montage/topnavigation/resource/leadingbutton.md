---
title: TopNavigation.Resource.LeadingButton
description: TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
---

```swift
enum LeadingButton
```

## Overview

뒤로가기 버튼, 아이콘 버튼, 텍스트 버튼을 지원합니다.

```swift
TopNavigation(
    leadingButton: .back {
        // 뒤로가기 동작
    }
)
```

## Topics

### Enumeration Cases


``case back(action: () -> Void)``

뒤로가기 버튼
- **Discussion**

``case icon(Icon, action: () -> Void)``

아이콘 버튼
- **Discussion**

``case text(String, action: () -> Void)``

텍스트 버튼
- **Discussion**

