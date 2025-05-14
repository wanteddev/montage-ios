---
1title: leadingbutton
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Bar.TopNavigation.Resource.LeadingButton 

TopNavigation의 좌측에 표시될 내용들의 열거형입니다.

```swift
enum LeadingButton
```

## Overview 

뒤로가기 버튼, 아이콘 버튼, 텍스트 버튼을 지원합니다.

**사용 예시**:

```swift
Bar.TopNavigation(
    leadingButton: .back {
        // 뒤로가기 동작
    }
)
```

## Topics 

### Enumeration Cases 

- [case back(action: () -> Void)](/documentation/montage/bar/topnavigation/resource/leadingbutton/back(action:).md)

  뒤로가기 버튼

- [case icon(Icon, action: () -> Void)](/documentation/montage/bar/topnavigation/resource/leadingbutton/icon(_:action:).md)

  아이콘 버튼

- [case text(String, action: () -> Void)](/documentation/montage/bar/topnavigation/resource/leadingbutton/text(_:action:).md)

