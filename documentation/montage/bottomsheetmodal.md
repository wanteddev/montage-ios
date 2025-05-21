---
title: BottomSheetModal
description: 화면 하단에서 위로 올라오는 바텀 시트 모달 컴포넌트입니다.
---

```swift
@MainActor struct BottomSheetModal
```

## Overview

SwiftUI의 .sheet 수정자와 함께 사용하여 다양한 크기와 동작을 지원하는 바텀 시트를 구현합니다. 내비게이션 바, 액션 영역, 핸들 등의 요소를 설정할 수 있습니다.

```swift
@State private var showBottomSheet = false

Button("바텀 시트 열기") {
    showBottomSheet = true
}
.sheet(isPresented: $showBottomSheet) {
    BottomSheetModal {
        VStack(spacing: 16) {
            Text("바텀 시트 내용")
            Button("닫기") {
                showBottomSheet = false
            }
        }
    }
    .resize(.flexible)
    .modalNavigation {
        ModalNavigation(title: "제목")
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

>  See Also
>
> `BottomSheetModalModifier`, `ModalNavigation`, `ActionArea.Model`

## Topics

### Initializers


``init(() -> any View)``

바텀 시트 모달을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `content` | 모달 내에 표시할 콘텐츠를 반환하는 클로저 |

### Instance Properties


``var body: some View``

### Instance Methods


``func ignoresEdgeInsets(Bool) -> BottomSheetModal``

컨텐츠의 기본 여백을 무시할지 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `ignoresEdgeInsets` | 여백 무시 여부 |
- **Return Value**

  수정된 바텀 시트 뷰

``func modalActionArea(ActionArea.Model?) -> BottomSheetModal``

바텀 시트 하단에 액션 영역을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `actionAreaModel` | 액션 영역 모델 |
- **Return Value**

  수정된 바텀 시트 뷰

``func modalNavigation((() -> Montage.ModalNavigation)?) -> BottomSheetModal``

바텀 시트 상단에 내비게이션 바를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `navigation` | 내비게이션 바를 반환하는 클로저 |
- **Return Value**

  수정된 바텀 시트 뷰

``func needHandle(Bool) -> BottomSheetModal``

바텀 시트 상단의 핸들 표시 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `needHandle` | 핸들 표시 여부 |
- **Return Value**

  수정된 바텀 시트 뷰

``func resize(BottomSheetModal.Resize) -> BottomSheetModal``

바텀 시트의 크기 조절 방식을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `resize` | 크기 조절 방식 |
- **Return Value**

  수정된 바텀 시트 뷰

### Enumerations


[``enum Resize``](/documentation/montage/bottomsheetmodal/resize.md)

바텀 시트의 크기를 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/bottomsheetmodal/view-implementations.md)

[View Implementations](/documentation/montage/bottomsheetmodal/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



