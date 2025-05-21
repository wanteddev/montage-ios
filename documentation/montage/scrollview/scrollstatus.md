---
title: ScrollView.ScrollStatus
description: 스크롤 뷰의 상태를 추적하는 구조체입니다.
---

```swift
struct ScrollStatus
```

## Overview

스크롤 방향, 스크롤 뷰 크기, 콘텐츠 크기, 오프셋 등의 정보를 포함합니다.

## Topics

### Initializers


``init(axis: Axis, scrollViewSize: CGSize, contentSize: CGSize, contentOffset: CGPoint)``

스크롤 상태를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `axis` | 스크롤 방향 (기본값: .vertical) |
  | `scrollViewSize` | 스크롤 뷰 크기 (기본값: .zero) |
  | `contentSize` | 콘텐츠 크기 (기본값: .zero) |
  | `contentOffset` | 콘텐츠 오프셋 (기본값: .zero) |

### Instance Properties


``var axis: Axis``

``var contentOffset: CGPoint``

``var contentSize: CGSize``

``var scrollViewSize: CGSize``

``var scrolledToMax: Bool``

스크롤이 최대 위치에 도달했는지 여부입니다.

### Default Implementations


[Equatable Implementations](/documentation/montage/scrollview/scrollstatus/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



