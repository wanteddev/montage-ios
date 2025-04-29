Structure

# TextInput.TextArea 

여러 줄의 텍스트 입력을 위한 컴포넌트입니다.

```swift
@MainActor
struct TextArea
```

## Overview 

이 컴포넌트는 사용자가 여러 줄의 텍스트를 입력할 수 있는 영역을 제공합니다. 제목, 배지, 리사이즈 옵션, 캐릭터 카운터 등 다양한 기능을 지원합니다.

## 사용 예시 

```swift
@State private var longText = ""
@FocusState private var isFocused: Bool

// 기본 텍스트 영역
TextInput.TextArea(text: $longText, focus: $isFocused)
    .heading("의견")
    .placeholder("의견을 입력해주세요")

// 문자 수 제한과 고정 크기를 가진 텍스트 영역
TextInput.TextArea(text: $longText)
    .resize(.fixed(min: 100, max: 200))
    .bottomResources(
        trailing: [.characterCount(limit: 100)]
    )

// 필수 항목 표시와 설명이 있는 텍스트 영역
TextInput.TextArea(text: $longText)
    .heading("상세 설명")
    .requiredBadge(true)
    .description("최대한 자세히 작성해주세요")
```

## Topics 

### Initializers 

- [init(text: Binding<String>, focus: FocusState<Bool>.Binding?)](/documentation/montage/textinput/textarea/init(text:focus:).md)

  텍스트 영역을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/textinput/textarea/body.md)

### Instance Methods 

- [func bottomResources(leading: [Resource], trailing: [Resource], leadingResourceSpacing: CGFloat, trailingResourceSpacing: CGFloat) -> TextInput.TextArea](/documentation/montage/textinput/textarea/bottomresources(leading:trailing:leadingresourcespacing:trailingresourcespacing:).md)

  텍스트 영역 하단에 표시할 UI 요소를 설정합니다.

- [func description(String?) -> TextInput.TextArea](/documentation/montage/textinput/textarea/description(_:).md)

  텍스트 영역 하단에 표시할 설명 텍스트를 설정합니다.

- [func disable(Bool) -> TextInput.TextArea](/documentation/montage/textinput/textarea/disable(_:).md)

  텍스트 영역의 활성화 상태를 설정합니다.

- [func heading(String?) -> TextInput.TextArea](/documentation/montage/textinput/textarea/heading(_:).md)

  텍스트 영역 위에 표시할 제목을 설정합니다.

- [func negative(Bool) -> TextInput.TextArea](/documentation/montage/textinput/textarea/negative(_:).md)

  텍스트 영역의 오류 상태를 설정합니다.

- [func placeholder(String?) -> TextInput.TextArea](/documentation/montage/textinput/textarea/placeholder(_:).md)

  텍스트 영역에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

- [func requiredBadge(Bool) -> TextInput.TextArea](/documentation/montage/textinput/textarea/requiredbadge(_:).md)

  제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

- [func resize(Resize) -> TextInput.TextArea](/documentation/montage/textinput/textarea/resize(_:).md)

  텍스트 영역의 크기 조절 방식을 설정합니다.

### Enumerations 

- [enum Resize](/documentation/montage/textinput/textarea/resize.md)

  텍스트 영역의 크기 조절 방식을 정의합니다.

- [enum Resource](/documentation/montage/textinput/textarea/resource.md)

  텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

