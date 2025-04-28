**STRUCT**

# `Modal.Full`

```swift
public struct Full: View
```

화면 전체를 덮는 풀스크린 모달 컴포넌트입니다.

SwiftUI의 .fullScreenCover 수정자와 함께 사용하여 
전체 화면을 덮는 모달을 구현합니다. 내비게이션 바와 액션 영역을
설정할 수 있습니다.

**사용 예시**:
```swift
@State private var showFullModal = false

Button("전체 화면 모달 열기") {
    showFullModal = true
}
.fullScreenCover(isPresented: $showFullModal) {
    Modal.Full {
        VStack(spacing: 20) {
            Text("풀스크린 모달 내용")
            Button("닫기") {
                showFullModal = false
            }
        }
        .padding()
    }
    .modalNavigation {
        Modal.Navigation(title: "제목")
            .leadingButton(.back {
                showFullModal = false
            })
    }
}
```

모디파이어를 사용하면 더 간편하게 구현할 수 있습니다:
```swift
YourView()
    .modifier(
        Modal.FullModifier(
            isPresented: $showFullModal
        ) {
            Text("풀스크린 모달 내용")
        }
    )
```

- SeeAlso: `Modal.FullModifier`, `Modal.Navigation`, `ActionAreaModifier.Model`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:)</code></summary>

```swift
public init(_ content: @escaping () -> any View)
```

풀스크린 모달을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 모달 내에 표시할 콘텐츠를 반환하는 클로저 |




</details>

<details><summary markdown="span"><code>ignoresEdgeInsets(_:)</code></summary>

```swift
public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self
```

컨텐츠의 기본 여백을 무시할지 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| ignoresEdgeInsets | 여백 무시 여부 |

#### Returns

수정된 풀스크린 모달 뷰



</details>

<details><summary markdown="span"><code>modalNavigation(_:)</code></summary>

```swift
public func modalNavigation(_ navigation: (() -> Montage.Modal.Navigation)?) -> Self
```

풀스크린 모달 상단에 내비게이션 바를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| navigation | 내비게이션 바를 반환하는 클로저 |

#### Returns

수정된 풀스크린 모달 뷰



</details>

<details><summary markdown="span"><code>modalActionArea(_:)</code></summary>

```swift
public func modalActionArea(_ actionAreaModel: ActionAreaModifier.Model?) -> Self
```

풀스크린 모달 하단에 액션 영역을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| actionAreaModel | 액션 영역 모델 |

#### Returns

수정된 풀스크린 모달 뷰



</details>
