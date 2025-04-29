Enumeration

# Cell.VerticalPadding 

상하 여백을 나타내는 열거형입니다.

```swift
enum VerticalPadding
```

## Overview 

셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.

**사용 예시**:

```swift
Cell(title: "넓은 여백이 있는 셀")
    .verticalPadding(.large)
```

> **Note**
>
> 여백 크기는 none(0), small(8), medium(12), large(16)으로 정의됩니다.

## Topics 

### Enumeration Cases 

- [case large](/documentation/montage/cell/verticalpadding/large.md)

  큰 여백 (16pt)

- [case medium](/documentation/montage/cell/verticalpadding/medium.md)

  중간 여백 (12pt)

- [case none](/documentation/montage/cell/verticalpadding/none.md)

  여백 없음 (0pt)

- [case small](/documentation/montage/cell/verticalpadding/small.md)

  작은 여백 (8pt)

### Instance Properties 

- [var length: CGFloat](/documentation/montage/cell/verticalpadding/length.md)

  여백 값을 포인트 단위로 반환합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/cell/verticalpadding/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

