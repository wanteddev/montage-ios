---
1title: control
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Control 

체크박스, 체크마크, 라디오 버튼과 같은 선택 컨트롤을 제공하는 컴포넌트입니다.

```swift
@MainActor
struct Control
```

## Overview 

다양한 유형의 선택 컨트롤을 통일된 인터페이스로 제공합니다. 선택 상태 변경 시 콜백을 받을 수 있으며, 크기와 스타일을 조정할 수 있습니다.

**사용 예시**:

```swift
// 체크박스
Control.checkbox(checked: true) { isChecked in
    print("체크박스 선택 상태: \(isChecked)")
}

// 라디오 버튼
Control.radio(checked: false)
    .tight()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Control.checkmark($isChecked)
```

> **Note**
>
> 모든 컨트롤은 상태에 따라 적절한 시각적 피드백을 제공합니다.

## Topics 

### Structures 

- [struct Switch](/documentation/montage/control/switch.md)

  켜기/끄기 상태 전환이 가능한 스위치 컴포넌트입니다.

### Instance Properties 

- [var body: some View](/documentation/montage/control/body.md)

### Instance Methods 

- [func disable(Bool) -> Control](/documentation/montage/control/disable(_:).md)

  컨트롤을 비활성화합니다.

- [func tight(Bool) -> Control](/documentation/montage/control/tight(_:).md)

  컨트롤을 더 조밀한 레이아웃으로 표시합니다.

### Type Methods 

- [static func checkbox(Binding<Bool>, size: Size) -> Control](/documentation/montage/control/checkbox(_:size:)-2pprr.md)

  불리언 바인딩을 이용해 체크박스를 생성합니다.

- [static func checkbox(Binding<State>, size: Size) -> Control](/documentation/montage/control/checkbox(_:size:)-4sgua.md)

  상태 바인딩을 이용해 체크박스를 생성합니다.

- [static func checkbox(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control](/documentation/montage/control/checkbox(checked:size:onselect:).md)

  불리언 값을 이용해 체크박스를 생성합니다.

- [static func checkbox(state: State, size: Size, onSelect: ((State) -> Void)?) -> Control](/documentation/montage/control/checkbox(state:size:onselect:).md)

  상태 값을 이용해 체크박스를 생성합니다.

- [static func checkmark(Binding<Bool>, size: Size) -> Control](/documentation/montage/control/checkmark(_:size:).md)

  불리언 바인딩을 이용해 체크마크를 생성합니다.

- [static func checkmark(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control](/documentation/montage/control/checkmark(checked:size:onselect:).md)

  불리언 값을 이용해 체크마크를 생성합니다.

- [static func radio(Binding<Bool>, size: Size) -> Control](/documentation/montage/control/radio(_:size:).md)

  불리언 바인딩을 이용해 라디오 버튼을 생성합니다.

- [static func radio(checked: Bool, size: Size, onSelect: ((Bool) -> Void)?) -> Control](/documentation/montage/control/radio(checked:size:onselect:).md)

  불리언 값을 이용해 라디오 버튼을 생성합니다.

### Enumerations 

- [enum Size](/documentation/montage/control/size.md)

  컨트롤의 크기를 정의하는 열거형입니다.

- [enum State](/documentation/montage/control/state.md)

  컨트롤의 상태를 정의하는 열거형입니다.

- [enum Variant](/documentation/montage/control/variant.md)

  컨트롤의 종류를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

