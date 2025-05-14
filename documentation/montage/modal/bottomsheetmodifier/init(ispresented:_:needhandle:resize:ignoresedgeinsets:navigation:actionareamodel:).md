---
1title: init(ispresented:_:needhandle:resize:ignoresedgeinsets:navigation:actionareamodel:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(isPresented:_:needHandle:resize:ignoresEdgeInsets:navigation:actionAreaModel:) 

바텀 시트 모디파이어를 초기화합니다.

```swift
@MainActor
init(
    isPresented: Binding<Bool>,
    _ content: @escaping () -> any View,
    needHandle: Bool = true,
    resize: BottomSheet.Resize = .hug,
    ignoresEdgeInsets: Bool = false,
    navigation: (() -> Modal.Navigation)? = nil,
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

## Parameters 

isPresented

바텀 시트 표시 여부에 대한 바인딩

content

바텀 시트에 표시할 콘텐츠를 반환하는 클로저

needHandle

핸들 표시 여부 (기본값: true)

resize

크기 조절 방식 (기본값: .hug)

ignoresEdgeInsets

여백 무시 여부 (기본값: false)

navigation

내비게이션 바를 반환하는 클로저 (선택 사항)

actionAreaModel

액션 영역 모델 (선택 사항)

