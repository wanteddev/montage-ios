---
1title: filter
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Chip.Filter 

필터링 기능을 제공하는 칩 컴포넌트입니다.

```swift
@MainActor
struct Filter
```

## Overview 

이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다. 다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.

**사용 예시**:

```swift
Chip.Filter(
    variant: .solid,
    size: .medium,
    text: "카테고리",
    state: $state
)
.backgroundColor(.semantic(.primary))
.fontColor(.semantic(.staticWhite))
.active(true)
.activeLabel("최신순")
```

## Topics 

### Initializers 

- [init(variant: Variant, size: Size, text: String, state: Binding<State>, handler: (() -> Void)?)](/documentation/montage/chip/filter/init(variant:size:text:state:handler:).md)

  필터 칩을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/chip/filter/body.md)

### Instance Methods 

- [func active(Bool, label: String?) -> Chip.Filter](/documentation/montage/chip/filter/active(_:label:).md)

  칩의 활성화 상태와 레이블을 설정합니다.

- [func activeColor(SwiftUI.Color) -> Chip.Filter](/documentation/montage/chip/filter/activecolor(_:).md)

  칩의 활성화 상태 색상을 설정합니다.

- [func backgroundColor(SwiftUI.Color) -> Chip.Filter](/documentation/montage/chip/filter/backgroundcolor(_:).md)

  칩의 배경색을 설정합니다.

- [func disabled(Bool) -> Chip.Filter](/documentation/montage/chip/filter/disabled(_:).md)

  칩의 비활성화 여부를 설정합니다.

- [func fontColor(SwiftUI.Color) -> Chip.Filter](/documentation/montage/chip/filter/fontcolor(_:).md)

  칩의 텍스트 색상을 설정합니다.

- [func iconColor(SwiftUI.Color) -> Chip.Filter](/documentation/montage/chip/filter/iconcolor(_:).md)

  아이콘의 색상을 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/chip/filter/size.md)

  칩의 크기를 정의합니다.

- [enum State](/documentation/montage/chip/filter/state.md)

  칩의 확장 상태를 정의합니다.

- [enum Variant](/documentation/montage/chip/filter/variant.md)

  칩의 외관을 결정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

