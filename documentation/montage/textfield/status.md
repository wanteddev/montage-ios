---
title: TextField.Status
description: 텍스트 필드의 상태를 정의합니다.
---

```swift
enum Status
```

## Topics

### Enumeration Cases


``case negative(description: String)``

오류 상태, 선택적으로 오류 설명 텍스트 포함 가능

``case normal(description: String)``

기본 상태, 선택적으로 설명 텍스트 포함 가능

``case positive(description: String)``

유효한 입력 상태, 선택적으로 설명 텍스트 포함 가능

