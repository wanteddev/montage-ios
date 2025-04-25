**STRUCT**

# `ProgressIndicator`

```swift
public struct ProgressIndicator: View
```

진행 상태를 시각적으로 표시하는 인디케이터 뷰

주어진 퍼센트에 따라 진행 상태를 막대 형태로 표시합니다.
왼쪽에서 오른쪽으로 채워지는 형태로 진행 상태를 시각화합니다.

**사용 예시**:
```swift
@State private var progress: CGFloat = 0.5

ProgressIndicator(percentage: $progress)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| percentage | 진행 상태를 나타내는 값 (0.0 ~ 1.0 사이의 값) |


## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(percentage:)</code></summary>

```swift
public init(percentage: Binding<CGFloat>)
```

진행 상태 인디케이터를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| percentage | 진행 상태를 나타내는 바인딩 값 (0.0 ~ 1.0 사이의 값) |




</details>
