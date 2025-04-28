**ENUM**

# `IconButton.Variant`

```swift
public enum Variant
```

버튼의 외관을 결정하는 열거형입니다.

아이콘 버튼의 다양한 스타일과 크기를 정의합니다.

## Cases
### `normal(size:)`

```swift
case normal(size: Int)
```

기본형 아이콘 버튼 - 배경 없이 아이콘만 표시
#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 아이콘 크기 (픽셀) |


### `background(size:isAlternative:)`

```swift
case background(size: Int, isAlternative: Bool = false)
```

배경형 아이콘 버튼 - 반투명 배경을 가진 아이콘
#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 아이콘 크기 (픽셀) |
| isAlternative | 대체 스타일 사용 여부 |


### `outlined(size:)`

```swift
case outlined(size: Size)
```

외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘
#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 아이콘 크기 (Size 열거형) |


### `solid(size:)`

```swift
case solid(size: Size)
```

솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘
#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 아이콘 크기 (Size 열거형) |


## Properties
<details><summary markdown="span"><code>default</code></summary>

```swift
public static let `default` = Self.normal(size: 24)
```

normal(size: 24)의 기본 variant입니다.

</details>
