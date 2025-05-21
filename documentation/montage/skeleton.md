---
title: Skeleton
description: 콘텐츠 로딩 중 표시되는 스켈레톤 UI 컴포넌트입니다.
---

```swift
enum Skeleton
```

## Overview

데이터 로딩 중에 UI의 구조를 미리 보여주는 스켈레톤 뷰를 제공합니다. 텍스트, 사각형, 원형 등 다양한 형태의 스켈레톤 로딩 플레이스홀더를 지원합니다.

```swift
// 텍스트 스켈레톤 사용
Text("콘텐츠")
    .skeleton(isPresented: isLoading, kind: .text(lineNumber: 3))

// 이미지를 위한 원형 스켈레톤 사용
Image(systemName: "person.circle")
    .skeleton(isPresented: isLoading, kind: .circle)

// 커스텀 스켈레톤 뷰 사용
contentView
    .skeleton(isPresented: isLoading) {
        Skeleton.SkeletonView(.rectangle(cornerRadius: 8))
            .color(.semantic(.fillNormal))
            .opacity(0.7)
    }
```

>  Note
>
> 스켈레톤 뷰는 로딩 상태일 때 부드러운 페이드 인/아웃 애니메이션을 제공합니다.

## Topics

### Structures


[``struct SkeletonView``](/documentation/montage/skeleton/skeletonview.md)

스켈레톤 로딩 UI를 표시하는 뷰입니다.

### Enumerations


[``enum Align``](/documentation/montage/skeleton/align.md)

스켈레톤 요소의 정렬 방식을 지정하는 열거형입니다.

[``enum Kind``](/documentation/montage/skeleton/kind.md)

스켈레톤 요소의 종류를 지정하는 열거형입니다.

[``enum Length``](/documentation/montage/skeleton/length.md)

스켈레톤 요소의 길이 비율을 지정하는 열거형입니다.

