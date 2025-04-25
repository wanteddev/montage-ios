**STRUCT**

# `Modal.Navigation`

```swift
public struct Navigation: View
```

모달 내에서 사용하는 내비게이션 바 컴포넌트입니다.

모달 상단에 제목, 뒤로가기 버튼, 추가 버튼 등을 포함하는
내비게이션 바를 제공합니다. 스크롤에 따라 배경 불투명도가 자동으로 조절되며
다양한 스타일을 지원합니다.

**사용 예시**:
```swift
Modal.Navigation(title: "제목")
    .variant(.normal)
    .leadingButton(.back {
        // 뒤로가기 동작
    })
    .trailingButtons([
        .icon(.close, action: {
            // 닫기 동작
        })
    ])
```

- SeeAlso: `Modal.Navigation.Variant`, `Bar.TopNavigation`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:scrollOffset:)</code></summary>

```swift
public init(title: String, scrollOffset: Binding<CGFloat> = .constant(0))
```

내비게이션 바를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| title | 내비게이션 바에 표시할 제목 |
| scrollOffset | 스크롤 오프셋에 대한 바인딩 (기본값: .constant(0)) |




</details>

<details><summary markdown="span"><code>variant(_:)</code></summary>

```swift
public func variant(_ variant: Variant) -> Self
```

내비게이션 바의 스타일을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 내비게이션 바 스타일 |

#### Returns

수정된 내비게이션 바 뷰



</details>

<details><summary markdown="span"><code>scrollOffset(_:)</code></summary>

```swift
public func scrollOffset(_ scrollOffset: Binding<CGFloat>) -> Self
```

스크롤 오프셋을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| scrollOffset | 스크롤 오프셋에 대한 바인딩 |

#### Returns

수정된 내비게이션 바 뷰



</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ backgroundColor: SwiftUI.Color) -> Self
```

내비게이션 바의 배경색을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| backgroundColor | 배경색 |

#### Returns

수정된 내비게이션 바 뷰



</details>

<details><summary markdown="span"><code>needHandleArea(_:)</code></summary>

```swift
public func needHandleArea(_ needHandleArea: Bool) -> Self
```

바텀 시트의 핸들 영역 필요 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| needHandleArea | 핸들 영역 필요 여부 |

#### Returns

수정된 내비게이션 바 뷰



</details>

<details><summary markdown="span"><code>leadingButton(_:)</code></summary>

```swift
public func leadingButton(_ leadingButton: Bar.TopNavigation.Resource.LeadingButton?) -> Self
```

내비게이션 바의 왼쪽 버튼을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| leadingButton | 왼쪽 버튼 설정 |

#### Returns

수정된 내비게이션 바 뷰



</details>

<details><summary markdown="span"><code>trailingButtons(_:)</code></summary>

```swift
public func trailingButtons(_ actions: [Bar.TopNavigation.Resource.TrailingButton]) -> Self
```

내비게이션 바의 오른쪽 버튼들을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| actions | 오른쪽 버튼 배열 (최대 3개까지 표시) |

#### Returns

수정된 내비게이션 바 뷰



</details>
