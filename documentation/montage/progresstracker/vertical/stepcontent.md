---
title: ProgressTracker.Vertical.StepContent
description: 수직 진행 추적기의 각 단계에 표시되는 콘텐츠 컴포넌트입니다.
---

```swift
@MainActor struct StepContent
```

## Overview

각 단계의 라벨, 라벨 보조 뷰, 그리고 추가 콘텐츠를 포함할 수 있습니다.

```swift
ProgressTracker.Vertical.StepContent(
    label: "배송 정보",
    labelAccessoryView: { Image(systemName: "info.circle") },
    contentView: { AddressInputView() }
)
```

>  Note
>
> 콘텐츠 뷰를 통해 각 단계에 맞는 복잡한 UI를 표시할 수 있습니다.

## Topics

### Initializers


``init(label: String, labelAccessoryView: (() -> any View)?, contentView: (() -> any View)?)``

단계 콘텐츠를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `label` | 단계의 제목 텍스트 |
  | `labelAccessoryView` | 라벨 옆에 표시할 보조 뷰를 생성하는 클로저 |
  | `contentView` | 라벨 아래에 표시할 추가 콘텐츠 뷰를 생성하는 클로저 |

### Instance Properties


``var body: some View``

### Default Implementations


[View Implementations](/documentation/montage/progresstracker/vertical/stepcontent/view-implementations.md)

[View Implementations](/documentation/montage/progresstracker/vertical/stepcontent/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



