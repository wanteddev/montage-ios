**ENUM**

# `Thumbnail.Ratio`

```swift
public enum Ratio
```

썸네일의 가로세로 비율을 정의하는 열거형입니다.

다양한 미디어 콘텐츠 유형에 맞는 여러 표준 비율을 제공합니다.
가로가 긴 비율(21:9, 16:9 등), 정사각형(1:1), 세로가 긴 비율(9:16, 1:2 등)을 지원합니다.

**사용 예시**:
```swift
// 와이드스크린 비디오용 썸네일
Thumbnail(url: videoURL)
   .ratio(.r16x9, width: 320)

// 모바일 세로 화면용 썸네일
Thumbnail(url: storyURL)
   .ratio(.r9x16, height: 400)
```

- Note: 각 비율은 실제 픽셀 크기가 아닌 가로와 세로의 상대적 비율을 나타냅니다.

## Cases
### `r21x9`

```swift
case r21x9
```

21:9 비율 (울트라와이드 영화)

### `r2x1`

```swift
case r2x1
```

2:1 비율

### `r16x9`

```swift
case r16x9
```

16:9 비율 (와이드스크린 비디오)

### `r1_618x1`

```swift
case r1_618x1
```

황금비(1.618:1)

### `r16x10`

```swift
case r16x10
```

16:10 비율 (와이드스크린 모니터)

### `r3x2`

```swift
case r3x2
```

3:2 비율 (일부 사진)

### `r4x3`

```swift
case r4x3
```

4:3 비율 (전통적인 TV, 모니터)

### `r5x4`

```swift
case r5x4
```

5:4 비율

### `r1x1`

```swift
case r1x1
```

1:1 비율 (정사각형)

### `r4x5`

```swift
case r4x5
```

4:5 비율 (일부 소셜 미디어 이미지)

### `r3x4`

```swift
case r3x4
```

3:4 비율

### `r2x3`

```swift
case r2x3
```

2:3 비율 (일부 사진)

### `r10x16`

```swift
case r10x16
```

10:16 비율

### `r1x1_618`

```swift
case r1x1_618
```

역황금비(1:1.618)

### `r9x16`

```swift
case r9x16
```

9:16 비율 (스마트폰 세로 화면)

### `r1x2`

```swift
case r1x2
```

1:2 비율

### `r9x21`

```swift
case r9x21
```

9:21 비율 (세로 울트라와이드)

## Properties
<details><summary markdown="span"><code>rawValue</code></summary>

```swift
public var rawValue: CGFloat
```

비율 값을 CGFloat로 반환합니다.

#### Returns

가로 길이를 세로 길이로 나눈 값

</details>
