Instance Method

# bottomSheetModal(isPresented:needHandle:resize:actionAreaModel:_:navigation:) 

바텀 시트 모달을 표시합니다.MontageSwiftUICore

```swift
@MainActor
func bottomSheetModal(
    isPresented: Binding<Bool>,
    needHandle: Bool = true,
    resize: Modal.BottomSheet.Resize = .hug,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

## Parameters 

isPresented

모달 표시 여부를 제어하는 바인딩

needHandle

상단 핸들 표시 여부 (기본값: true)

resize

모달 크기 조절 방식 (기본값: .hug)

actionAreaModel

모달 하단에 표시할 액션 영역 모델

content

모달에 표시할 콘텐츠 클로저

navigation

모달 상단에 표시할 네비게이션 클로저

## Return Value 

바텀 시트 모달이 적용된 뷰

## Discussion 

화면 하단에서 올라오는 시트 형태로 모달을 표시합니다.

