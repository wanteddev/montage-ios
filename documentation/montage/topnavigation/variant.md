---
title: TopNavigation.Variant
description: TopNavigation의 외관을 결정하는 열거형입니다.
---

```swift
enum Variant
```

## Overview

내비게이션 바의 다양한 레이아웃과 시각적 스타일을 정의합니다.

```swift
TopNavigation(
    variant: .floating(alternative: true, background: true),
    title: "제목"
)
```

## Topics

### Enumeration Cases


``case extended``

확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)

``case floating(alternative: Bool, background: Bool)``

플로팅 스타일의 내비게이션 바

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `alternative` | 대체 색상 사용 여부 |
  | `background` | 배경색 적용 여부 |

``case normal``

기본 내비게이션 바 스타일

### Default Implementations


[Equatable Implementations](/documentation/montage/topnavigation/variant/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



