---
title: Elevation
description: 높낮이의 차이를 표현하기 위한 그림자 효과
---

```swift
enum Elevation
```

## Overview

Elevation은 UI 요소의 시각적 깊이와 높이를 표현하기 위한 그림자 효과를 정의합니다. 여러 단계의 그림자를 통해 요소 간의 계층 구조와 중요도를 시각적으로 나타냅니다.

```swift
// UIKit에서 사용
let cardView = UIView()
cardView.setElevation(.shadowNormal)

// SwiftUI에서 사용
Text("Hello, World!")
    .elevation(.shadowEmphasize)
```

>  Note
>
> `UIView.setElevation(_:)`을 사용하여 레이어에 그림자를 적용할 수 있습니다. 중첩된 뷰에 그림자를 적용할 경우 성능에 영향을 줄 수 있으므로 주의해야 합니다.

## Topics

### Enumeration Cases


``case none``

그림자 없음

``case shadowEmphasize``

강조된 수준의 그림자

``case shadowHeavy``

가장 강한 수준의 그림자

``case shadowNormal``

일반적인 수준의 그림자

``case shadowStrong``

강한 수준의 그림자

### Default Implementations


[Equatable Implementations](/documentation/montage/elevation/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



