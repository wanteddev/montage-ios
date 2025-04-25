**STRUCT**

# `SnackBar.SnackBarModifier`

```swift
public struct SnackBarModifier: ViewModifier
```

SnackBar를 화면에 표시하기 위한 뷰 모디파이어입니다.

바인딩된 Model 값이 nil이 아닐 때 스낵바를 표시하며,
설정된 시간이 지나면 자동으로 사라집니다.

**사용 예시**:
```swift
@State private var snackBarModel: SnackBar.Model?

var body: some View {
    VStack {
        // 콘텐츠
    }
    .modifier(
        SnackBar.SnackBarModifier(
            model: $snackBarModel,
            handler: {
                print("액션 버튼 클릭됨")
            }
        )
    )
    .onTapGesture {
        snackBarModel = SnackBar.Model(
            description: "탭 감지됨",
            action: "확인"
        )
    }
}
```

- Note: 스낵바가 표시될 때 진동 피드백이 발생합니다.

## Methods
<details><summary markdown="span"><code>init(model:handler:)</code></summary>

```swift
public init(model: Binding<SnackBar.Model?>, handler: @escaping () -> Void)
```

SnackBarModifier를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| model | 표시할 스낵바 모델에 대한 바인딩. nil이면 스낵바가 표시되지 않습니다. |
| handler | 스낵바의 액션 버튼이 클릭될 때 실행할 핸들러 |




</details>

<details><summary markdown="span"><code>body(content:)</code></summary>

```swift
public func body(content: Content) -> some View
```

</details>
