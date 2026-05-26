---
title: Opacity
description: 색상의 불투명도(alpha)를 정의하는 시스템
---

```swift
enum Opacity
```

## Overview

Montage 디자인 시스템에서 사용하는 정규화된 불투명도 값을 제공합니다. 각 토큰 이름의 숫자는 백분율(%)을 의미합니다. 예: `opacity52`는 0.52(52%) 불투명도입니다.

```swift
// CGFloat 값으로 사용
let alpha: CGFloat = .opacity52

// SwiftUI 뷰 불투명도
myView.opacity(.opacity88)

// 색상 알파 채널
UIColor.black.withAlphaComponent(.opacity43)
```

>  **Note**
>
> `opacity0`은 완전 투명(0.0), `opacity100`은 완전 불투명(1.0)입니다.

실제 값은 `CGFloat.opacity{N}` 정적 프로퍼티로 노출됩니다. 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.

