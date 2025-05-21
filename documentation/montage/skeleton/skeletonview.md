---
title: Skeleton.SkeletonView
description: 스켈레톤 로딩 UI를 표시하는 뷰입니다.
---

```swift
@MainActor struct SkeletonView
```

## Overview

지정된 형태(텍스트, 사각형, 원형)에 따라 적절한 스켈레톤 UI를 렌더링합니다. 색상, 투명도 등을 커스터마이징할 수 있습니다.

```swift
Skeleton.SkeletonView(.text(lineNumber: 3))
    .color(.gray)
    .opacity(0.8)
```

## Topics

### Initializers


``init(Kind)``

스켈레톤 뷰를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `kind` | 표시할 스켈레톤의 종류 |

### Instance Properties


``var body: some View``

### Instance Methods


``func color(SwiftUI.Color) -> Skeleton.SkeletonView``

스켈레톤 뷰의 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 적용할 색상 |
- **Return Value**

  수정된 SkeletonView 인스턴스

``func opacity(CGFloat) -> Skeleton.SkeletonView``

스켈레톤 뷰의 투명도를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `opacity` | 적용할 투명도 (0.0 ~ 1.0) |
- **Return Value**

  수정된 SkeletonView 인스턴스

### Default Implementations


[View Implementations](/documentation/montage/skeleton/skeletonview/view-implementations.md)

[View Implementations](/documentation/montage/skeleton/skeletonview/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



