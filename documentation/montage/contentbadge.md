---
title: ContentBadge
description: 텍스트와 아이콘을 포함할 수 있는 뱃지 컴포넌트입니다.
---

```swift
@MainActor struct ContentBadge
```

## Overview

다양한 크기와 스타일, 색상을 제공하며 텍스트 앞뒤로 아이콘을 추가할 수 있습니다. 솔리드와 아웃라인 스타일을 지원합니다.

```swift
// 기본 솔리드 뱃지
ContentBadge(text: "New")

// 아웃라인 스타일 뱃지
ContentBadge(variant: .outlined, text: "Updated")
    .size(.medium)
    .colorStyle(.accent(SwiftUI.Color.blue))
    .leadingIcon(.check)
```

>  See Also
>
> `ContentBadge.Variant`, `ContentBadge.Size`, `ContentBadge.ColorStyle`

## Topics

### Initializers


``init(variant: Variant, text: String)``

ContentBadge를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 뱃지의 스타일 (solid 또는 outlined) |
  | `text` | 뱃지에 표시할 텍스트 |

### Instance Properties


``var body: some View``

### Instance Methods


``func colorStyle(ColorStyle) -> ContentBadge``

뱃지의 색상 스타일을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `colorStyle` | 색상 스타일 |
- **Return Value**

  변경된 색상 스타일이 적용된 ContentBadge

``func leadingIcon(Icon) -> ContentBadge``

뱃지 텍스트 앞에 표시될 아이콘을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `leadingIcon` | 선행 아이콘 |
- **Return Value**

  선행 아이콘이 추가된 ContentBadge

``func size(Size) -> ContentBadge``

뱃지의 크기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 뱃지 크기 |
- **Return Value**

  변경된 크기가 적용된 ContentBadge

``func trailingIcon(Icon) -> ContentBadge``

뱃지 텍스트 뒤에 표시될 아이콘을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `trailingIcon` | 후행 아이콘 |
- **Return Value**

  후행 아이콘이 추가된 ContentBadge

### Enumerations


[``enum ColorStyle``](/documentation/montage/contentbadge/colorstyle.md)

뱃지의 색상을 결정하는 열거형입니다.

[``enum Size``](/documentation/montage/contentbadge/size.md)

뱃지의 사이즈를 결정하는 열거형입니다.

[``enum Variant``](/documentation/montage/contentbadge/variant.md)

뱃지의 외관을 결정하는 열거형 타입입니다.

### Default Implementations


[View Implementations](/documentation/montage/contentbadge/view-implementations.md)

[View Implementations](/documentation/montage/contentbadge/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



