---
1title: textfield
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# TextInput.TextField 

단일 라인 텍스트 입력을 위한 컴포넌트입니다.

```swift
@MainActor
struct TextField
```

## Overview 

이 컴포넌트는 사용자가 텍스트를 입력할 수 있는 필드를 제공합니다. 제목, 아이콘, 자동완성, 상태 표시 등 다양한 기능을 지원합니다.

## 사용 예시 

```swift
@State private var inputText = ""

// 기본 텍스트 필드
TextInput.TextField(text: $inputText)
   .heading("이메일")
   .placeholder("이메일을 입력하세요")

// 아이콘이 있는 필수 입력 필드
TextInput.TextField(text: $inputText)
   .heading("아이디")
   .requiredBadge(true)
   .icon(.person)
   .status(.negative(description: "올바른 아이디를 입력해주세요"))

// 오른쪽 버튼이 있는 텍스트 필드
TextInput.TextField(text: $inputText)
   .trailingButton(
       .init(
           variant: .primary,
           title: "인증",
           handler: { verifyCode() }
       )
   )
```

## Topics 

### Structures 

- [struct AutoCompletionDataSource](/documentation/montage/textinput/textfield/autocompletiondatasource.md)

  텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.

- [struct TrailingButton](/documentation/montage/textinput/textfield/trailingbutton.md)

  텍스트 필드의 오른쪽에 표시할 버튼의 속성을 정의합니다.

### Initializers 

- [init(text: Binding<String>, autoCompletionDataSource: Binding<AutoCompletionDataSource?>)](/documentation/montage/textinput/textfield/init(text:autocompletiondatasource:).md)

  텍스트 필드를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/textinput/textfield/body.md)

### Instance Methods 

- [func backgroundColor(SwiftUI.Color?) -> TextInput.TextField](/documentation/montage/textinput/textfield/backgroundcolor(_:).md)

  텍스트 필드의 배경색을 설정합니다.

- [func disable(Bool) -> TextInput.TextField](/documentation/montage/textinput/textfield/disable(_:).md)

  텍스트 필드의 활성화 상태를 설정합니다.

- [func heading(String?) -> TextInput.TextField](/documentation/montage/textinput/textfield/heading(_:).md)

  텍스트 필드 위에 표시할 제목을 설정합니다.

- [func icon(Icon?) -> TextInput.TextField](/documentation/montage/textinput/textfield/icon(_:).md)

  텍스트 필드 왼쪽에 표시할 아이콘을 설정합니다.

- [func placeholder(String?) -> TextInput.TextField](/documentation/montage/textinput/textfield/placeholder(_:).md)

  텍스트 필드에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

- [func requiredBadge(Bool) -> TextInput.TextField](/documentation/montage/textinput/textfield/requiredbadge(_:).md)

  제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

- [func status(Status) -> TextInput.TextField](/documentation/montage/textinput/textfield/status(_:).md)

  텍스트 필드의 상태를 설정합니다.

- [func trailingButton(TrailingButton?) -> TextInput.TextField](/documentation/montage/textinput/textfield/trailingbutton(_:).md)

  텍스트 필드 오른쪽에 표시할 버튼을 설정합니다.

- [func trailingContent((() -> any View)?) -> TextInput.TextField](/documentation/montage/textinput/textfield/trailingcontent(_:).md)

  텍스트 필드 오른쪽에 표시할 커스텀 콘텐츠를 설정합니다.

### Enumerations 

- [enum Status](/documentation/montage/textinput/textfield/status.md)

  텍스트 필드의 상태를 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

