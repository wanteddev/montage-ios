**STRUCT**

# `Toast`

```swift
public struct Toast: View
```

화면의 상단 또는 하단에 짧게 표시되는 알림 메시지 컴포넌트입니다.

사용자에게 간단한 피드백이나 정보를 제공하기 위해 사용합니다.
일반, 긍정, 주의, 부정적인 상태로 표시할 수 있으며,
설정된 시간이 지나면 자동으로 사라집니다.

**사용 예시**:
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

- SeeAlso: `Toast.Model`, `Toast.Variant`, `Toast.Location`, `Toast.Duration`, `Toast.ToastModifier`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>
