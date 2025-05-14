---
1title: toastmodifier
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Toast.ToastModifier 

Toast를 화면에 표시하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct ToastModifier
```

## Overview 

바인딩된 Model 값이 nil이 아닐 때 토스트를 표시하며, 설정된 시간이 지나면 자동으로 사라집니다.

**사용 예시**:

```swift
@State private var toastModel: Toast.Model?

var body: some View {
    VStack {
        Button("토스트 표시") {
            toastModel = Toast.Model(
                .cautionary,
                message: "주의가 필요합니다."
            )
        }
    }
    .modifier(
        Toast.ToastModifier(
            model: $toastModel,
            location: .top(),
            duration: .long
        )
    )
}
```

> **Note**
>
> 토스트가 표시될 때 진동 피드백이 발생합니다.

## Topics 

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/toast/toastmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/toast/toastmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

