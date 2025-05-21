---
title: Category
description: 카테고리 선택 옵션을 가로로 나열하는 컴포넌트입니다.
---

```swift
@MainActor struct Category
```

## Overview

사용자가 카테고리 목록에서 하나의 항목을 선택할 수 있는 스크롤 가능한 컴포넌트입니다. 다양한 크기와 스타일을 지원하며, 선택된 항목에 대한 시각적 피드백을 제공합니다.

```swift
@State private var selectedIndex = 0
let categories = ["전체", "디자인", "개발", "마케팅", "경영"]

Category(
    selectedIndex: $selectedIndex,
    items: categories,
    actions: { index in
        print("선택된 카테고리: \(categories[index])")
    }
)
.variant(.alternative)
.size(.medium)
.horizontalPadding()
```

>  Note
>
> 측면 그라데이션 효과와 아이콘 버튼을 추가할 수 있어 스크롤 가능한 콘텐츠임을 시각적으로 나타냅니다.

## Topics

### Initializers


``init(selectedIndex: Binding<Int>, items: [String], actions: (Int) -> Void)``

카테고리 컴포넌트를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `selectedIndex` | 현재 선택된 항목의 인덱스 바인딩 |
  | `items` | 표시할 카테고리 항목 배열 |
  | `actions` | 항목 선택 시 호출될 클로저 (기본값: 빈 클로저) |

### Instance Properties


``var body: some View``

### Instance Methods


``func horizontalPadding(Bool) -> Category``

카테고리 컴포넌트의 좌우 패딩을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `horizontalPadding` | 패딩 적용 여부 (기본값: true) |
- **Return Value**

  수정된 카테고리 인스턴스

``func iconButton(Icon, action: () -> Void) -> Category``

카테고리 컴포넌트 오른쪽에 표시할 아이콘 버튼을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
  | `action` | 버튼 클릭 시 실행할 액션 |
- **Return Value**

  수정된 카테고리 인스턴스

``func size(Size) -> Category``

카테고리 아이템 크기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 아이템 크기 (.small, .medium, .large, .xlarge) |
- **Return Value**

  수정된 카테고리 인스턴스

``func variant(Variant) -> Category``

카테고리 아이템 스타일을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 아이템 스타일 (.normal 또는 .alternative) |
- **Return Value**

  수정된 카테고리 인스턴스

``func verticalPadding(Bool) -> Category``

카테고리 컴포넌트의 상하 패딩을 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `verticalPadding` | 패딩 적용 여부 (기본값: true) |
- **Return Value**

  수정된 카테고리 인스턴스

### Enumerations


[``enum Size``](/documentation/montage/category/size.md)

카테고리 사이즈를 결정하는 열거형입니다.

[``enum Variant``](/documentation/montage/category/variant.md)

카테고리 아이템의 종류를 결정하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/category/view-implementations.md)

[View Implementations](/documentation/montage/category/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



