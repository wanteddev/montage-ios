**STRUCT**

# `ScrollView`

```swift
public struct ScrollView: View
```

스크롤 상태 추적과 오프셋 감지가 가능한 커스텀 스크롤 뷰입니다.

기본 SwiftUI 스크롤 뷰를 확장하여 스크롤 상태 추적, 오프셋 감지, 새로고침 등
추가 기능을 제공합니다.

**사용 예시**:
```swift
@State private var scrollStatus = ScrollView.ScrollStatus()

ScrollView(scrollStatus: $scrollStatus, 
            onOffsetChanged: { offset in
              print("스크롤 오프셋: \(offset)")
            }) {
    VStack(spacing: 16) {
        ForEach(0..<20) { index in
            Text("항목 \(index)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    .padding()
}
.axis(.vertical)
.hidesIndicators()
.onRefresh {
    // 새로고침 작업 수행
    try? await Task.sleep(nanoseconds: 2_000_000_000)
}
```

- SeeAlso: `ScrollView.ScrollStatus`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(scrollStatus:onOffsetChanged:content:)</code></summary>

```swift
public init(
    scrollStatus: Binding<ScrollStatus>? = nil,
    onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: @escaping () -> any View
)
```

스크롤 뷰를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| scrollStatus | 스크롤 상태를 추적하기 위한 바인딩 (선택 사항) |
| onOffsetChanged | 스크롤 오프셋이 변경될 때 호출되는 클로저 (기본값: 빈 클로저) |
| content | 스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저 |




</details>

<details><summary markdown="span"><code>axis(_:)</code></summary>

```swift
public func axis(_ axis: Axis) -> Self
```

스크롤 방향을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| axis | 스크롤 방향 (.vertical 또는 .horizontal) |

#### Returns

수정된 스크롤 뷰



</details>

<details><summary markdown="span"><code>hidesIndicators(_:)</code></summary>

```swift
public func hidesIndicators(_ hidesIndicators: Bool = true) -> Self
```

스크롤 인디케이터 표시 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| hidesIndicators | 인디케이터를 숨길지 여부 (기본값: true) |

#### Returns

수정된 스크롤 뷰



</details>

<details><summary markdown="span"><code>onRefresh(_:)</code></summary>

```swift
public func onRefresh(_ perform: @escaping () async -> Void) -> Self
```

당겨서 새로고침 동작을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| perform | 새로고침 시 실행할 비동기 작업 |

#### Returns

수정된 스크롤 뷰



</details>
