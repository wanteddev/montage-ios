**STRUCT**

# `Skeleton.SkeletonView`

```swift
public struct SkeletonView: View
```

스켈레톤 로딩 UI를 표시하는 뷰입니다.

지정된 형태(텍스트, 사각형, 원형)에 따라 적절한 스켈레톤 UI를 렌더링합니다.
색상, 투명도 등을 커스터마이징할 수 있습니다.

**사용 예시**:
```swift
Skeleton.SkeletonView(.text(lineNumber: 3))
    .color(.gray)
    .opacity(0.8)
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:)</code></summary>

```swift
public init(_ kind: Kind)
```

스켈레톤 뷰를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| kind | 표시할 스켈레톤의 종류 |




</details>

<details><summary markdown="span"><code>color(_:)</code></summary>

```swift
public func color(_ color: SwiftUI.Color) -> Self
```

스켈레톤 뷰의 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 적용할 색상 |

#### Returns

수정된 SkeletonView 인스턴스



</details>

<details><summary markdown="span"><code>opacity(_:)</code></summary>

```swift
public func opacity(_ opacity: CGFloat) -> Self
```

스켈레톤 뷰의 투명도를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| opacity | 적용할 투명도 (0.0 ~ 1.0) |

#### Returns

수정된 SkeletonView 인스턴스



</details>
