Structure

# Thumbnail 

다양한 비율로 이미지를 표시하는 썸네일 컴포넌트입니다.

```swift
@MainActor
struct Thumbnail
```

## Overview 

Thumbnail은 원격 URL에서 이미지를 로드하여 지정된 비율과 크기로 표시합니다. 이미지 로딩 상태에 따른 플레이스홀더를 지원하고, 둥근 모서리와 테두리 스타일을 적용할 수 있습니다.

**사용 예시**:

```swift
// 기본 정사각형 썸네일
Thumbnail(url: imageURL)
   .ratio(.r1x1, width: 100)

// 16:9 비율의 둥근 모서리 썸네일
Thumbnail(url: videoURL)
   .ratio(.r16x9, width: 320)
   .radius(true)

// 커스텀 플레이스홀더가 있는 썸네일
Thumbnail(
   url: profileURL,
   placeholder: {
       Image.montage(.userPlaceholder)
           .resizable()
           .scaledToFit()
   }
)
.ratio(.r1x1, height: 50)
.border(true)
```

> **Note**
>
> 이미지 로딩에는 SDWebImage 라이브러리를 사용하며, 로드 실패 시 기본 또는 커스텀 플레이스홀더가 표시됩니다.

## Topics 

### Initializers 

- [init(urlString: String, ratio: Ratio)](/documentation/montage/thumbnail/init(urlstring:ratio:).md)

  썸네일을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/thumbnail/body.md)

### Instance Methods 

- [func border(Bool) -> Thumbnail](/documentation/montage/thumbnail/border(_:).md)

  썸네일에 테두리를 적용합니다.

- [func radius(Bool) -> Thumbnail](/documentation/montage/thumbnail/radius(_:).md)

  썸네일에 둥근 모서리를 적용합니다.

- [func width(CGFloat) -> Thumbnail](/documentation/montage/thumbnail/width(_:).md)

### Enumerations 

- [enum Ratio](/documentation/montage/thumbnail/ratio.md)

  썸네일의 가로세로 비율을 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

