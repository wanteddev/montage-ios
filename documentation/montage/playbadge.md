---
1title: playbadge
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# PlayBadge 

재생 버튼이 있는 배지 컴포넌트입니다.

```swift
@MainActor
struct PlayBadge
```

## Overview 

PlayBadge는 미디어 콘텐츠에서 재생 기능을 나타내는 원형 아이콘을 제공합니다. 다양한 크기와 스타일로 커스터마이징할 수 있으며, 이미지나 비디오 위에 오버레이로 표시하기 적합합니다.

**사용 예시**:

```swift
// 기본 재생 배지
PlayBadge()

// 커스텀 크기의 재생 배지
PlayBadge()
    .size(.large)

// 대체 스타일의 재생 배지
PlayBadge()
    .size(.medium)
    .alternative(true)
```

> **Note**
>
> 기본 스타일은 반투명 배경에 흰색 재생 아이콘을 사용합니다. alternative 스타일은 불투명 회색 배경을 사용합니다.

## Topics 

### Initializers 

- [init()](/documentation/montage/playbadge/init().md)

  기본 설정의 재생 배지를 생성합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/playbadge/body.md)

### Instance Methods 

- [func alternative(Bool) -> PlayBadge](/documentation/montage/playbadge/alternative(_:).md)

  대체 스타일을 적용합니다.

- [func size(Size) -> PlayBadge](/documentation/montage/playbadge/size(_:).md)

  재생 배지의 크기를 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/playbadge/size.md)

  재생 배지의 크기를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

