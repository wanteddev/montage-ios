---
title: TopNavigation
description: 상단에 표시되는 내비게이션 바 컴포넌트입니다.
---

```swift
@MainActor struct TopNavigation
```

## Overview

제목, 뒤로가기 버튼, 추가 액션 버튼 등을 포함할 수 있으며, 다양한 외관 스타일을 지원합니다. 스크롤 시 배경색과 구분선의 불투명도가 자동으로 조절됩니다.

```swift
TopNavigation(
    variant: .normal,
    title: "제목",
    leadingButton: .back {
        // 뒤로가기 동작
    },
    trailingButtons: [
        .icon(.search) {
            // 검색 동작
        }
    ]
)
```

>  See Also
>
> `TopNavigation.Variant`, `TopNavigation.Resource`

## Topics

### Initializers


``init(variant: Variant, title: String, scrollOffset: CGFloat, backgroundColorResolvable: ColorResolvable?, leadingButton: Resource.LeadingButton?, trailingButtons: [Resource.TrailingButton])``

TopNavigation을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 내비게이션 바의 외관 스타일 |
  | `title` | 표시할 제목 |
  | `scrollOffset` | 스크롤 오프셋 값 |
  | `backgroundColorResolvable` | 배경색 리졸버 |
  | `leadingButton` | 좌측에 표시할 버튼 |
  | `trailingButtons` | 우측에 표시할 버튼 배열 (최대 3개까지 표시) |

### Instance Properties


``var body: some View``

### Enumerations


[``enum Resource``](/documentation/montage/topnavigation/resource.md)

TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.

[``enum Variant``](/documentation/montage/topnavigation/variant.md)

TopNavigation의 외관을 결정하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/topnavigation/view-implementations.md)

[View Implementations](/documentation/montage/topnavigation/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



