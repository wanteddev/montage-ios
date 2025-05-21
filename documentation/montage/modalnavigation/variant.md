---
title: ModalNavigation.Variant
description: 내비게이션 바의 외관을 정의하는 열거형입니다.
---

```swift
enum Variant
```

## Topics

### Enumeration Cases


``case emphasized``

강조된 큰 제목 스타일

``case extended``

제목이 별도 줄에 표시되는 확장된 스타일

``case floating(alternative: Bool, background: Bool)``

배경이 투명한 플로팅 스타일

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `alternative` | 대체 아이콘 사용 여부 (기본값: false) |
  | `background` | 배경 표시 여부 (기본값: true) |

``case normal``

기본 스타일의 내비게이션 바

### Default Implementations


[Equatable Implementations](/documentation/montage/modalnavigation/variant/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



