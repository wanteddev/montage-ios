---
title: SectionHeader.Size
description: 섹션 헤더의 크기를 정의하는 열거형입니다.
---

```swift
enum Size
```

## Overview

콘텐츠의 중요도나 시각적 계층 구조에 따라 4가지 크기 옵션을 제공합니다. 각 크기는 서로 다른 폰트 크기와 높이를 가지며, 콘텐츠 구조에 맞게 선택할 수 있습니다.

```swift
SectionHeader(title: "주요 기능")
    .size(.large) // 큰 크기의 헤더 사용
```

## Topics

### Enumeration Cases


``case large``

큰 크기

``case medium``

중간 크기

``case small``

작은 크기

``case xsmall``

가장 작은 크기

### Default Implementations


[Equatable Implementations](/documentation/montage/sectionheader/size/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



