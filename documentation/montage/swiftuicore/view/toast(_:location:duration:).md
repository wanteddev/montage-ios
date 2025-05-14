---
1title: toast(_:location:duration:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# toast(_:location:duration:) 

현재 뷰에 Toast 메시지를 표시하는 modifier를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func toast(
    _ model: Binding<Toast.Model?>,
    location: Toast.Location = .bottom(offset: 0),
    duration: Toast.Duration = .short
) -> some View
```

## Parameters 

model

Toast 모델을 바인딩합니다. nil이 아닌 값이 설정되면 Toast가 표시됩니다.

location

Toast가 표시될 위치 (기본값: .bottom)

duration

Toast가 표시될 시간 (기본값: .short)

## Return Value 

Toast가 적용된 뷰

## Discussion 

**사용 예시**:

```swift
@State private var toastModel: Toast.Model?

var body: some View {
    VStack {
        Button("Show Toast") {
            toastModel = Toast.Model(message: "작업이 완료되었습니다")
        }
    }
    .toast($toastModel)
}
```

