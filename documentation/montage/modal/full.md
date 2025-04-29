Structure

# Modal.Full 

화면 전체를 덮는 풀스크린 모달 컴포넌트입니다.

```swift
@MainActor
struct Full
```

## Overview 

SwiftUI의 .fullScreenCover 수정자와 함께 사용하여 전체 화면을 덮는 모달을 구현합니다. 내비게이션 바와 액션 영역을 설정할 수 있습니다.

**사용 예시**:

```swift
@State private var showFullModal = false

Button("전체 화면 모달 열기") {
    showFullModal = true
}
.fullScreenCover(isPresented: $showFullModal) {
    Modal.Full {
        VStack(spacing: 20) {
            Text("풀스크린 모달 내용")
            Button("닫기") {
                showFullModal = false
            }
        }
        .padding()
    }
    .modalNavigation {
        Modal.Navigation(title: "제목")
            .leadingButton(.back {
                showFullModal = false
            })
    }
}
```

모디파이어를 사용하면 더 간편하게 구현할 수 있습니다:

```swift
YourView()
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
> Modal.FullModifier, Modal.Navigation, ActionAreaModifier.Model

## Topics 

### Initializers 

- [init(() -> any View)](/documentation/montage/modal/full/init(_:).md)

  풀스크린 모달을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/modal/full/body.md)

### Instance Methods 

- [func ignoresEdgeInsets(Bool) -> Modal.Full](/documentation/montage/modal/full/ignoresedgeinsets(_:).md)

  컨텐츠의 기본 여백을 무시할지 설정합니다.

- [func modalActionArea(ActionAreaModifier.Model?) -> Modal.Full](/documentation/montage/modal/full/modalactionarea(_:).md)

  풀스크린 모달 하단에 액션 영역을 설정합니다.

- [func modalNavigation((() -> Montage.Modal.Navigation)?) -> Modal.Full](/documentation/montage/modal/full/modalnavigation(_:).md)

  풀스크린 모달 상단에 내비게이션 바를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

