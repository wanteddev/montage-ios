---
title: ContentBadgeUIView
description: 컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다.
---

```swift
@MainActor final class ContentBadgeUIView
```

> **Deprecation**
>
>`Montage.ContentBadge`를 사용하세요.

## Overview

이 컴포넌트는 다양한 스타일과 크기를 지원하며, 텍스트와 함께 아이콘을 표시할 수 있습니다.

`ContentBadgeUIView`는 카테고리나 상태를 시각적으로 표현하기 위한 UI 컴포넌트입니다. Solid 또는 Outline 스타일로 표현할 수 있으며, 다양한 크기와 색상을 지원합니다.

>  See Also
>
> [ContentBadge](/documentation/montage/contentbadge.md)

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


~~``init()``~~

기본 초기화 메서드입니다.
- **Discussion**

  이 메서드는 프레임을 `.zero`로 초기화하고 기본 UI 요소를 설정합니다.

~~``init?(coder: NSCoder)``~~

Interface Builder와 함께 사용할 때 호출되는 초기화 메서드입니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `coder` | 디코더 객체 |

### Instance Properties


~~``var colorStyle: ContentBadge.ColorStyle``~~

뱃지에 적용될 색상 스타일입니다.
- **Discussion**
  >  See Also
  >
  > `ContentBadge.ColorStyle`


~~``var intrinsicContentSize: CGSize``~~

뱃지의 기본 크기를 계산하여 반환합니다.
- **Return Value**

  계산된 뱃지의 크기
- **Discussion**

  이 메서드는 텍스트 크기, 아이콘 크기, 여백을 고려하여 최적의 크기를 계산합니다.

~~``var leadingIcon: UIImage?``~~

텍스트의 좌측에 표시될 아이콘입니다.
- **Discussion**

  아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.

~~``var size: ContentBadge.Size``~~

뱃지의 크기입니다.
- **Discussion**
  >  See Also
  >
  > `ContentBadge.Size`


~~``var text: String``~~

뱃지에 표시될 텍스트입니다.

~~``var trailingIcon: UIImage?``~~

텍스트의 우측에 표시될 아이콘입니다.
- **Discussion**

  아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.

~~``var variant: ContentBadge.Variant``~~

뱃지의 외관 스타일입니다.
- **Discussion**
  >  See Also
  >
  > `ContentBadge.Variant`


### Instance Methods


~~``func layoutSubviews()``~~

하위 뷰의 레이아웃이 변경될 때 호출되는 메서드입니다.

~~``func traitCollectionDidChange(UITraitCollection?)``~~

트레이트 컬렉션이 변경될 때 호출되는 메서드입니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `previousTraitCollection` | 이전 트레이트 컬렉션 |
- **Discussion**

  다크 모드와 라이트 모드 전환 시 UI를 업데이트합니다.

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

`UIKit.UILargeContentViewerItem`

`UIKit.UIPasteConfigurationSupporting`

`UIKit.UIPopoverPresentationControllerSourceItem`

`UIKit.UIResponderStandardEditActions`

`UIKit.UITraitChangeObservable`

`UIKit.UITraitEnvironment`

`UIKit.UIUserActivityRestoring`



