**STRUCT**

# `Modal.BottomSheetModifier`

```swift
public struct BottomSheetModifier: ViewModifier
```

바텀 시트를 표시하기 위한 뷰 모디파이어입니다.

이 모디파이어를 사용하면 바텀 시트를 쉽게 표시하고 설정할 수 있습니다.

**사용 예시**:
```swift
@State private var showBottomSheet = false

Button("바텀 시트 열기") {
    showBottomSheet = true
}
.modifier(
    Modal.BottomSheetModifier(
        isPresented: $showBottomSheet,
        needHandle: true, 
        resize: .flexible
    ) {
        Text("바텀 시트 내용")
    }
)
```

- SeeAlso: `Modal.BottomSheet`

## Methods
<details><summary markdown="span"><code>init(isPresented:_:needHandle:resize:ignoresEdgeInsets:navigation:actionAreaModel:)</code></summary>

```swift
public init(
    isPresented: Binding<Bool>,
    _ content: @escaping () -> any View,
    needHandle: Bool = true,
    resize: BottomSheet.Resize = .hug,
    ignoresEdgeInsets: Bool = false,
    navigation: ( () -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

바텀 시트 모디파이어를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 바텀 시트 표시 여부에 대한 바인딩 |
| content | 바텀 시트에 표시할 콘텐츠를 반환하는 클로저 |
| needHandle | 핸들 표시 여부 (기본값: true) |
| resize | 크기 조절 방식 (기본값: .hug) |
| ignoresEdgeInsets | 여백 무시 여부 (기본값: false) |
| navigation | 내비게이션 바를 반환하는 클로저 (선택 사항) |
| actionAreaModel | 액션 영역 모델 (선택 사항) |




</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
