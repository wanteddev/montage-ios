---
1title: interaction
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Decorate.Interaction 

사용자 상호작용 상태를 시각적으로 표현하는 장식 컴포넌트입니다.

```swift
@MainActor
struct Interaction
```

## Overview 

이 컴포넌트는 버튼, 카드 등의 UI 요소에 호버, 포커스, 누름 등의 상호작용 상태를 시각적으로 표현할 때 사용합니다. 상태와 변형에 따라 다양한 불투명도를 적용하여 사용자에게 시각적 피드백을 제공합니다.

## 사용 예시 

```swift
// 기본 상호작용 장식
Decorate.Interaction()

// 눌림 상태의 강조된 상호작용 장식
Decorate.Interaction(
    state: .pressed,
    variant: .strong,
    color: .primaryNormal
)
```

## Topics 

### Initializers 

- [init(state: State, variant: Variant, color: Color.Semantic)](/documentation/montage/decorate/interaction/init(state:variant:color:).md)

  상호작용 장식 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/decorate/interaction/body.md)

### Enumerations 

- [enum State](/documentation/montage/decorate/interaction/state.md)

  상호작용의 상태를 정의합니다.

- [enum Variant](/documentation/montage/decorate/interaction/variant.md)

  상호작용 효과의 강도를 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

