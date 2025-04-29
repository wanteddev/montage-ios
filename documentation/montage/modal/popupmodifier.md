Structure

# Modal.PopupModifier 

팝업 모달을 표시하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct PopupModifier
```

## Overview 

이 모디파이어를 사용하면 팝업 모달을 자연스러운 애니메이션과 함께 표시하고 설정할 수 있습니다.

**사용 예시**:

```swift
@State private var showPopup = false

Button("팝업 열기") {
    showPopup = true
}
.modifier(
    Modal.PopupModifier(
        isPresented: $showPopup
    ) {
        VStack(spacing: 16) {
            Text("알림")
            Text("중요한 메시지입니다.")
            Button("확인") {
                showPopup = false
            }
        }
    }
)
```

> **See Also**
>
> Modal.Popup

## Topics 

### Initializers 

- [init(isPresented: Binding<Bool>, ignoresEdgeInsets: Bool, () -> any View, navigation: (() -> Modal.Navigation)?, actionAreaModel: ActionAreaModifier.Model?)](/documentation/montage/modal/popupmodifier/init(ispresented:ignoresedgeinsets:_:navigation:actionareamodel:).md)

  팝업 모달 모디파이어를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/modal/popupmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/modal/popupmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

