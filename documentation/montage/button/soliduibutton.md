---
title: Button.SolidUIButton
description: 배경으로 둘러 싸인 곡선 모서리 버튼입니다.
---

```swift
@MainActor class SolidUIButton
```

> **Deprecation**
>
>`Montage.Button.solid()`를 사용하세요.

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


~~``init()``~~

SolidUIButton 객체를 생성합니다.
- **Discussion**

  기본 설정으로 버튼을 초기화합니다.

~~``init?(coder: NSCoder)``~~

### Instance Properties


~~``var backgroundUIColor: UIColor?``~~

커스텀 가능한 배경색 입니다.
- **Discussion**

  `nil`이 아닌 경우, 지정된 색상으로 버튼 배경이 표시됩니다.

~~``var contentUIColor: UIColor?``~~

커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
- **Discussion**

  `nil`이 아닌 경우, 지정된 색상으로 텍스트와 아이콘이 표시됩니다.

~~``var cornerStyle: CornerStyle``~~

버튼의 모서리 곡률을 결정하는 스타일입니다.
- **Discussion**

  기본값은 `.default`입니다.

~~``var disable: Bool``~~

버튼의 활성화 여부입니다.
- **Discussion**

  `true`로 설정 시 버튼이 비활성화되고 시각적으로 비활성 상태로 표시됩니다. 기본값은 `false`입니다.

~~``var handler: (() -> Void)?``~~

버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
- **Discussion**

  버튼이 탭될 때 호출될 클로저입니다.

~~``var iconOnly: Bool``~~

uniqueIcon 노출 여부입니다.
- **Discussion**

  `true`로 설정 시 `text`와 `leadingIcon`, `trailingIcon`은 표현되지 않고 `uniqueIcon`만 표시됩니다. 설정 시 constraint가 업데이트 됩니다.

~~``var intrinsicContentSize: CGSize``~~

Element의 기본적인 사이즈를 정의합니다.
- **Discussion**

  버튼의 내부 콘텐츠와 패딩에 따라 적절한 크기를 계산합니다.

~~``var leadingIcon: Icon?``~~

텍스트의 좌측에 표현될 아이콘입니다.
- **Discussion**

  텍스트가 있는 경우, 텍스트 앞에 나타납니다.

~~``var size: Size``~~

버튼의 사이즈입니다.
- **Discussion**

  기본값은 `.large`입니다.

~~``var state: Interaction.State``~~

사용자와의 인터렉션 상태를 표현합니다.
- **Discussion**

  버튼의 현재 상호작용 상태를 나타냅니다. 기본값은 `.normal`입니다.

~~``var text: String``~~

버튼에서 표현될 텍스트입니다.
- **Discussion**

  버튼에 표시될 문자열을 설정합니다.

~~``var trailingIcon: Icon?``~~

텍스트의 우측에 표현될 아이콘입니다.
- **Discussion**

  텍스트가 있는 경우, 텍스트 뒤에 나타납니다.

~~``var uniqueIcon: Icon?``~~

iconOnly인 경우 표현될 아이콘입니다.
- **Discussion**

  `iconOnly`가 `true`일 경우에만 표시됩니다.

~~``var variant: Variant``~~

버튼의 외관입니다.
- **Discussion**

  기본값은 `.primary`입니다.

### Instance Methods


~~``func layoutSubviews()``~~

~~``func traitCollectionDidChange(UITraitCollection?)``~~

### Enumerations


~~[``enum CornerStyle``](/documentation/montage/button/soliduibutton/cornerstyle-swift.enum.md)~~



버튼 모서리의 곡률 스타일을 결정하는 열거형입니다.

~~[``enum Size``](/documentation/montage/button/soliduibutton/size-swift.enum.md)~~



버튼의 사이즈를 결정하는 열거형입니다.

~~[``enum Variant``](/documentation/montage/button/soliduibutton/variant-swift.enum.md)~~



버튼의 외관을 결정하는 열거형입니다.

### Default Implementations


[UIGestureRecognizerDelegate Implementations](/documentation/montage/button/soliduibutton/uigesturerecognizerdelegate-implementations.md)

## Relationships

Conforms To

`Foundation.NSCoding`

`ObjectiveC.NSObjectProtocol`

`QuartzCore.CALayerDelegate`

`Swift.CVarArg`

`Swift.Copyable`

`Swift.CustomDebugStringConvertible`

`Swift.CustomStringConvertible`

`Swift.Equatable`

`Swift.Hashable`

`Swift.Sendable`

`UIKit.UIAccessibilityIdentification`

`UIKit.UIActivityItemsConfigurationProviding`

`UIKit.UIAppearance`

`UIKit.UIAppearanceContainer`

`UIKit.UICoordinateSpace`

`UIKit.UIDynamicItem`

`UIKit.UIFocusEnvironment`

`UIKit.UIFocusItem`

`UIKit.UIFocusItemContainer`

`UIKit.UIGestureRecognizerDelegate`

`UIKit.UILargeContentViewerItem`

`UIKit.UIPasteConfigurationSupporting`

`UIKit.UIPopoverPresentationControllerSourceItem`

`UIKit.UIResponderStandardEditActions`

`UIKit.UITraitChangeObservable`

`UIKit.UITraitEnvironment`

`UIKit.UIUserActivityRestoring`



