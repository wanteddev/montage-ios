**STRUCT**

# `Thumbnail`

```swift
public struct Thumbnail: View
```

다양한 비율로 이미지를 표시하는 썸네일 컴포넌트입니다.

`Thumbnail`은 원격 URL에서 이미지를 로드하여 지정된 비율과 크기로 표시합니다.
이미지 로딩 상태에 따른 플레이스홀더를 지원하고, 둥근 모서리와 테두리 스타일을 적용할 수 있습니다.

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

- Note: 이미지 로딩에는 SDWebImage 라이브러리를 사용하며, 로드 실패 시 기본 또는 커스텀 플레이스홀더가 표시됩니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(urlString:ratio:)</code></summary>

```swift
public init(urlString: String, ratio: Ratio)
```

썸네일을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| urlString | 로드할 이미지의 URL 문자열 |
| ratio | 적용할 가로세로 비율 |




</details>

<details><summary markdown="span"><code>radius(_:)</code></summary>

```swift
public func radius(_ radius: Bool = true) -> Self
```

썸네일에 둥근 모서리를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| radius | 둥근 모서리 적용 여부 (기본값: true) |

#### Returns

수정된 Thumbnail 인스턴스

- Note: 적용 시 12포인트 반경의 둥근 모서리가 적용됩니다.



</details>

<details><summary markdown="span"><code>border(_:)</code></summary>

```swift
public func border(_ border: Bool = true) -> Self
```

썸네일에 테두리를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| border | 테두리 적용 여부 (기본값: true) |

#### Returns

수정된 Thumbnail 인스턴스

- Note: 적용 시 1포인트 두께의 .lineNormal 색상 테두리가 적용됩니다.



</details>

<details><summary markdown="span"><code>width(_:)</code></summary>

```swift
public func width(_ width: CGFloat) -> Self
```

</details>
