---
1title: item
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Select.Item 

아이템 타입입니다. Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.

```swift
struct Item
```

## Topics 

### Initializers 

- [init(text: String, icon: Icon?, isNegative: Bool, isSelected: Bool)](/documentation/montage/select/item/init(text:icon:isnegative:isselected:).md)

  아이템 초기화

### Instance Properties 

- [let icon: Icon?](/documentation/montage/select/item/icon.md)

  아이템의 아이콘 (선택 사항)

- [let isNegative: Bool](/documentation/montage/select/item/isnegative.md)

  부정적 상태 여부 (오류나 경고를 나타낼 때 사용)

- [var isSelected: Bool](/documentation/montage/select/item/isselected.md)

  항목의 선택 여부

- [let text: String](/documentation/montage/select/item/text.md)

  아이템 텍스트 내용

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/select/item/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

