---
title: Loading.Kind
description: 로딩 애니메이션의 종류를 정의하는 열거형입니다.
---

```swift
enum Kind
```

## Overview

애플리케이션의 디자인 요구사항이나 컨텍스트에 따라 적절한 로딩 스타일을 선택할 수 있습니다.

```swift
// Wanted 스타일 로딩 사용
Loading(kind: .wanted)

// 원형 로딩 사용
Loading(kind: .circular)
```

## Topics

### Enumeration Cases


``case circular``

원형 회전 로딩 애니메이션

``case wanted``

Wanted 브랜드 스타일의 로딩 애니메이션

### Default Implementations


[Equatable Implementations](/documentation/montage/loading/kind/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



