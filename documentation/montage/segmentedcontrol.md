---
1title: segmentedcontrol
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# SegmentedControl 

여러 옵션 중 하나를 선택할 수 있는 세그먼트 컨트롤 컴포넌트입니다.

```swift
@MainActor
struct SegmentedControl
```

## Overview 

제한된 옵션 세트 내에서 선택할 수 있도록 하는 가로로 정렬된 버튼 그룹입니다. 각 세그먼트는 이미지와 텍스트를 포함할 수 있으며, 선택된 세그먼트는 시각적으로 강조됩니다.

**사용 예시**:

```swift
@State private var selectedIndex = 0

// 텍스트만 있는 세그먼트 컨트롤
SegmentedControl(
    selectedIndex: $selectedIndex,
    labels: ["첫 번째", "두 번째", "세 번째"]
)

// 이미지와 텍스트가 모두 있는 세그먼트 컨트롤
SegmentedControl(
    selectedIndex: $selectedIndex,
    items: [
        .init(image: .montage(.home), title: "홈"),
        .init(image: .montage(.person), title: "프로필"),
        .init(title: "설정")
    ]
)
.variant(.outlined)
.size(.medium)
```

> **Note**
>
> 기본 변형(.solid)은 배경이 있는 형태로, .outlined 변형은 테두리만 있는 형태로 표시됩니다.

## Topics 

### Structures 

- [struct Item](/documentation/montage/segmentedcontrol/item.md)

  세그먼트 컨트롤의 항목을 나타내는 구조체입니다.

### Initializers 

- [init(selectedIndex: Binding<Int>, items: [Item], onSelect: ((Int) -> Void)?)](/documentation/montage/segmentedcontrol/init(selectedindex:items:onselect:).md)

  항목 배열을 이용해 세그먼트 컨트롤을 초기화합니다.

- [init(selectedIndex: Binding<Int>, labels: [String], onSelect: ((Int) -> Void)?)](/documentation/montage/segmentedcontrol/init(selectedindex:labels:onselect:).md)

  텍스트 배열을 이용해 세그먼트 컨트롤을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/segmentedcontrol/body.md)

### Instance Methods 

- [func size(Size) -> SegmentedControl](/documentation/montage/segmentedcontrol/size(_:).md)

  세그먼트 컨트롤의 크기를 설정합니다.

- [func variant(Variant) -> SegmentedControl](/documentation/montage/segmentedcontrol/variant(_:).md)

  세그먼트 컨트롤의 시각적 스타일을 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/segmentedcontrol/size.md)

  세그먼트 컨트롤의 크기를 정의하는 열거형입니다.

- [enum Variant](/documentation/montage/segmentedcontrol/variant.md)

  세그먼트 컨트롤의 시각적 스타일을 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

