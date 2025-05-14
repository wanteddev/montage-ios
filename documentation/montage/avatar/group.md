---
1title: group
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Avatar.Group 

여러 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.

```swift
@MainActor
struct Group
```

## Overview 

최대 5개의 아바타를 부분적으로 겹쳐 표시하며, 각 아바타에 개별 탭 동작을 지정할 수 있습니다.

**사용 예시**:

```swift
// 기본 그룹 아바타
Avatar.Group(
    ["https://example.com/user1.jpg", "https://example.com/user2.jpg"],
    variant: .person,
    size: .small
)

// 탭 동작과 후행 콘텐츠가 있는 그룹 아바타
Avatar.Group(
    imageUrls,
    variant: .person,
    size: .small,
    onTap: { index in
        print("탭한 아바타 인덱스: \(index)")
    }
)
.trailingContent {
    Text("+3").montage(variant: .body2)
}
```

> **Note**
>
> 아바타는 왼쪽에서 오른쪽으로 겹쳐서 표시되며, 마지막 아바타가 가장 앞에 표시됩니다.

## Topics 

### Initializers 

- [init([String], variant: Avatar.Variant, size: Size, onTap: ((_ index: Int) -> Void)?)](/documentation/montage/avatar/group/init(_:variant:size:ontap:).md)

  그룹 아바타를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/avatar/group/body.md)

### Instance Methods 

- [func trailingContent(() -> any View) -> Avatar.Group](/documentation/montage/avatar/group/trailingcontent(_:).md)

  그룹 아바타 오른쪽에 추가적인 콘텐츠를 표시합니다.

### Enumerations 

- [enum Size](/documentation/montage/avatar/group/size.md)

  그룹 아바타의 크기와 간격을 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

