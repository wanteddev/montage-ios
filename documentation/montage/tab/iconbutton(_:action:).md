---
1title: iconbutton(_:action:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# iconButton(_:action:) 

탭 컴포넌트의 오른쪽에 아이콘 버튼을 추가합니다.

```swift
@MainActor
func iconButton(
    _ icon: Icon,
    action: @escaping () -> Void
) -> Tab
```

## Parameters 

icon

표시할 아이콘

action

아이콘 버튼 탭 시 실행될 클로저

## Return Value 

수정된 Tab 인스턴스

## Discussion 

.resize(.hug) 모드에서만 표시됩니다.

