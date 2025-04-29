Structure

# Input 

텍스트와 함께 표시되는 선택 컨트롤 컴포넌트입니다.

```swift
@MainActor
struct Input
```

## Overview 

체크박스, 체크마크, 라디오 버튼과 같은 컨트롤을 텍스트 레이블과 함께 표시합니다. 사용자가 텍스트를 클릭하여 컨트롤의 상태를 변경할 수 있습니다.

**사용 예시**:

```swift
// 체크박스와 텍스트
Input.checkbox(checked: true, text: "이용약관에 동의합니다") { isChecked in
    print("동의 상태: \(isChecked)")
}

// 라디오 버튼과 텍스트
Input.radio(checked: false, text: "옵션 1")
    .bold()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Input.checkmark($isChecked, text: "완료됨")
```

> **Note**
>
> 컨트롤과 텍스트는 수직 정렬되어 표시됩니다.

## Topics 

### Instance Properties 

- [var body: some View](/documentation/montage/input/body.md)

### Instance Methods 

- [func bold(Bool) -> Input](/documentation/montage/input/bold(_:).md)

  텍스트를 볼드체로 설정합니다.

- [func disable(Bool) -> Input](/documentation/montage/input/disable(_:).md)

  컴포넌트를 비활성화합니다.

- [func size(Control.Size) -> Input](/documentation/montage/input/size(_:).md)

  컨트롤 사이즈를 설정합니다.

- [func tight(Bool) -> Input](/documentation/montage/input/tight(_:).md)

  컨트롤을 더 조밀한 레이아웃으로 표시합니다.

- [func title(Typography.Variant?, weight: Typography.Weight?, color: SwiftUI.Color?) -> Input](/documentation/montage/input/title(_:weight:color:).md)

  텍스트의 타이포그래피 속성을 설정합니다.

### Type Methods 

- [static func checkbox(Binding<Control.State>, text: String) -> Input](/documentation/montage/input/checkbox(_:text:)-319sq.md)

  상태 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

- [static func checkbox(Binding<Bool>, text: String) -> Input](/documentation/montage/input/checkbox(_:text:)-4bkjc.md)

  불리언 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

- [static func checkbox(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input](/documentation/montage/input/checkbox(checked:text:onselect:).md)

  불리언 값을 이용해 체크박스와 텍스트를 생성합니다.

- [static func checkbox(state: Control.State, text: String, onSelect: ((Control.State) -> Void)?) -> Input](/documentation/montage/input/checkbox(state:text:onselect:).md)

  상태 값을 이용해 체크박스와 텍스트를 생성합니다.

- [static func checkmark(Binding<Bool>, text: String) -> Input](/documentation/montage/input/checkmark(_:text:).md)

  불리언 바인딩을 이용해 체크마크와 텍스트를 생성합니다.

- [static func checkmark(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input](/documentation/montage/input/checkmark(checked:text:onselect:).md)

  불리언 값을 이용해 체크마크와 텍스트를 생성합니다.

- [static func radio(Binding<Bool>, text: String) -> Input](/documentation/montage/input/radio(_:text:).md)

  불리언 바인딩을 이용해 라디오 버튼과 텍스트를 생성합니다.

- [static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)?) -> Input](/documentation/montage/input/radio(checked:text:onselect:).md)

  불리언 값을 이용해 라디오 버튼과 텍스트를 생성합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

