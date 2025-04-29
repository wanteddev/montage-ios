Structure

# Modal.BottomSheet 

화면 하단에서 위로 올라오는 바텀 시트 모달 컴포넌트입니다.

```swift
@MainActor
struct BottomSheet
```

## Overview 

SwiftUI의 .sheet 수정자와 함께 사용하여 다양한 크기와 동작을 지원하는 바텀 시트를 구현합니다. 내비게이션 바, 액션 영역, 핸들 등의 요소를 설정할 수 있습니다.

**사용 예시**:

```swift
@State private var showBottomSheet = false

Button("바텀 시트 열기") {
    showBottomSheet = true
}
.sheet(isPresented: $showBottomSheet) {
    Modal.BottomSheet {
        VStack(spacing: 16) {
            Text("바텀 시트 내용")
            Button("닫기") {
                showBottomSheet = false
            }
        }
    }
    .resize(.flexible)
    .modalNavigation {
        Modal.Navigation(title: "제목")
    }
}
```

모디파이어를 사용하면 더 간편하게 구현할 수 있습니다:

```swift
YourView()
    .bottomSheetModal(
        isPresented: $showBottomSheet,
        resize: .hug
    ) {
        Text("바텀 시트 내용")
    }
```

> **See Also**
>
> Modal.BottomSheetModifier, Modal.Navigation, ActionAreaModifier.Model

## Topics 

### Initializers 

- [init(() -> any View)](/documentation/montage/modal/bottomsheet/init(_:).md)

  바텀 시트 모달을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/modal/bottomsheet/body.md)

### Instance Methods 

- [func ignoresEdgeInsets(Bool) -> Modal.BottomSheet](/documentation/montage/modal/bottomsheet/ignoresedgeinsets(_:).md)

  컨텐츠의 기본 여백을 무시할지 설정합니다.

- [func modalActionArea(ActionAreaModifier.Model?) -> Modal.BottomSheet](/documentation/montage/modal/bottomsheet/modalactionarea(_:).md)

  바텀 시트 하단에 액션 영역을 설정합니다.

- [func modalNavigation((() -> Montage.Modal.Navigation)?) -> Modal.BottomSheet](/documentation/montage/modal/bottomsheet/modalnavigation(_:).md)

  바텀 시트 상단에 내비게이션 바를 설정합니다.

- [func needHandle(Bool) -> Modal.BottomSheet](/documentation/montage/modal/bottomsheet/needhandle(_:).md)

  바텀 시트 상단의 핸들 표시 여부를 설정합니다.

- [func resize(Modal.BottomSheet.Resize) -> Modal.BottomSheet](/documentation/montage/modal/bottomsheet/resize(_:).md)

  바텀 시트의 크기 조절 방식을 설정합니다.

### Enumerations 

- [enum Resize](/documentation/montage/modal/bottomsheet/resize.md)

  바텀 시트의 크기를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

