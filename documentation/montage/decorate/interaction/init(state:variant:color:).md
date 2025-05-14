---
1title: init(state:variant:color:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(state:variant:color:) 

상호작용 장식 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    state: State = .normal,
    variant: Variant = .normal,
    color: Color.Semantic = .labelNormal
)
```

## Parameters 

state

상호작용 상태, 기본값은 .normal

variant

상호작용 효과 강도, 기본값은 .normal

color

적용할 색상, 기본값은 .labelNormal

## Return Value 

구성된 상호작용 장식 인스턴스

