---
title: ActionArea.Variant
description: ActionArea의 버튼 레이아웃 변형을 정의합니다.
---

```swift
enum Variant
```

## Topics

### Enumeration Cases


``case cancel(main: ButtonInfo)``

취소 버튼만 있는 간단한 레이아웃

``case neutral(main: ButtonInfo, sub: ButtonInfo?, alternative: ButtonInfo?)``

중립적인 스타일의 버튼 레이아웃

``case strong(main: ButtonInfo, sub: ButtonInfo?, alternative: ButtonInfo?)``

강조된 주 버튼과 보조/대체 버튼이 있는 레이아웃

