---
1title: model
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Toast.Model 

토스트 메시지의 데이터 모델을 정의하는 구조체입니다.

```swift
struct Model
```

## Overview 

토스트에 표시할 메시지와 스타일을 설정할 수 있습니다.

**사용 예시**:

```swift
// 기본 토스트 모델
Toast.Model(message: "작업이 완료되었습니다.")

// 특정 상태의 토스트 모델
Toast.Model(.negative, message: "오류가 발생했습니다.")

// 아이콘이 있는 토스트 모델
Toast.Model(.normal(Icon.bell), message: "새 알림이 있습니다.")
```

## Topics 

### Initializers 

- [init(Toast.Variant, message: String)](/documentation/montage/toast/model/init(_:message:).md)

  Toast 모델을 초기화합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/toast/model/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

