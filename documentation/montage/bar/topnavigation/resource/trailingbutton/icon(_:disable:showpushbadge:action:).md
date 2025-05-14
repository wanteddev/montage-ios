---
1title: icon(_:disable:showpushbadge:action:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Case

# Bar.TopNavigation.Resource.TrailingButton.icon(_:disable:showPushBadge:action:) 

icon 형태의 Action입니다.

```swift
case icon(
    Icon,
    disable: Bool = false,
    showPushBadge: Bool = false,
    action: () -> Void
)
```

## Discussion 

- showPushBadge: PushBadge의 노출 여부를 결정합니다. 기본값은 false입니다.
- action: icon 클릭시 동작할 action입니다.

