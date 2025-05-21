---
title: Thumbnail.Ratio
description: 썸네일의 가로세로 비율을 정의하는 열거형입니다.
---

```swift
enum Ratio
```

## Overview

다양한 미디어 콘텐츠 유형에 맞는 여러 표준 비율을 제공합니다. 가로가 긴 비율(21:9, 16:9 등), 정사각형(1:1), 세로가 긴 비율(9:16, 1:2 등)을 지원합니다.

```swift
// 와이드스크린 비디오용 썸네일
Thumbnail(urlString: videoURL, ratio: .r16x9)
   .width(320)

// 모바일 세로 화면용 썸네일
Thumbnail(urlString: storyURL, ratio: .r9x16)
   .width(400)
```

>  Note
>
> 각 비율은 실제 픽셀 크기가 아닌 가로와 세로의 상대적 비율을 나타냅니다.

## Topics

### Enumeration Cases


``case r10x16``

10:16 비율

``case r16x10``

16:10 비율 (와이드스크린 모니터)

``case r16x9``

16:9 비율 (와이드스크린 비디오)

``case r1_618x1``

황금비(1.618:1)

``case r1x1``

1:1 비율 (정사각형)

``case r1x1_618``

역황금비(1:1.618)

``case r1x2``

1:2 비율

``case r21x9``

21:9 비율 (울트라와이드 영화)

``case r2x1``

2:1 비율

``case r2x3``

2:3 비율 (일부 사진)

``case r3x2``

3:2 비율 (일부 사진)

``case r3x4``

3:4 비율

``case r4x3``

4:3 비율 (전통적인 TV, 모니터)

``case r4x5``

4:5 비율 (일부 소셜 미디어 이미지)

``case r5x4``

5:4 비율

``case r9x16``

9:16 비율 (스마트폰 세로 화면)

``case r9x21``

9:21 비율 (세로 울트라와이드)

### Instance Properties


``var rawValue: CGFloat``

비율 값을 CGFloat로 반환합니다.
- **Return Value**

  가로 길이를 세로 길이로 나눈 값

### Default Implementations


[Equatable Implementations](/documentation/montage/thumbnail/ratio/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



