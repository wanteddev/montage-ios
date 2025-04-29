Initializer

# init(isPresented:ignoresEdgeInsets:_:navigation:actionAreaModel:) 

팝업 모달 모디파이어를 초기화합니다.

```swift
@MainActor
init(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

## Parameters 

isPresented

팝업 모달 표시 여부에 대한 바인딩

ignoresEdgeInsets

여백 무시 여부 (기본값: false)

content

모달에 표시할 콘텐츠를 반환하는 클로저

navigation

내비게이션 바를 반환하는 클로저 (선택 사항)

actionAreaModel

액션 영역 모델 (선택 사항)

