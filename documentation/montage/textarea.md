---
title: TextArea
description: 여러 줄의 텍스트 입력을 위한 컴포넌트입니다.
---

```swift
@MainActor struct TextArea
```

## Overview

이 컴포넌트는 사용자가 여러 줄의 텍스트를 입력할 수 있는 영역을 제공합니다. 제목, 배지, 리사이즈 옵션, 캐릭터 카운터 등 다양한 기능을 지원합니다.

```swift
@State private var longText = ""
@FocusState private var isFocused: Bool

// 기본 텍스트 영역
TextArea(text: $longText, focus: $isFocused)
    .heading("의견")
    .placeholder("의견을 입력해주세요")

// 문자 수 제한과 고정 크기를 가진 텍스트 영역
TextArea(text: $longText)
    .resize(.fixed(min: 100, max: 200))
    .bottomResources(
        trailing: [.characterCount(limit: 100)]
    )

// 필수 항목 표시와 설명이 있는 텍스트 영역
TextArea(text: $longText)
    .heading("상세 설명")
    .requiredBadge(true)
    .description("최대한 자세히 작성해주세요")
```

## Topics

### Initializers


``init(text: Binding<String>, focus: FocusState<Bool>.Binding?)``

텍스트 영역을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 텍스트 영역의 값을 바인딩 |
  | `focus` | 텍스트 영역의 포커스 상태를 바인딩 (선택 사항) |
- **Return Value**

  구성된 텍스트 영역 인스턴스

### Instance Properties


``var body: some View``

### Instance Methods


``func bottomResources(leading: [Resource], trailing: [Resource], leadingResourceSpacing: CGFloat, trailingResourceSpacing: CGFloat) -> TextArea``

텍스트 영역 하단에 표시할 UI 요소를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `leadingResources` | 왼쪽에 표시할 UI 요소 배열 (최대 3개) |
  | `trailingResources` | 오른쪽에 표시할 UI 요소 배열 (최대 3개) |
  | `leadingResourceSpacing` | 왼쪽 요소 간의 간격 |
  | `trailingResourceSpacing` | 오른쪽 요소 간의 간격 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

``func description(String?) -> TextArea``

텍스트 영역 하단에 표시할 설명 텍스트를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `description` | 표시할 설명 텍스트, nil이면 표시 안함 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

``func disable(Bool) -> TextArea``

텍스트 영역의 활성화 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부, `true`이면 비활성화 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

``func heading(String?) -> TextArea``

텍스트 영역 위에 표시할 제목을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `heading` | 표시할 제목, nil이면 제목 표시 안함 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

``func negative(Bool) -> TextArea``

텍스트 영역의 오류 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `negative` | 오류 상태 여부, 기본값은 `true` |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**

  오류 상태일 때는 텍스트 영역이 적색 테두리로 강조됩니다.

``func placeholder(String?) -> TextArea``

텍스트 영역에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placeholder` | 표시할 플레이스홀더 텍스트 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

``func requiredBadge(Bool) -> TextArea``

제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `requiredBadge` | 필수 입력 뱃지 표시 여부, 기본값은 `true` |
- **Return Value**

  수정된 텍스트 영역 인스턴스
- **Discussion**
  >  Note
  >
  > 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다.


``func resize(Resize) -> TextArea``

텍스트 영역의 크기 조절 방식을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `resize` | 크기 조절 방식 |
- **Return Value**

  수정된 텍스트 영역 인스턴스

### Enumerations


[``enum Resize``](/documentation/montage/textarea/resize.md)

텍스트 영역의 크기 조절 방식을 정의합니다.

[``enum Resource``](/documentation/montage/textarea/resource.md)

텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.

### Default Implementations


[View Implementations](/documentation/montage/textarea/view-implementations.md)

[View Implementations](/documentation/montage/textarea/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



