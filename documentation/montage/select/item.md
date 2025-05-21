---
title: Select.Item
description: Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.
---

```swift
struct Item
```

## Topics

### Initializers


``init(text: String, icon: Icon?, isNegative: Bool, isSelected: Bool)``

아이템 초기화

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 아이템 텍스트 |
  | `icon` | 아이템 아이콘 (기본값: nil) |
  | `isNegative` | 부정적 상태 여부 (기본값: false) |
  | `isSelected` | 선택 여부 (기본값: false) |

### Instance Properties


``let icon: Icon?``

아이템의 아이콘 (선택 사항)

``let isNegative: Bool``

부정적 상태 여부 (오류나 경고를 나타낼 때 사용)

``var isSelected: Bool``

항목의 선택 여부

``let text: String``

아이템 텍스트 내용

### Default Implementations


[Equatable Implementations](/documentation/montage/select/item/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



