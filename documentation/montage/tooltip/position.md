---
1title: position
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Tooltip.Position 

툴팁이 표시될 위치를 정의하는 열거형입니다.

```swift
enum Position
```

## Overview 

툴팁의 방향(상단, 하단, 왼쪽, 오른쪽)과 화살표의 위치를 함께 지정할 수 있습니다.

**사용 예시**:

```swift
// 상단에 표시되고 화살표는 중앙에 위치
.position(.top())

// 왼쪽에 표시되고 화살표는 상단에 위치
.position(.leading(arrowPosition: .top))

// 하단에 표시되고 화살표는 오른쪽에 위치
.position(.bottom(arrowPosition: .trailing))
```

## Topics 

### Enumeration Cases 

- [case bottom(arrowPosition: HorizontalAlignment)](/documentation/montage/tooltip/position/bottom(arrowposition:).md)

  하단에 툴팁 표시

- [case leading(arrowPosition: VerticalAlignment)](/documentation/montage/tooltip/position/leading(arrowposition:).md)

  왼쪽에 툴팁 표시

- [case top(arrowPosition: HorizontalAlignment)](/documentation/montage/tooltip/position/top(arrowposition:).md)

  상단에 툴팁 표시

- [case trailing(arrowPosition: VerticalAlignment)](/documentation/montage/tooltip/position/trailing(arrowposition:).md)

