---
title: PushBadge
description: 푸시 알림이나 알림 표시를 위한 뱃지 컴포넌트입니다.
---

```swift
@MainActor struct PushBadge
```

## Overview

작은 점, ‘N’ 표시, 또는 숫자를 표시할 수 있으며 다양한 크기와 위치를 지원합니다. 주로 아이콘이나 버튼 주변에 새로운 알림이나 메시지가 있음을 나타내기 위해 사용됩니다.

```swift
// 기본 점 형태 뱃지
PushBadge(variant: .dot)

// 'N' 표시 뱃지
PushBadge(variant: .new)
    .size(.small)

// 숫자 표시 뱃지
PushBadge(variant: .number(5))
    .backgroundColor(.red)
```

>  See Also
>
> `PushBadge.Modifier`, `PushBadge.Variant`, `PushBadge.Size`, `PushBadge.Position`

## Topics

### Initializers


``init(variant: Variant)``

PushBadge를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 뱃지의 표시 형태 (dot, new, number) |

### Instance Properties


``var body: some View``

### Instance Methods


``func backgroundColor(SwiftUI.Color) -> PushBadge``

배경 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 배경 색상 |
- **Return Value**

  배경 색상이 변경된 PushBadge

``func fontColor(SwiftUI.Color) -> PushBadge``

텍스트 색상을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 텍스트 색상 |
- **Return Value**

  텍스트 색상이 변경된 PushBadge

``func size(Size) -> PushBadge``

뱃지의 크기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 뱃지 크기 |
- **Return Value**

  크기가 변경된 PushBadge

### Enumerations


[``enum Position``](/documentation/montage/pushbadge/position.md)

뱃지의 위치를 정의하는 열거형입니다.

[``enum Size``](/documentation/montage/pushbadge/size.md)

뱃지의 크기를 정의하는 열거형입니다.

[``enum Variant``](/documentation/montage/pushbadge/variant.md)

뱃지의 표시 형태를 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/pushbadge/view-implementations.md)

[View Implementations](/documentation/montage/pushbadge/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



