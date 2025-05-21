---
title: InteractionUIView
description: 사용자 상호작용 상태를 시각적으로 표현하는 UIKit 기반 장식 뷰입니다.
---

```swift
@MainActor final class InteractionUIView
```

> **Deprecation**
>
>이 클래스는 더 이상 사용되지 않으며 향후 버전에서 제거될 예정입니다. 대신 SwiftUI 기반의 InteractionView를 사용하세요.

## Overview

이 클래스는 UIKit 환경에서 버튼, 카드 등의 UI 요소에 호버, 포커스, 누름 등의 상호작용 상태를 시각적으로 표현할 때 사용합니다. 상태, 색상, 변형에 따라 다양한 불투명도를 적용하여 사용자에게 시각적 피드백을 제공합니다.

```swift
// 기본 상호작용 장식 뷰
let interactionView = InteractionUIView()
containerView.addSubview(interactionView)

// 눌림 상태의 강조된 상호작용 장식 뷰
let interactionView = InteractionUIView(
    state: .pressed,
    color: .primaryNormal,
    variant: .strong
)
```

>  Note
>
> 뷰는 자동으로 사용자 상호작용을 비활성화합니다(`isUserInteractionEnabled = false`).

## Topics

### Initializers


~~``init?(coder: NSCoder)``~~

인터페이스 빌더에서 사용할 때 호출되는 초기화 메서드입니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `coder` | 디코더 객체 |
- **Return Value**

  디코딩된 상호작용 장식 뷰 인스턴스, 실패 시 nil

~~``init(state: Interaction.State, color: Color.Semantic, variant: Interaction.Variant)``~~

상호작용 장식 뷰를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `state` | 상호작용 상태, 기본값은 `.normal` |
  | `color` | 적용할 색상, 기본값은 `.labelNormal` |
  | `variant` | 상호작용 효과 강도, 기본값은 `.normal` |
- **Return Value**

  구성된 상호작용 장식 뷰 인스턴스

### Instance Properties


~~``var color: Color.Semantic``~~

상호작용 뷰에 적용할 색상입니다.
- **Discussion**

  값이 변경되면 뷰가 자동으로 업데이트됩니다.

~~``var state: Interaction.State``~~

상호작용 뷰의 현재 상태입니다.
- **Discussion**

  값이 변경되면 뷰가 자동으로 업데이트됩니다.

~~``var variant: Interaction.Variant``~~

상호작용 효과의 강도를 정의합니다.
- **Discussion**

  값이 변경되면 뷰가 자동으로 업데이트됩니다.

## Relationships

Conforms To

`Foundation.NSCoding`

`ObjectiveC.NSObjectProtocol`

`QuartzCore.CALayerDelegate`

`Swift.CVarArg`

`Swift.CustomDebugStringConvertible`

`Swift.CustomStringConvertible`

`Swift.Equatable`

`Swift.Hashable`

`UIKit.UIAccessibilityIdentification`

`UIKit.UIActivityItemsConfigurationProviding`

`UIKit.UIAppearance`

`UIKit.UIAppearanceContainer`

`UIKit.UICoordinateSpace`

`UIKit.UIDynamicItem`

`UIKit.UIFocusEnvironment`

`UIKit.UIFocusItem`

`UIKit.UIFocusItemContainer`

`UIKit.UILargeContentViewerItem`

`UIKit.UIPasteConfigurationSupporting`

`UIKit.UIPopoverPresentationControllerSourceItem`

`UIKit.UIResponderStandardEditActions`

`UIKit.UITraitChangeObservable`

`UIKit.UITraitEnvironment`

`UIKit.UIUserActivityRestoring`



