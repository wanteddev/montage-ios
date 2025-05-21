---
title: Toast.Variant
description: 토스트 메시지의 시각적 스타일을 정의하는 열거형입니다.
---

```swift
enum Variant
```

## Topics

### Enumeration Cases


``case cautionary``

주의 메시지를 위한 주황색 경고 아이콘 스타일

``case negative``

오류 메시지를 위한 빨간색 경고 아이콘 스타일

``case normal(Montage.Icon?, tint: Montage.Color.Semantic?)``

기본 스타일의 토스트 (선택적으로 아이콘과 색상 지정 가능)

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 (선택 사항) |
  | `tint` | 아이콘의 색상 (선택 사항) |

``case positive``

성공 메시지를 위한 녹색 체크 아이콘 스타일

### Default Implementations


[Equatable Implementations](/documentation/montage/toast/variant/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



