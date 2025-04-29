Class

# Decorate.InteractionUIView `Deprecated`

**Deprecated**

```swift
@MainActor
final class InteractionUIView
```

> **Deprecated**
>
> 이 클래스는 더 이상 사용되지 않으며 향후 버전에서 제거될 예정입니다. 대신 SwiftUI 기반의 InteractionView를 사용하세요.

## Overview 

사용자 상호작용 상태를 시각적으로 표현하는 UIKit 기반 장식 뷰입니다.

이 클래스는 UIKit 환경에서 버튼, 카드 등의 UI 요소에 호버, 포커스, 누름 등의 상호작용 상태를 시각적으로 표현할 때 사용합니다. 상태, 색상, 변형에 따라 다양한 불투명도를 적용하여 사용자에게 시각적 피드백을 제공합니다.

## 사용 예시 

```swift
// 기본 상호작용 장식 뷰
let interactionView = Decorate.InteractionUIView()
containerView.addSubview(interactionView)

// 눌림 상태의 강조된 상호작용 장식 뷰
let interactionView = Decorate.InteractionUIView(
    state: .pressed,
    color: .primaryNormal,
    variant: .strong
)
```

> **Note**
>
> 뷰는 자동으로 사용자 상호작용을 비활성화합니다(isUserInteractionEnabled = false).

> **Warning**
>
> 이 클래스는 더 이상 사용되지 않으며 향후 버전에서 제거될 예정입니다. 대신 SwiftUI 기반의 InteractionView를 사용하세요.

## Topics 

### Initializers 

- [~~init?(coder: NSCoder)~~](/documentation/montage/decorate/interactionuiview/init(coder:).md)

  인터페이스 빌더에서 사용할 때 호출되는 초기화 메서드입니다.

- [~~init(state: Interaction.State, color: Color.Semantic, variant: Interaction.Variant)~~](/documentation/montage/decorate/interactionuiview/init(state:color:variant:).md)

  상호작용 장식 뷰를 초기화합니다.

### Instance Properties 

- [~~var color: Color.Semantic~~](/documentation/montage/decorate/interactionuiview/color.md)

  상호작용 뷰에 적용할 색상입니다.

- [~~var state: Interaction.State~~](/documentation/montage/decorate/interactionuiview/state.md)

  상호작용 뷰의 현재 상태입니다.

- [~~var variant: Interaction.Variant~~](/documentation/montage/decorate/interactionuiview/variant.md)

  상호작용 효과의 강도를 정의합니다.

## Relationships 

### Inherits From 

- UIKit.UIView

### Conforms To 

- Foundation.NSCoding
- ObjectiveC.NSObjectProtocol
- QuartzCore.CALayerDelegate
- Swift.CVarArg
- Swift.CustomDebugStringConvertible
- Swift.CustomStringConvertible
- Swift.Equatable
- Swift.Hashable
- UIKit.UIAccessibilityIdentification
- UIKit.UIActivityItemsConfigurationProviding
- UIKit.UIAppearance
- UIKit.UIAppearanceContainer
- UIKit.UICoordinateSpace
- UIKit.UIDynamicItem
- UIKit.UIFocusEnvironment
- UIKit.UIFocusItem
- UIKit.UIFocusItemContainer
- UIKit.UILargeContentViewerItem
- UIKit.UIPasteConfigurationSupporting
- UIKit.UIPopoverPresentationControllerSourceItem
- UIKit.UIResponderStandardEditActions
- UIKit.UITraitChangeObservable
- UIKit.UITraitEnvironment
- UIKit.UIUserActivityRestoring

