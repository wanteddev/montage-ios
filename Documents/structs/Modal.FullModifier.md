**STRUCT**

# `Modal.FullModifier`

```swift
public struct FullModifier: ViewModifier
```

풀스크린 모달을 표시하기 위한 뷰 모디파이어입니다.

이 모디파이어를 사용하면 풀스크린 모달을 쉽게 표시하고 설정할 수 있습니다.

**사용 예시**:
```swift
@State private var showFullModal = false

Button("전체 화면 모달 열기") {
    showFullModal = true
}
.modifier(
    Modal.FullModifier(
        isPresented: $showFullModal
    ) {
        Text("풀스크린 모달 내용")
    }
)
```

- SeeAlso: `Modal.Full`

## Methods
<details><summary markdown="span"><code>init(isPresented:ignoresEdgeInsets:_:navigation:actionAreaModel:)</code></summary>

```swift
public init(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

풀스크린 모달 모디파이어를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 풀스크린 모달 표시 여부에 대한 바인딩 |
| ignoresEdgeInsets | 여백 무시 여부 (기본값: false) |
| content | 모달에 표시할 콘텐츠를 반환하는 클로저 |
| navigation | 내비게이션 바를 반환하는 클로저 (선택 사항) |
| actionAreaModel | 액션 영역 모델 (선택 사항) |




</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
