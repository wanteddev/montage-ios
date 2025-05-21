---
title: TextField
description: 단일 라인 텍스트 입력을 위한 컴포넌트입니다.
---

```swift
@MainActor struct TextField
```

## Overview

이 컴포넌트는 사용자가 텍스트를 입력할 수 있는 필드를 제공합니다. 제목, 아이콘, 자동완성, 상태 표시 등 다양한 기능을 지원합니다.

```swift
@State private var inputText = ""

// 기본 텍스트 필드
TextField(text: $inputText)
   .heading("이메일")
   .placeholder("이메일을 입력하세요")

// 아이콘이 있는 필수 입력 필드
TextField(text: $inputText)
   .heading("아이디")
   .requiredBadge(true)
   .icon(.person)
   .status(.negative(description: "올바른 아이디를 입력해주세요"))

// 오른쪽 버튼이 있는 텍스트 필드
TextField(text: $inputText)
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


[``struct AutoCompletionDataSource``](/documentation/montage/textfield/autocompletiondatasource.md)

텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.

[``struct TrailingButton``](/documentation/montage/textfield/trailingbutton.md)

텍스트 필드의 오른쪽에 표시할 버튼의 속성을 정의합니다.

### Initializers


``init(text: Binding<String>, autoCompletionDataSource: Binding<AutoCompletionDataSource?>)``

텍스트 필드를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 텍스트 필드의 값을 바인딩 |
  | `autoCompletionDataSource` | 자동완성 데이터 소스를 바인딩, 기본값은 nil |
- **Return Value**

  구성된 텍스트 필드 인스턴스

### Instance Properties


``var body: some View``

### Instance Methods


``func backgroundColor(SwiftUI.Color?) -> TextField``

텍스트 필드의 배경색을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 배경색 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func disable(Bool) -> TextField``

텍스트 필드의 활성화 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부, `true`이면 비활성화 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func heading(String?) -> TextField``

텍스트 필드 위에 표시할 제목을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `heading` | 표시할 제목, nil이면 제목 표시 안함 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func icon(Icon?) -> TextField``

텍스트 필드 왼쪽에 표시할 아이콘을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func placeholder(String?) -> TextField``

텍스트 필드에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placeholder` | 표시할 플레이스홀더 텍스트 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func requiredBadge(Bool) -> TextField``

제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `requiredBadge` | 필수 입력 뱃지 표시 여부 |
- **Return Value**

  수정된 텍스트 필드 인스턴스
- **Discussion**
  >  Note
  >
  > 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다.


``func status(Status) -> TextField``

텍스트 필드의 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `status` | 텍스트 필드의 상태 |
- **Return Value**

  수정된 텍스트 필드 인스턴스

``func trailingButton(TrailingButton?) -> TextField``

텍스트 필드 오른쪽에 표시할 버튼을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `trailingButton` | 표시할 버튼의 속성 |
- **Return Value**

  수정된 텍스트 필드 인스턴스
- **Discussion**
  >  Note
  >
  > `trailingContent`와 함께 사용될 경우 `trailingButton`이 우선적으로 표시됩니다.


``func trailingContent((() -> any View)?) -> TextField``

텍스트 필드 오른쪽에 표시할 커스텀 콘텐츠를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `trailingContent` | 표시할 커스텀 콘텐츠를 생성하는 클로저 |
- **Return Value**

  수정된 텍스트 필드 인스턴스
- **Discussion**
  >  Note
  >
  > `trailingButton`과 함께 사용하는 경우 `trailingContent`가 무시됩니다.


### Enumerations


[``enum Status``](/documentation/montage/textfield/status.md)

텍스트 필드의 상태를 정의합니다.

### Default Implementations


[View Implementations](/documentation/montage/textfield/view-implementations.md)

[View Implementations](/documentation/montage/textfield/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



