---
title: Toast
description: 화면의 상단 또는 하단에 짧게 표시되는 알림 메시지 컴포넌트입니다.
---

```swift
@MainActor struct Toast
```

## Overview

사용자에게 간단한 피드백이나 정보를 제공하기 위해 사용합니다. 일반, 긍정, 주의, 부정적인 상태로 표시할 수 있으며, 설정된 시간이 지나면 자동으로 사라집니다.

```swift
// 토스트 메시지 표시
@State private var toastModel: Toast.Model?

var body: some View {
    ContentView()
        .modifier(
            Toast.ToastModifier(
                model: $toastModel,
                location: .bottom(),
                duration: .short
            )
        )
        .onAppear {
            toastModel = Toast.Model(
                .positive,
                message: "성공적으로 저장되었습니다."
            )
        }
}
```

>  See Also
>
> `Toast.Model`, `Toast.Variant`, `Toast.Location`, `Toast.Duration`, `Toast.ToastModifier`

## Topics

### Structures


[``struct Model``](/documentation/montage/toast/model.md)

토스트 메시지의 데이터 모델을 정의하는 구조체입니다.

### Instance Properties


``var body: some View``

### Enumerations


[``enum Duration``](/documentation/montage/toast/duration.md)

토스트 메시지의 표시 시간을 정의하는 열거형입니다.

[``enum Location``](/documentation/montage/toast/location.md)

토스트 메시지가 표시될 위치를 정의하는 열거형입니다.

[``enum Variant``](/documentation/montage/toast/variant.md)

토스트 메시지의 시각적 스타일을 정의하는 열거형입니다.

### Default Implementations


[View Implementations](/documentation/montage/toast/view-implementations.md)

[View Implementations](/documentation/montage/toast/view-implementations.md)

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



