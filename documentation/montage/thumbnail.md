---
title: Thumbnail
description: 다양한 비율로 이미지를 표시하는 썸네일 컴포넌트입니다.
---

```swift
@MainActor struct Thumbnail
```

## Overview

`Thumbnail`은 원격 URL에서 이미지를 로드하여 지정된 비율과 크기로 표시합니다. 이미지 로딩 상태에 따른 플레이스홀더를 지원하고, 둥근 모서리와 테두리 스타일을 적용할 수 있습니다.

```swift
// 기본 정사각형 썸네일
Thumbnail(urlString: imageURL, ratio: .r1x1)
   .width(100)

// 16:9 비율의 둥근 모서리 썸네일
Thumbnail(urlString: imageURL, ratio: .r16x9)
   .width(320)
   .radius(true)

// 테두리가 있는 썸네일
Thumbnail(urlString: imageURL, ratio: .r1x1)
   .width(50)
   .border(true)
```

>  Note
>
> 이미지 로딩에는 SDWebImage 라이브러리를 사용하며, 로드 실패 시 기본 플레이스홀더가 표시됩니다.

## Topics

### Initializers


``init(urlString: String, ratio: Ratio)``

썸네일을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `urlString` | 로드할 이미지의 URL 문자열 |
  | `ratio` | 적용할 가로세로 비율 |

### Instance Properties


``var body: some View``

### Instance Methods


``func border(Bool) -> Thumbnail``

썸네일에 테두리를 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `border` | 테두리 적용 여부 (기본값: true) |
- **Return Value**

  수정된 Thumbnail 인스턴스
- **Discussion**
  >  Note
  >
  > 적용 시 1포인트 두께의 .lineNormal 색상 테두리가 적용됩니다.


``func radius(Bool) -> Thumbnail``

썸네일에 둥근 모서리를 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `radius` | 둥근 모서리 적용 여부 (기본값: true) |
- **Return Value**

  수정된 Thumbnail 인스턴스
- **Discussion**
  >  Note
  >
  > 적용 시 12포인트 반경의 둥근 모서리가 적용됩니다.


``func width(CGFloat) -> Thumbnail``

### Enumerations


[``enum Ratio``](/documentation/montage/thumbnail/ratio.md)

썸네일의 가로세로 비율을 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/thumbnail/view-implementations.md)

[View Implementations](/documentation/montage/thumbnail/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



