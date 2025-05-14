---
1title: buttoninfo
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Tooltip.ButtonInfo 

툴팁에 표시되는 버튼의 정보를 정의하는 구조체입니다.

```swift
struct ButtonInfo
```

## Overview 

툴팁 내용 아래에 표시되는 버튼의 제목과 동작을 정의합니다.

**사용 예시**:

```swift
Tooltip.ButtonInfo(
    title: "더 알아보기",
    action: {
        // 상세 정보 페이지로 이동
    }
)
```

## Topics 

### Initializers 

- [init(title: String, action: () -> Void)](/documentation/montage/tooltip/buttoninfo/init(title:action:).md)

  ButtonInfo를 초기화합니다.

### Instance Properties 

- [let action: () -> Void](/documentation/montage/tooltip/buttoninfo/action.md)

- [let title: String](/documentation/montage/tooltip/buttoninfo/title.md)

