---
title: Menu.Item
description: 메뉴 항목의 데이터를 정의하는 구조체입니다.
---

```swift
struct Item
```

## Overview

제목과 선택 상태를 포함합니다.

```swift
Menu.Item(title: "메뉴 항목", isSelected: false)
```

## Topics

### Initializers


``init(title: String, isSelected: Bool)``

메뉴 항목을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `title` | 메뉴 항목에 표시될 텍스트 |
  | `isSelected` | 초기 선택 상태 (기본값: false) |

### Instance Properties


``var isSelected: Bool``

``let title: String``

### Default Implementations


[Equatable Implementations](/documentation/montage/menu/item/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



