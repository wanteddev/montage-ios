---
title: Interaction
description: 사용자 상호작용 상태를 시각적으로 표현하는 장식 컴포넌트입니다.
---

```swift
@MainActor struct Interaction
```

## Overview

이 컴포넌트는 버튼, 카드 등의 UI 요소에 호버, 포커스, 누름 등의 상호작용 상태를 시각적으로 표현할 때 사용합니다. 상태와 변형에 따라 다양한 불투명도를 적용하여 사용자에게 시각적 피드백을 제공합니다.

```swift
// 기본 상호작용 장식
Interaction()

// 눌림 상태의 강조된 상호작용 장식
Interaction(
    state: .pressed,
    variant: .strong,
    color: .primaryNormal
)
```

## Topics

### Initializers


``init(state: State, variant: Variant, color: Color.Semantic)``

상호작용 장식 컴포넌트를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 상호작용 상태, 기본값은 `.normal` |
  | `variant` | 상호작용 효과 강도, 기본값은 `.normal` |
  | `color` | 적용할 색상, 기본값은 `.labelNormal` |
- **Return Value**

  구성된 상호작용 장식 인스턴스

### Instance Properties


``var body: some View``

### Enumerations


[``enum State``](/documentation/montage/interaction/state.md)

상호작용의 상태를 정의합니다.

[``enum Variant``](/documentation/montage/interaction/variant.md)

상호작용 효과의 강도를 정의합니다.

### Default Implementations


[View Implementations](/documentation/montage/interaction/view-implementations.md)

[View Implementations](/documentation/montage/interaction/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



