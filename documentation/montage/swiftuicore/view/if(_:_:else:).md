---
1title: if(_:_:else:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# if(_:_:else:) 

조건에 따라 View를 변환합니다.MontageSwiftUICore

```swift
@ViewBuilder @MainActor
func `if`(
    _ condition: Bool,
    _ transform: (Self) -> any View,
    else alternative: ((Self) -> any View)? = nil
) -> some View
```

## Parameters 

condition

변환 조건

transform

조건이 true일 때 적용할 변환

alternative

조건이 false일 때 적용할 변환 (선택적)

## Return Value 

변환된 View

