Instance Method

# popupModal(isPresented:ignoresEdgeInsets:actionAreaModel:_:navigation:) 

팝업 형태의 모달을 표시합니다.MontageSwiftUICore

```swift
@MainActor
func popupModal(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

## Parameters 

isPresented

모달 표시 여부를 제어하는 바인딩

ignoresEdgeInsets

모달 내용이 Edge 인셋을 무시할지 여부

actionAreaModel

모달 하단에 표시할 액션 영역 모델

content

모달에 표시할 콘텐츠 클로저

navigation

모달 상단에 표시할 네비게이션 클로저

## Return Value 

팝업 모달이 적용된 뷰

## Discussion 

전체 화면을 어둡게 하고 그 위에 팝업 형태의 모달을 표시합니다.

