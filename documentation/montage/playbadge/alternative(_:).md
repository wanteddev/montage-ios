---
1title: alternative(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# alternative(_:) 

대체 스타일을 적용합니다.

```swift
@MainActor
func alternative(_ alternative: Bool = true) -> PlayBadge
```

## Parameters 

alternative

대체 스타일 적용 여부 (기본값: true)

## Return Value 

수정된 PlayBadge 인스턴스

## Discussion 

기본 스타일은 반투명 배경을 사용하고, 대체 스타일은 불투명한 회색 배경을 사용합니다.

> **Note**
>
> 기본값은 false입니다.

