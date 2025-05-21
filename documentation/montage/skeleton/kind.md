---
title: Skeleton.Kind
description: 스켈레톤 요소의 종류를 지정하는 열거형입니다.
---

```swift
enum Kind
```

## Overview

다양한 콘텐츠 유형에 맞게 적절한 스켈레톤 형태를 선택할 수 있습니다.

```swift
// 3줄 텍스트 스켈레톤
Skeleton.Kind.text(lineNumber: 3)

// 둥근 모서리 사각형 스켈레톤
Skeleton.Kind.rectangle(cornerRadius: 8)

// 원형 스켈레톤 (프로필 이미지 등에 적합)
Skeleton.Kind.circle
```

## Topics

### Enumeration Cases


``case circle``

원형 스켈레톤

``case rectangle(cornerRadius: CGFloat)``

사각형 모양의 스켈레톤

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `cornerRadius` | 모서리 둥글기 (기본값: 3) |

``case text(alignment: Align, lengths: [Length], cornerRadius: CGFloat, lineNumber: Int)``

텍스트 줄을 나타내는 스켈레톤

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `alignment` | 텍스트 정렬 방식 (기본값: .leading) |
  | `lengths` | 각 줄의 상대적 길이 (기본값: [._100]) |
  | `cornerRadius` | 모서리 둥글기 (기본값: 3) |
  | `lineNumber` | 텍스트 줄 수 (기본값: 1) |

