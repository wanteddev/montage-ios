Structure

# Modal.BottomSheetModifier 

바텀 시트를 표시하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct BottomSheetModifier
```

## Overview 

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

> **See Also**
>
> Modal.BottomSheet

## Topics 

### Initializers 

- [init(isPresented: Binding<Bool>, () -> any View, needHandle: Bool, resize: BottomSheet.Resize, ignoresEdgeInsets: Bool, navigation: (() -> Modal.Navigation)?, actionAreaModel: ActionAreaModifier.Model?)](/documentation/montage/modal/bottomsheetmodifier/init(ispresented:_:needhandle:resize:ignoresedgeinsets:navigation:actionareamodel:).md)

  바텀 시트 모디파이어를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/modal/bottomsheetmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/modal/bottomsheetmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

