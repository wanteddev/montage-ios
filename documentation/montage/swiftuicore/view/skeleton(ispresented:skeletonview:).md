---
1title: skeleton(ispresented:skeletonview:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# skeleton(isPresented:skeletonView:) 

현재 뷰에 커스텀 스켈레톤 로딩 UI를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func skeleton(
    isPresented: Bool,
    @ViewBuilder skeletonView: @escaping () -> any View
) -> some View
```

## Parameters 

isPresented

스켈레톤 표시 여부를 제어하는 불리언 값

skeletonView

커스텀 스켈레톤 뷰를 생성하는 클로저

## Return Value 

스켈레톤 기능이 적용된 뷰

