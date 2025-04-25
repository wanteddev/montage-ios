**STRUCT**

# `Pagination.Dot`

```swift
public struct Dot: View
```

점 형태의 페이지 표시기 컴포넌트입니다.

`Dot`은 페이지 간 이동 및 현재 페이지 표시를 위한 점 형태의 페이지네이션 컴포넌트를 제공합니다.
현재 선택된 페이지는 강조 표시되며, 점을 탭하여 해당 페이지로 이동할 수 있습니다.
페이지 수가 많을 경우 표시되는 점의 개수와 크기가 자동으로 조정됩니다.

**사용 예시**:
```swift
@State private var currentPage = 1

Pagination.Dot(selectedPage: $currentPage, totalPages: 10)
    .variant(.normal)
    .size(.normal)
```

- Note: 최대 표시 가능한 점의 개수는 5개이며, 페이지 수가 더 많을 경우 동적으로 조정됩니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(selectedPage:totalPages:)</code></summary>

```swift
public init(selectedPage: Binding<Int>, totalPages: Int)
```

점 형태의 페이지네이션을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| selectedPage | 현재 선택된 페이지 번호 (1부터 시작) |
| totalPages | 전체 페이지 수 |




</details>

<details><summary markdown="span"><code>variant(_:)</code></summary>

```swift
public func variant(_ variant: Variant) -> Self
```

점 페이지네이션의 색상 변형을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 적용할 색상 변형 |

#### Returns

수정된 Dot 인스턴스

- Note: 기본값은 `.normal`입니다.



</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

점 페이지네이션의 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 적용할 점 크기 |

#### Returns

수정된 Dot 인스턴스

- Note: 기본값은 `.normal`입니다.



</details>
