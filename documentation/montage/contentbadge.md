---
1title: contentbadge
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# ContentBadge 

텍스트와 아이콘을 포함할 수 있는 뱃지 컴포넌트입니다.

```swift
@MainActor
struct ContentBadge
```

## Overview 

다양한 크기와 스타일, 색상을 제공하며 텍스트 앞뒤로 아이콘을 추가할 수 있습니다. 솔리드와 아웃라인 스타일을 지원합니다.

**사용 예시**:

```swift
// 기본 솔리드 뱃지
ContentBadge(text: "New")

// 아웃라인 스타일 뱃지
ContentBadge(variant: .outlined, text: "Updated")
    .size(.medium)
    .colorStyle(.accent(SwiftUI.Color.blue))
    .leadingIcon(.check)
```

> **See Also**
>
> ContentBadge.Variant, ContentBadge.Size, ContentBadge.ColorStyle

## Topics 

### Initializers 

- [init(variant: Variant, text: String)](/documentation/montage/contentbadge/init(variant:text:).md)

  ContentBadge를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/contentbadge/body.md)

### Instance Methods 

- [func colorStyle(ColorStyle) -> ContentBadge](/documentation/montage/contentbadge/colorstyle(_:).md)

  뱃지의 색상 스타일을 설정합니다.

- [func leadingIcon(Icon) -> ContentBadge](/documentation/montage/contentbadge/leadingicon(_:).md)

  뱃지 텍스트 앞에 표시될 아이콘을 설정합니다.

- [func size(Size) -> ContentBadge](/documentation/montage/contentbadge/size(_:).md)

  뱃지의 크기를 설정합니다.

- [func trailingIcon(Icon) -> ContentBadge](/documentation/montage/contentbadge/trailingicon(_:).md)

  뱃지 텍스트 뒤에 표시될 아이콘을 설정합니다.

### Enumerations 

- [enum ColorStyle](/documentation/montage/contentbadge/colorstyle.md)

  뱃지의 색상을 결정하는 열거형입니다.

- [enum Size](/documentation/montage/contentbadge/size.md)

  뱃지의 사이즈를 결정하는 열거형입니다.

- [enum Variant](/documentation/montage/contentbadge/variant.md)

  뱃지의 외관을 결정하는 열거형 타입입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

