---
title: Cell.VerticalPadding
description: 상하 여백을 나타내는 열거형입니다.
---

```swift
enum VerticalPadding
```

## Overview

셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.

```swift
Cell(title: "넓은 여백이 있는 셀")
    .verticalPadding(.large)
```

## Topics

### Enumeration Cases


``case large``

큰 여백 (16pt)

``case medium``

중간 여백 (12pt)

``case none``

여백 없음 (0pt)

``case small``

작은 여백 (8pt)

### Instance Properties


``var length: CGFloat``

여백 값을 포인트 단위로 반환합니다.
- **Return Value**

  선택한 여백 케이스에 해당하는 CGFloat 값

### Default Implementations


[Equatable Implementations](/documentation/montage/cell/verticalpadding/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



