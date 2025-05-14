---
1title: soliduibutton
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Class

# Button.SolidUIButton `Deprecated`

배경으로 둘러 싸인 곡선 모서리 버튼입니다.

```swift
@MainActor
class SolidUIButton
```

> **Deprecated**
>
> `Montage.Button.solid()`를 사용하세요.

## Overview 

단색 배경과 내부 컨텐츠로 구성된 둥근 모서리 버튼을 제공합니다. 텍스트, 아이콘 또는 둘의 조합을 표시할 수 있으며, 다양한 상호작용 상태에 대응합니다.

```swift
let button = Button.SolidUIButton()
button.text = "확인"
button.variant = .primary
button.size = .medium
button.handler = { print("버튼이 탭되었습니다.") }
```

## Topics 

### Initializers 

- [~~init()~~](/documentation/montage/button/soliduibutton/init().md)

  SolidUIButton 객체를 생성합니다.

- [~~init?(coder: NSCoder)~~](/documentation/montage/button/soliduibutton/init(coder:).md)

### Instance Properties 

- [~~var backgroundUIColor: UIColor?~~](/documentation/montage/button/soliduibutton/backgrounduicolor.md)

  커스텀 가능한 배경색 입니다.

- [~~var contentUIColor: UIColor?~~](/documentation/montage/button/soliduibutton/contentuicolor.md)

  커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.

- [~~var cornerStyle: CornerStyle~~](/documentation/montage/button/soliduibutton/cornerstyle-swift.property)

  버튼의 모서리 곡률을 결정하는 스타일입니다.

- [~~var disable: Bool~~](/documentation/montage/button/soliduibutton/disable.md)

  버튼의 활성화 여부입니다.

- [~~var handler: (() -> Void)?~~](/documentation/montage/button/soliduibutton/handler.md)

  버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.

- [~~var iconOnly: Bool~~](/documentation/montage/button/soliduibutton/icononly.md)

  uniqueIcon 노출 여부입니다.

- [~~var intrinsicContentSize: CGSize~~](/documentation/montage/button/soliduibutton/intrinsiccontentsize.md)

  Element의 기본적인 사이즈를 정의합니다.

- [~~var leadingIcon: Icon?~~](/documentation/montage/button/soliduibutton/leadingicon.md)

  텍스트의 좌측에 표현될 아이콘입니다.

- [~~var size: Size~~](/documentation/montage/button/soliduibutton/size-swift.property)

  버튼의 사이즈입니다.

- [~~var state: Decorate.Interaction.State~~](/documentation/montage/button/soliduibutton/state.md)

  사용자와의 인터렉션 상태를 표현합니다.

- [~~var text: String~~](/documentation/montage/button/soliduibutton/text.md)

  버튼에서 표현될 텍스트입니다.

- [~~var trailingIcon: Icon?~~](/documentation/montage/button/soliduibutton/trailingicon.md)

  텍스트의 우측에 표현될 아이콘입니다.

- [~~var uniqueIcon: Icon?~~](/documentation/montage/button/soliduibutton/uniqueicon.md)

  iconOnly인 경우 표현될 아이콘입니다.

- [~~var variant: Variant~~](/documentation/montage/button/soliduibutton/variant-swift.property)

  버튼의 외관입니다.

### Instance Methods 

- [~~func layoutSubviews()~~](/documentation/montage/button/soliduibutton/layoutsubviews().md)

- [~~func traitCollectionDidChange(UITraitCollection?)~~](/documentation/montage/button/soliduibutton/traitcollectiondidchange(_:).md)

### Enumerations 

- [~~enum CornerStyle~~](/documentation/montage/button/soliduibutton/cornerstyle-swift.enum)

  버튼 모서리의 곡률 스타일을 결정하는 열거형입니다.

- [~~enum Size~~](/documentation/montage/button/soliduibutton/size-swift.enum)

  버튼의 사이즈를 결정하는 열거형입니다.

- [~~enum Variant~~](/documentation/montage/button/soliduibutton/variant-swift.enum)

  버튼의 외관을 결정하는 열거형입니다.

### Default Implementations 

- [API ReferenceUIGestureRecognizerDelegate Implementations](/documentation/montage/button/soliduibutton/uigesturerecognizerdelegate-implementations.md)

## Relationships 

### Inherits From 

- UIKit.UIView

### Conforms To 

- Foundation.NSCoding
- ObjectiveC.NSObjectProtocol
- QuartzCore.CALayerDelegate
- Swift.CVarArg
- Swift.Copyable
- Swift.CustomDebugStringConvertible
- Swift.CustomStringConvertible
- Swift.Equatable
- Swift.Hashable
- Swift.Sendable
- UIKit.UIAccessibilityIdentification
- UIKit.UIActivityItemsConfigurationProviding
- UIKit.UIAppearance
- UIKit.UIAppearanceContainer
- UIKit.UICoordinateSpace
- UIKit.UIDynamicItem
- UIKit.UIFocusEnvironment
- UIKit.UIFocusItem
- UIKit.UIFocusItemContainer
- UIKit.UIGestureRecognizerDelegate
- UIKit.UILargeContentViewerItem
- UIKit.UIPasteConfigurationSupporting
- UIKit.UIPopoverPresentationControllerSourceItem
- UIKit.UIResponderStandardEditActions
- UIKit.UITraitChangeObservable
- UIKit.UITraitEnvironment
- UIKit.UIUserActivityRestoring

