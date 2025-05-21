---
title: Loading
description: 로딩 상태를 표시하기 위한 애니메이션 컴포넌트입니다.
---

```swift
@MainActor struct Loading
```

## Overview

`Loading`은 다양한 종류와 크기의 로딩 애니메이션을 제공합니다. Lottie 애니메이션을 사용하여 시각적으로 매력적인 로딩 인디케이터를 표시하며, 색상 및 크기를 커스터마이징할 수 있습니다.

```swift
// 기본 원형 로딩 애니메이션 사용
Loading(kind: .circular)

// 특정 크기와 색상의 Wanted 로딩 애니메이션 사용
Loading(kind: .wanted, size: CGSize(width: 100, height: 100))
    .foregroundColor(.blue)

// 로딩 오버레이로 적용
someView
    .loading(isLoading: $isLoadingState, type: .circular)
```

>  Note
>
> 다크 모드와 라이트 모드에 따라 자동으로 적절한 애니메이션 리소스를 선택합니다.

## Topics

### Initializers


``init(kind: Kind, size: CGSize?)``

Loading 컴포넌트를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `kind` | 로딩 애니메이션의 종류 (.wanted 또는 .circular) |
  | `size` | 로딩 애니메이션의 크기 (nil일 경우 기본 크기 사용) |

### Instance Properties


``var body: some View``

### Instance Methods


``func foregroundColor(SwiftUI.Color?) -> Loading``

로딩 애니메이션의 전경색을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 적용할 색상 |
- **Return Value**

  수정된 Loading 인스턴스

### Enumerations


[``enum Kind``](/documentation/montage/loading/kind.md)

로딩 애니메이션의 종류를 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/loading/view-implementations.md)

[View Implementations](/documentation/montage/loading/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



