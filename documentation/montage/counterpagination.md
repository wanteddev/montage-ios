---
title: CounterPagination
description: 숫자 카운터 형태의 페이지 표시기 컴포넌트입니다.
---

```swift
@MainActor struct CounterPagination
```

## Overview

`CounterPagination`은 현재 페이지와 전체, 페이지 수를 숫자로 표시하는 페이지네이션 컴포넌트를 제공합니다. “1/10”과 같은 형식으로 페이지 정보를 시각화하며, 반투명 배경이 적용됩니다.

```swift
@State private var currentPage = 1

CounterPagination(selectedPage: $currentPage, totalPages: 10)
    .size(.medium)
    .alternative(true)
```

>  Note
>
> 이 컴포넌트는 기본적으로 어두운 배경 위에서 잘 보이도록 설계되었습니다.

## Topics

### Initializers


``init(selectedPage: Binding<Int>, totalPages: Int)``

카운터 형태의 페이지네이션을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `selectedPage` | 현재 선택된 페이지 번호 (1부터 시작) |
  | `totalPages` | 전체 페이지 수 |

### Instance Properties


``var body: some View``

### Instance Methods


``func alternative(Bool) -> CounterPagination``

카운터 페이지네이션의 대체 스타일을 적용합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `alternative` | 대체 스타일 적용 여부 (기본값: true) |
- **Return Value**

  수정된 Counter 인스턴스
- **Discussion**

  기본 스타일은 반투명 배경을 사용하고, 대체 스타일은 좀 더 불투명한 회색 배경을 사용합니다.
  >  Note
  >
  > 기본값은 `false`입니다.


``func size(Size) -> CounterPagination``

카운터 페이지네이션의 크기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `size` | 적용할 카운터 크기 |
- **Return Value**

  수정된 Counter 인스턴스
- **Discussion**
  >  Note
  >
  > 기본값은 `.medium`입니다.


### Enumerations


[``enum Size``](/documentation/montage/counterpagination/size.md)

카운터 페이지네이션의 크기를 지정하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/counterpagination/view-implementations.md)

[View Implementations](/documentation/montage/counterpagination/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



