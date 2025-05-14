---
1title: size
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# SectionHeader.Size 

섹션 헤더의 크기를 정의하는 열거형입니다.

```swift
enum Size
```

## Overview 

콘텐츠의 중요도나 시각적 계층 구조에 따라 4가지 크기 옵션을 제공합니다. 각 크기는 서로 다른 폰트 크기와 높이를 가지며, 콘텐츠 구조에 맞게 선택할 수 있습니다.

**사용 예시**:

```swift
SectionHeader(title: "주요 기능")
    .size(.large) // 큰 크기의 헤더 사용
```

> **Note**
>
> xsmall(20pt), small(24pt), medium(28pt), large(32pt) 네 가지 크기를 제공합니다.

## Topics 

### Enumeration Cases 

- [case large](/documentation/montage/sectionheader/size/large.md)

  큰 크기 (32pt, title3 폰트)

- [case medium](/documentation/montage/sectionheader/size/medium.md)

  중간 크기 (28pt, heading2 폰트, 기본값)

- [case small](/documentation/montage/sectionheader/size/small.md)

  작은 크기 (24pt, headline2 폰트)

- [case xsmall](/documentation/montage/sectionheader/size/xsmall.md)

  가장 작은 크기 (20pt, label1 폰트)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/sectionheader/size/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

