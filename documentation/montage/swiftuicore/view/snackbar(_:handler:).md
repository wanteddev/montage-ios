Instance Method

# snackBar(_:handler:) 

현재 뷰에 SnackBar를 표시하는 modifier를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func snackBar(
    _ model: Binding<SnackBar.Model?>,
    handler: @escaping () -> Void
) -> some View
```

## Parameters 

model

SnackBar 모델을 바인딩합니다. nil이 아닌 값이 설정되면 SnackBar가 표시됩니다.

handler

SnackBar의 액션 버튼이 클릭되었을 때 실행될 클로저

## Return Value 

SnackBar가 적용된 뷰

## Discussion 

**사용 예시**:

```swift
@State private var snackBarModel: SnackBar.Model?

var body: some View {
    VStack {
        Button("Show SnackBar") {
            snackBarModel = SnackBar.Model(
                description: "작업이 완료되었습니다",
                action: "확인"
            )
        }
    }
    .snackBar($snackBarModel) {
        // 액션 버튼 클릭 시 실행될 코드
    }
}
```

