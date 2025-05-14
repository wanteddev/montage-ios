---
1title: popup
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Modal.Popup 

화면 중앙에 표시되는 팝업 모달 컴포넌트입니다.

```swift
@MainActor
struct Popup
```

## Overview 

배경을 어둡게 처리하고 화면 중앙에 콘텐츠를 표시하는 형태의 모달입니다. 내비게이션 바와 액션 영역을 설정할 수 있으며, 애니메이션과 함께 표시됩니다.

**사용 예시**:

```swift
@State private var showPopup = false

Button("팝업 열기") {
    showPopup = true
}
.fullScreenCover(isPresented: $showPopup) {
    Modal.Popup {
        VStack(spacing: 16) {
            Text("알림")
                .font(.headline)
            Text("중요한 메시지입니다.")
            
            Button("확인") {
                showPopup = false
            }
        }
        .padding()
    }
}
.transaction { transaction in
    transaction.disablesAnimations = true
}
```

모디파이어를 사용하면 더 간편하게 구현할 수 있으며, 애니메이션이 자동으로 처리됩니다:

```swift
YourView()
    .modifier(
        Modal.PopupModifier(
            isPresented: $showPopup
        ) {
            Text("팝업 내용")
        }
    )
```

> **See Also**
>
> Modal.PopupModifier, Modal.Navigation, ActionAreaModifier.Model

## Topics 

### Initializers 

- [init(() -> any View)](/documentation/montage/modal/popup/init(_:).md)

  팝업 모달을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/modal/popup/body.md)

### Instance Methods 

- [func ignoresEdgeInsets(Bool) -> Modal.Popup](/documentation/montage/modal/popup/ignoresedgeinsets(_:).md)

  컨텐츠의 기본 여백을 무시할지 설정합니다.

- [func modalActionArea(ActionAreaModifier.Model?) -> Modal.Popup](/documentation/montage/modal/popup/modalactionarea(_:).md)

  팝업 모달 하단에 액션 영역을 설정합니다.

- [func modalNavigation((() -> Montage.Modal.Navigation)?) -> Modal.Popup](/documentation/montage/modal/popup/modalnavigation(_:).md)

  팝업 모달 상단에 내비게이션 바를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

