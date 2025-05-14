---
1title: list
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Card.List 

썸네일과 콘텐츠를 수평으로 배치한 리스트 형태의 카드 컴포넌트입니다.

```swift
@MainActor
struct List
```

## Overview 

썸네일 이미지와 텍스트 콘텐츠를 수평 방향으로 배치한 카드로, 리스트 항목으로 사용하기 적합합니다. 스켈레톤 로딩 상태를 지원하고 다양한 콘텐츠를 배치할 수 있습니다.

**사용 예시**:

```swift
@State private var isLoading = false

Card.List(
    thumbnail: { Thumbnail(.image(Image("sample")), variant: .square) },
    skeleton: $isLoading,
    title: { Text("리스트 카드 제목").montage(variant: .heading4) }
)
.caption { Text("부제목").montage(variant: .body2) }
.trailingContent { IconButton(icon: .arrowForward) }
```

> **Note**
>
> 리스트 형태의 UI에 적합하며, 선택적으로 앞뒤에 추가 콘텐츠를 배치할 수 있습니다.

## Topics 

### Initializers 

- [init(thumbnail: () -> Thumbnail, skeleton: Binding<Bool>, title: String)](/documentation/montage/card/list/init(thumbnail:skeleton:title:).md)

  List 카드를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/card/list/body.md)

### Instance Methods 

- [func bottomContent((() -> any View)?) -> Card.List](/documentation/montage/card/list/bottomcontent(_:).md)

  카드 하단에 표시할 콘텐츠를 설정합니다.

- [func caption(String?) -> Card.List](/documentation/montage/card/list/caption(_:).md)

  카드의 캡션(부제목)을 설정합니다.

- [func extraCaption(String?) -> Card.List](/documentation/montage/card/list/extracaption(_:).md)

  카드의 추가 캡션을 설정합니다.

- [func leadingContent((() -> any View)?) -> Card.List](/documentation/montage/card/list/leadingcontent(_:).md)

  카드 왼쪽(썸네일 앞)에 표시할 콘텐츠를 설정합니다.

- [func topContent((() -> any View)?) -> Card.List](/documentation/montage/card/list/topcontent(_:).md)

  카드 상단에 표시할 콘텐츠를 설정합니다.

- [func trailingContent((() -> any View)?) -> Card.List](/documentation/montage/card/list/trailingcontent(_:).md)

  카드 오른쪽에 표시할 콘텐츠를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

