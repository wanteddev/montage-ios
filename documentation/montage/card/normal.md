Structure

# Card.Normal 

썸네일과 콘텐츠를 포함하는 기본 카드 컴포넌트입니다.

```swift
@MainActor
struct Normal
```

## Overview 

썸네일 이미지와 제목, 캡션 등의 텍스트 콘텐츠를 수직 방향으로 배치한 카드입니다. 스켈레톤 로딩 상태를 지원하고, 썸네일 위에 오버레이 콘텐츠를 표시할 수 있습니다.

**사용 예시**:

```swift
@State private var isLoading = false

Card.Normal(
    thumbnail: { Thumbnail(.image(Image("sample"))) },
    skeleton: $isLoading,
    title: { Text("카드 제목").montage(variant: .heading3) }
)
.caption { Text("부제목").montage(variant: .body2) }
.overlay(caption: "New", buttonIcon: .heart)
```

> **Note**
>
> 썸네일 이미지는 둥근 모서리로 표시되며, 콘텐츠 영역의 너비는 썸네일 너비에 맞춰집니다.

## Topics 

### Initializers 

- [init(thumbnail: () -> Thumbnail, skeleton: Binding<Bool>, title: String)](/documentation/montage/card/normal/init(thumbnail:skeleton:title:).md)

  Normal 카드를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/card/normal/body.md)

### Instance Methods 

- [func bottomContent((() -> any View)?) -> Card.Normal](/documentation/montage/card/normal/bottomcontent(_:).md)

  카드 하단에 표시할 콘텐츠를 설정합니다.

- [func caption(String?) -> Card.Normal](/documentation/montage/card/normal/caption(_:).md)

  카드의 캡션(부제목)을 설정합니다.

- [func extraCaption(String?) -> Card.Normal](/documentation/montage/card/normal/extracaption(_:).md)

  카드의 추가 캡션을 설정합니다.

- [func overlay(caption: String?, buttonIcon: Montage.Icon?, onTapButton: (() -> Void)?) -> Card.Normal](/documentation/montage/card/normal/overlay(caption:buttonicon:ontapbutton:).md)

  썸네일에 오버레이할 콘텐츠를 설정합니다.

- [func subCaption(String?) -> Card.Normal](/documentation/montage/card/normal/subcaption(_:).md)

  카드의 보조 캡션을 설정합니다.

- [func topContent((() -> any View)?) -> Card.Normal](/documentation/montage/card/normal/topcontent(_:).md)

  카드 상단에 표시할 콘텐츠를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

