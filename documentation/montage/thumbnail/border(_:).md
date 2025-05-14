---
1title: border(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# border(_:) 

썸네일에 테두리를 적용합니다.

```swift
@MainActor
func border(_ border: Bool = true) -> Thumbnail
```

## Parameters 

border

테두리 적용 여부 (기본값: true)

## Return Value 

수정된 Thumbnail 인스턴스

## Discussion 

> **Note**
>
> 적용 시 1포인트 두께의 .lineNormal 색상 테두리가 적용됩니다.

