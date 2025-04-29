Structure

# Pagination.Dot 

점 형태의 페이지 표시기 컴포넌트입니다.

```swift
@MainActor
struct Dot
```

## Overview 

Dot은 페이지 간 이동 및 현재 페이지 표시를 위한 점 형태의 페이지네이션 컴포넌트를 제공합니다. 현재 선택된 페이지는 강조 표시되며, 점을 탭하여 해당 페이지로 이동할 수 있습니다. 페이지 수가 많을 경우 표시되는 점의 개수와 크기가 자동으로 조정됩니다.

**사용 예시**:

```swift
@State private var currentPage = 1

Pagination.Dot(selectedPage: $currentPage, totalPages: 10)
    .variant(.normal)
    .size(.normal)
```

> **Note**
>
> 최대 표시 가능한 점의 개수는 5개이며, 페이지 수가 더 많을 경우 동적으로 조정됩니다.

## Topics 

### Initializers 

- [init(selectedPage: Binding<Int>, totalPages: Int)](/documentation/montage/pagination/dot/init(selectedpage:totalpages:).md)

  점 형태의 페이지네이션을 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/pagination/dot/body.md)

### Instance Methods 

- [func size(Size) -> Pagination.Dot](/documentation/montage/pagination/dot/size(_:).md)

  점 페이지네이션의 크기를 설정합니다.

- [func variant(Variant) -> Pagination.Dot](/documentation/montage/pagination/dot/variant(_:).md)

  점 페이지네이션의 색상 변형을 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/pagination/dot/size.md)

  점 페이지네이션의 크기를 지정하는 열거형입니다.

- [enum Variant](/documentation/montage/pagination/dot/variant.md)

  점 페이지네이션의 색상 변형을 지정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

