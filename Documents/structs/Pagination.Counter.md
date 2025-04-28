**STRUCT**

# `Pagination.Counter`

```swift
public struct Counter: View
```

숫자 카운터 형태의 페이지 표시기 컴포넌트입니다.

`Counter`는 현재 페이지와 전체, 페이지 수를 숫자로 표시하는 페이지네이션 컴포넌트를 제공합니다.
"1/10"과 같은 형식으로 페이지 정보를 시각화하며, 반투명 배경이 적용됩니다.

**사용 예시**:
```swift
@State private var currentPage = 1

Pagination.Counter(selectedPage: $currentPage, totalPages: 10)
    .size(.medium)
    .alternative(true)
```

- Note: 이 컴포넌트는 기본적으로 어두운 배경 위에서 잘 보이도록 설계되었습니다.

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

카운터 형태의 페이지네이션을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| selectedPage | 현재 선택된 페이지 번호 (1부터 시작) |
| totalPages | 전체 페이지 수 |




</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

카운터 페이지네이션의 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 적용할 카운터 크기 |

#### Returns

수정된 Counter 인스턴스

- Note: 기본값은 `.medium`입니다.



</details>

<details><summary markdown="span"><code>alternative(_:)</code></summary>

```swift
public func alternative(_ alternative: Bool = true) -> Self
```

카운터 페이지네이션의 대체 스타일을 적용합니다.

기본 스타일은 반투명 배경을 사용하고, 대체 스타일은 좀 더 불투명한 회색 배경을 사용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| alternative | 대체 스타일 적용 여부 (기본값: true) |

#### Returns

수정된 Counter 인스턴스

- Note: 기본값은 `false`입니다.



</details>
