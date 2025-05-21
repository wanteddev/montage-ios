---
title: SnackBar.Model
description: SnackBar의 데이터 모델을 정의하는 구조체입니다.
---

```swift
struct Model
```

## Overview

스낵바에 표시할 콘텐츠와 동작 방식을 설정할 수 있습니다.

```swift
// 기본 스낵바 모델
SnackBar.Model(
    description: "저장되었습니다.",
    action: "확인"
)

// 모든 요소를 활용한 스낵바 모델
SnackBar.Model(
    duration: .long,
    heading: "알림",
    description: "새로운 메시지가 도착했습니다.",
    extraContents: {
        Image.montage(.bell)
            .resizable()
            .frame(width: 24, height: 24)
    },
    action: "보기"
)
```

## Topics

### Operators


``static func == (`Self`, `Self`) -> Bool``

### Initializers


``init(duration: Duration, heading: String?, description: String?, extraContents: (() -> any View)?, action: String)``

SnackBar 모델을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `duration` | 스낵바가 표시되는 시간 |
  | `heading` | 스낵바의 제목 (선택 사항) |
  | `description` | 스낵바의 설명 텍스트 (선택 사항) |
  | `extraContents` | 스낵바에 표시할 추가 콘텐츠를 반환하는 클로저 (선택 사항) |
  | `action` | 스낵바의 액션 버튼에 표시할 텍스트 |

### Default Implementations


[Equatable Implementations](/documentation/montage/snackbar/model/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



