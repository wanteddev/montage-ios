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
<details><summary markdown="span"><code>init(url:content:placeholder:)</code></summary>

```swift
public init(
    url: URL?,
    content: ((Image) -> any View)? = nil,
    placeholder: (() -> any View)? = nil
)
```

썸네일을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| url | 로드할 이미지의 URL |
| content | 이미지 로드 성공 시 이미지를 커스터마이징할 수 있는 클로저 (기본값: nil) |
| placeholder | 이미지 로드 중이나 실패 시 표시할 플레이스홀더 뷰를 생성하는 클로저 (기본값: nil) |


- Note: placeholder가 nil이면 기본 배경색(.fillAlternative)이 사용됩니다.



</details>

<details><summary markdown="span"><code>ratio(_:width:)</code></summary>

```swift
public func ratio(_ ratio: Ratio, width: CGFloat) -> Self
```

너비를 기준으로 썸네일의 비율을 설정합니다.

지정된 비율과 너비에 맞게 높이가 자동으로 계산됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| ratio | 적용할 가로세로 비율 |
| width | 썸네일의 너비 (포인트 단위) |

#### Returns

수정된 Thumbnail 인스턴스



</details>

<details><summary markdown="span"><code>ratio(_:height:)</code></summary>

```swift
public func ratio(_ ratio: Ratio, height: CGFloat) -> Self
```

높이를 기준으로 썸네일의 비율을 설정합니다.

지정된 비율과 높이에 맞게 너비가 자동으로 계산됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| ratio | 적용할 가로세로 비율 |
| height | 썸네일의 높이 (포인트 단위) |

#### Returns

수정된 Thumbnail 인스턴스



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
