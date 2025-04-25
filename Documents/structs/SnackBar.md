**STRUCT**

# `SnackBar`

```swift
public struct SnackBar: View
```

화면 하단에 임시로 표시되는 알림 메시지 컴포넌트입니다.

사용자에게 짧은 피드백이나 알림을 제공하기 위해 사용합니다.
제목, 설명, 추가 콘텐츠와 액션 버튼을 포함할 수 있으며,
설정된 시간이 지나면 자동으로 사라집니다.

**사용 예시**:
```swift
// 모델을 통한 스낵바 표시
@State private var snackBarModel: SnackBar.Model?

var body: some View {
    ContentView()
        .modifier(
            SnackBar.SnackBarModifier(
                model: $snackBarModel,
                handler: {
                    // 액션 버튼 클릭 시 실행할 코드
                }
            )
        )
        .onAppear {
            snackBarModel = SnackBar.Model(
                duration: .short,
                description: "작업이 완료되었습니다.",
                action: "확인"
            )
        }
}
```

- SeeAlso: `SnackBar.Duration`, `SnackBar.Model`, `SnackBar.SnackBarModifier`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>
