---
1title: resource
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# TextInput.TextArea.Resource 

텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.

```swift
enum Resource
```

## Overview 

다양한 종류의 컴포넌트를 텍스트 영역 하단에 배치할 수 있습니다. 문자 수 카운터, 버튼, 아이콘, 칩, 뱃지 등을 지원합니다.

> **Note**
>
> 문자 수 카운터는 좌/우측 중 하나에만 사용 가능합니다. 중복 사용 시 좌측이 우선 표시됩니다.

## Topics 

### Enumeration Cases 

- [case actionChip(Chip.Action.Variant, title: String, handler: (() -> Void)?)](/documentation/montage/textinput/textarea/resource/actionchip(_:title:handler:).md)

  액션 칩

- [case badge(ContentBadge.Variant, title: String)](/documentation/montage/textinput/textarea/resource/badge(_:title:).md)

  뱃지

- [case characterCount(limit: Int?, overflow: Bool)](/documentation/montage/textinput/textarea/resource/charactercount(limit:overflow:).md)

  문자 수 카운터

- [case filterChip(Chip.Filter.Variant, title: String, handler: (() -> Void)?)](/documentation/montage/textinput/textarea/resource/filterchip(_:title:handler:).md)

  필터 칩

- [case icon(Icon, tintColor: SwiftUI.Color)](/documentation/montage/textinput/textarea/resource/icon(_:tintcolor:).md)

  단순 아이콘

- [case iconButton(placement: Placement, variant: IconButton.Variant?, icon: Icon, tintColor: SwiftUI.Color, handler: (() -> Void)?)](/documentation/montage/textinput/textarea/resource/iconbutton(placement:variant:icon:tintcolor:handler:).md)

  아이콘 버튼

- [case textButton(placement: Placement, varaint: Button.Text.Variant?, title: String, handler: (() -> Void)?)](/documentation/montage/textinput/textarea/resource/textbutton(placement:varaint:title:handler:).md)

  텍스트 버튼

### Enumerations 

- [enum Placement](/documentation/montage/textinput/textarea/resource/placement.md)

