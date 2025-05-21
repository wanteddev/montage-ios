---
title: CounterPagination.Size
description: 카운터 페이지네이션의 크기를 지정하는 열거형입니다.
---

```swift
enum Size
```

## Overview

UI 디자인 요구사항에 따라 카운터의 크기를 선택할 수 있습니다.

```swift
// 작은 크기의 카운터 페이지네이션
CounterPagination(selectedPage: $currentPage, totalPages: 5)
    .size(.small)
```

## Topics

### Enumeration Cases


``case medium``

중간 크기

``case small``

작은 크기

### Default Implementations


[Equatable Implementations](/documentation/montage/counterpagination/size/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



