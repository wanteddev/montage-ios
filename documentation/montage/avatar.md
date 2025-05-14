---
1title: avatar
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Avatar 

사용자, 회사, 학원의 프로필 이미지를 표시하는 아바타 컴포넌트입니다.

```swift
@MainActor
struct Avatar
```

## Overview 

원형 또는 둥근 모서리 사각형 형태로 프로필 이미지를 표시합니다. 이미지 URL이 유효하지 않을 경우 각 유형별 기본 이미지를 표시합니다.

**사용 예시**:

```swift
// 기본 사용자 아바타
Avatar("https://example.com/profile.jpg", variant: .person)

// 테두리가 있는 회사 아바타
Avatar("https://example.com/company-logo.png", variant: .company, size: .medium)
    .border(color: .red, width: 2)

// 푸시 알림 표시가 있는 아바타
Avatar("https://example.com/profile.jpg", variant: .person)
    .pushBadge()
```

> **Note**
>
> 이미지 로딩은 SDWebImage를 통해 처리되며, 탭 상호작용을 지원합니다.

## Topics 

### Structures 

- [struct Group](/documentation/montage/avatar/group.md)

  여러 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.

### Initializers 

- [init(String, variant: Variant, size: Size, onTap: (() -> Void)?)](/documentation/montage/avatar/init(_:variant:size:ontap:).md)

  아바타를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/avatar/body.md)

### Instance Methods 

- [func border(color: SwiftUI.Color, width: CGFloat) -> Avatar](/documentation/montage/avatar/border(color:width:).md)

  아바타에 테두리를 추가합니다.

- [func pushBadge(Bool) -> Avatar](/documentation/montage/avatar/pushbadge(_:).md)

  푸시 알림 표시 뱃지를 아바타에 추가합니다.

### Enumerations 

- [enum Size](/documentation/montage/avatar/size.md)

  아바타의 크기를 정의하는 열거형입니다.

- [enum Variant](/documentation/montage/avatar/variant.md)

  아바타의 유형을 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

