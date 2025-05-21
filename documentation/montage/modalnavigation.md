---
title: ModalNavigation
description: 모달 내에서 사용하는 내비게이션 바 컴포넌트입니다.
---

```swift
@MainActor struct ModalNavigation
```

## Overview

모달 상단에 제목, 뒤로가기 버튼, 추가 버튼 등을 포함하는 내비게이션 바를 제공합니다. 스크롤에 따라 배경 불투명도가 자동으로 조절되며 다양한 스타일을 지원합니다.

```swift
ModalNavigation(title: "제목")
    .variant(.normal)
    .leadingButton(.back {
        // 뒤로가기 동작
    })
    .trailingButtons([
        .icon(.close, action: {
            // 닫기 동작
        })
    ])
```

>  See Also
>
> `ModalNavigation.Variant`, `TopNavigation`

## Topics

### Initializers


``init(title: String, scrollOffset: Binding<CGFloat>)``

내비게이션 바를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `title` | 내비게이션 바에 표시할 제목 |
  | `scrollOffset` | 스크롤 오프셋에 대한 바인딩 (기본값: .constant(0)) |

### Instance Properties


``var body: some View``

### Instance Methods


``func backgroundColor(SwiftUI.Color) -> ModalNavigation``

내비게이션 바의 배경색을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `backgroundColor` | 배경색 |
- **Return Value**

  수정된 내비게이션 바 뷰

``func leadingButton(TopNavigation.Resource.LeadingButton?) -> ModalNavigation``

내비게이션 바의 왼쪽 버튼을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `leadingButton` | 왼쪽 버튼 설정 |
- **Return Value**

  수정된 내비게이션 바 뷰

``func needHandleArea(Bool) -> ModalNavigation``

바텀 시트의 핸들 영역 필요 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `needHandleArea` | 핸들 영역 필요 여부 |
- **Return Value**

  수정된 내비게이션 바 뷰

``func scrollOffset(Binding<CGFloat>) -> ModalNavigation``

스크롤 오프셋을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `scrollOffset` | 스크롤 오프셋에 대한 바인딩 |
- **Return Value**

  수정된 내비게이션 바 뷰

``func trailingButtons([TopNavigation.Resource.TrailingButton]) -> ModalNavigation``

내비게이션 바의 오른쪽 버튼들을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `actions` | 오른쪽 버튼 배열 (최대 3개까지 표시) |
- **Return Value**

  수정된 내비게이션 바 뷰

``func variant(Variant) -> ModalNavigation``

내비게이션 바의 스타일을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 내비게이션 바 스타일 |
- **Return Value**

  수정된 내비게이션 바 뷰

### Enumerations


[``enum Variant``](/documentation/montage/modalnavigation/variant.md)

내비게이션 바의 외관을 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/modalnavigation/view-implementations.md)

[View Implementations](/documentation/montage/modalnavigation/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



