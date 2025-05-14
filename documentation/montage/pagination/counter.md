---
1title: counter
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Pagination.Counter 

숫자 카운터 형태의 페이지 표시기 컴포넌트입니다.

```swift
@MainActor
struct Counter
```

## Overview 

Counter는 현재 페이지와 전체, 페이지 수를 숫자로 표시하는 페이지네이션 컴포넌트를 제공합니다. “1/10”과 같은 형식으로 페이지 정보를 시각화하며, 반투명 배경이 적용됩니다.

**사용 예시**:

```swift
@State private var currentPage = 1

Pagination.Counter(selectedPage: $currentPage, totalPages: 10)
    .size(.medium)
    .alternative(true)
```

> **Note**
>
> 이 컴포넌트는 기본적으로 어두운 배경 위에서 잘 보이도록 설계되었습니다.

## Topics 

### Initializers 

- [init(selectedPage: Binding<Int>, totalPages: Int)](/documentation/montage/pagination/counter/init(selectedpage:totalpages:).md)

  카운터 형태의 페이지네이션을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/pagination/counter/body.md)

### Instance Methods 

- [func alternative(Bool) -> Pagination.Counter](/documentation/montage/pagination/counter/alternative(_:).md)

  카운터 페이지네이션의 대체 스타일을 적용합니다.

- [func size(Size) -> Pagination.Counter](/documentation/montage/pagination/counter/size(_:).md)

  카운터 페이지네이션의 크기를 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/pagination/counter/size.md)

  카운터 페이지네이션의 크기를 지정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

