---
title: Avatar
description: 사용자, 회사, 학원의 프로필 이미지를 표시하는 아바타 컴포넌트입니다.
---

```swift
@MainActor struct Avatar
```

## Overview

원형 또는 둥근 모서리 사각형 형태로 프로필 이미지를 표시합니다. 이미지 URL이 유효하지 않을 경우 각 유형별 기본 이미지를 표시합니다.

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

>  Note
>
> 이미지 로딩은 SDWebImage를 통해 처리되며, 탭 상호작용을 지원합니다.

## Topics

### Structures


[``struct Group``](/documentation/montage/avatar/group.md)

여러 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.

### Initializers


``init(String, variant: Variant, size: Size, onTap: (() -> Void)?)``

아바타를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `imageUrl` | 표시할 이미지의 URL 문자열 |
  | `variant` | 아바타 유형 (.person, .company, .academy) |
  | `size` | 아바타 크기 (기본값: .small) |
  | `onTap` | 탭 시 실행할 액션 (기본값: nil) |

### Instance Properties


``var body: some View``

### Instance Methods


``func border(color: SwiftUI.Color, width: CGFloat) -> Avatar``

아바타에 테두리를 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 테두리 색상 (기본값: .semantic(.lineAlternative)) |
  | `width` | 테두리 두께 (기본값: 1) |
- **Return Value**

  수정된 아바타 인스턴스

``func pushBadge(Bool) -> Avatar``

푸시 알림 표시 뱃지를 아바타에 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `pushBadge` | 뱃지 표시 여부 (기본값: true) |
- **Return Value**

  수정된 아바타 인스턴스
- **Discussion**

  푸시 뱃지는 사용자(.person) 아바타에만 적용 가능합니다.

### Enumerations


[``enum Size``](/documentation/montage/avatar/size.md)

아바타의 크기를 정의하는 열거형입니다.

[``enum Variant``](/documentation/montage/avatar/variant.md)

아바타의 유형을 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/avatar/view-implementations.md)

[View Implementations](/documentation/montage/avatar/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



