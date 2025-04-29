Enumeration

# Thumbnail.Ratio 

썸네일의 가로세로 비율을 정의하는 열거형입니다.

```swift
enum Ratio
```

## Overview 

다양한 미디어 콘텐츠 유형에 맞는 여러 표준 비율을 제공합니다. 가로가 긴 비율(21:9, 16:9 등), 정사각형(1:1), 세로가 긴 비율(9:16, 1:2 등)을 지원합니다.

**사용 예시**:

```swift
// 와이드스크린 비디오용 썸네일
Thumbnail(url: videoURL)
   .ratio(.r16x9, width: 320)

// 모바일 세로 화면용 썸네일
Thumbnail(url: storyURL)
   .ratio(.r9x16, height: 400)
```

> **Note**
>
> 각 비율은 실제 픽셀 크기가 아닌 가로와 세로의 상대적 비율을 나타냅니다.

## Topics 

### Enumeration Cases 

- [case r10x16](/documentation/montage/thumbnail/ratio/r10x16.md)

  10:16 비율

- [case r16x10](/documentation/montage/thumbnail/ratio/r16x10.md)

  16:10 비율 (와이드스크린 모니터)

- [case r16x9](/documentation/montage/thumbnail/ratio/r16x9.md)

  16:9 비율 (와이드스크린 비디오)

- [case r1_618x1](/documentation/montage/thumbnail/ratio/r1_618x1.md)

  황금비(1.618:1)

- [case r1x1](/documentation/montage/thumbnail/ratio/r1x1.md)

  1:1 비율 (정사각형)

- [case r1x1_618](/documentation/montage/thumbnail/ratio/r1x1_618.md)

  역황금비(1:1.618)

- [case r1x2](/documentation/montage/thumbnail/ratio/r1x2.md)

  1:2 비율

- [case r21x9](/documentation/montage/thumbnail/ratio/r21x9.md)

  21:9 비율 (울트라와이드 영화)

- [case r2x1](/documentation/montage/thumbnail/ratio/r2x1.md)

  2:1 비율

- [case r2x3](/documentation/montage/thumbnail/ratio/r2x3.md)

  2:3 비율 (일부 사진)

- [case r3x2](/documentation/montage/thumbnail/ratio/r3x2.md)

  3:2 비율 (일부 사진)

- [case r3x4](/documentation/montage/thumbnail/ratio/r3x4.md)

  3:4 비율

- [case r4x3](/documentation/montage/thumbnail/ratio/r4x3.md)

  4:3 비율 (전통적인 TV, 모니터)

- [case r4x5](/documentation/montage/thumbnail/ratio/r4x5.md)

  4:5 비율 (일부 소셜 미디어 이미지)

- [case r5x4](/documentation/montage/thumbnail/ratio/r5x4.md)

  5:4 비율

- [case r9x16](/documentation/montage/thumbnail/ratio/r9x16.md)

  9:16 비율 (스마트폰 세로 화면)

- [case r9x21](/documentation/montage/thumbnail/ratio/r9x21.md)

  9:21 비율 (세로 울트라와이드)

### Instance Properties 

- [var rawValue: CGFloat](/documentation/montage/thumbnail/ratio/rawvalue.md)

  비율 값을 CGFloat로 반환합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/thumbnail/ratio/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

