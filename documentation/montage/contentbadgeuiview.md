Class

# ContentBadgeUIView `Deprecated`

컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다.

```swift
@MainActor
class ContentBadgeUIView
```

> **Deprecated**
>
> `Montage.ContentBadge`를 사용하세요.

## Overview 

이 컴포넌트는 다양한 스타일과 크기를 지원하며, 텍스트와 함께 아이콘을 표시할 수 있습니다.

## 개요 

ContentBadgeUIView는 카테고리나 상태를 시각적으로 표현하기 위한 UI 컴포넌트입니다. Solid 또는 Outline 스타일로 표현할 수 있으며, 다양한 크기와 색상을 지원합니다.

> **Warning**
>
> 이 클래스는 더 이상 사용되지 않으며, 대신 Montage.ContentBadge를 사용하세요.

> **See Also**
>
> ContentBadge

## 사용 예시 

```swift
// 기본 사용법
let badge = ContentBadgeUIView()
badge.text = "카테고리"
badge.variant = .solid
badge.size = .small
badge.colorStyle = .neutral()

// 아이콘 추가
badge.leadingIcon = UIImage(named: "icon-category")

// 커스텀 색상 적용
badge.colorStyle = .accent(.blue, nil)
```

## Topics 

### Initializers 

- [~~init()~~](/documentation/montage/contentbadgeuiview/init().md)

  기본 초기화 메서드입니다.

- [~~init?(coder: NSCoder)~~](/documentation/montage/contentbadgeuiview/init(coder:).md)

  Interface Builder와 함께 사용할 때 호출되는 초기화 메서드입니다.

### Instance Properties 

- [~~var colorStyle: ContentBadge.ColorStyle~~](/documentation/montage/contentbadgeuiview/colorstyle.md)

  뱃지에 적용될 색상 스타일입니다.

- [~~var intrinsicContentSize: CGSize~~](/documentation/montage/contentbadgeuiview/intrinsiccontentsize.md)

  뱃지의 기본 크기를 계산하여 반환합니다.

- [~~var leadingIcon: UIImage?~~](/documentation/montage/contentbadgeuiview/leadingicon.md)

  텍스트의 좌측에 표시될 아이콘입니다.

- [~~var size: ContentBadge.Size~~](/documentation/montage/contentbadgeuiview/size.md)

  뱃지의 크기입니다.

- [~~var text: String~~](/documentation/montage/contentbadgeuiview/text.md)

  뱃지에 표시될 텍스트입니다.

- [~~var trailingIcon: UIImage?~~](/documentation/montage/contentbadgeuiview/trailingicon.md)

  텍스트의 우측에 표시될 아이콘입니다.

- [~~var variant: ContentBadge.Variant~~](/documentation/montage/contentbadgeuiview/variant.md)

  뱃지의 외관 스타일입니다.

### Instance Methods 

- [~~func layoutSubviews()~~](/documentation/montage/contentbadgeuiview/layoutsubviews().md)

  하위 뷰의 레이아웃이 변경될 때 호출되는 메서드입니다.

- [~~func traitCollectionDidChange(UITraitCollection?)~~](/documentation/montage/contentbadgeuiview/traitcollectiondidchange(_:).md)

  트레이트 컬렉션이 변경될 때 호출되는 메서드입니다.

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
- UIKit.UILargeContentViewerItem
- UIKit.UIPasteConfigurationSupporting
- UIKit.UIPopoverPresentationControllerSourceItem
- UIKit.UIResponderStandardEditActions
- UIKit.UITraitChangeObservable
- UIKit.UITraitEnvironment
- UIKit.UIUserActivityRestoring

