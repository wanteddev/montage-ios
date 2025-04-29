Initializer

# init(state:color:variant:) `Deprecated`

상호작용 장식 뷰를 초기화합니다.

```swift
@MainActor
init(
    state: Interaction.State = .normal,
    color: Color.Semantic = .labelNormal,
    variant: Interaction.Variant = .normal
)
```

> **Deprecated**
>
> 이 클래스는 더 이상 사용되지 않으며 향후 버전에서 제거될 예정입니다. 대신 SwiftUI 기반의 InteractionView를 사용하세요.

## Parameters 

state

상호작용 상태, 기본값은 .normal

color

적용할 색상, 기본값은 .labelNormal

variant

상호작용 효과 강도, 기본값은 .normal

## Return Value 

구성된 상호작용 장식 뷰 인스턴스

