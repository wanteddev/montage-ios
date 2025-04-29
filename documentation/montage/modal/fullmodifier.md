Structure

# Modal.FullModifier 

풀스크린 모달을 표시하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct FullModifier
```

## Overview 

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

> **See Also**
>
> Modal.Full

## Topics 

### Initializers 

- [init(isPresented: Binding<Bool>, ignoresEdgeInsets: Bool, () -> any View, navigation: (() -> Modal.Navigation)?, actionAreaModel: ActionAreaModifier.Model?)](/documentation/montage/modal/fullmodifier/init(ispresented:ignoresedgeinsets:_:navigation:actionareamodel:).md)

  풀스크린 모달 모디파이어를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/modal/fullmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/modal/fullmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

