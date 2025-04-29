Structure

# SnackBar.SnackBarModifier 

SnackBar를 화면에 표시하기 위한 뷰 모디파이어입니다.

```swift
@MainActor
struct SnackBarModifier
```

## Overview 

바인딩된 Model 값이 nil이 아닐 때 스낵바를 표시하며, 설정된 시간이 지나면 자동으로 사라집니다.

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

> **Note**
>
> 스낵바가 표시될 때 진동 피드백이 발생합니다.

## Topics 

### Initializers 

- [init(model: Binding<SnackBar.Model?>, handler: () -> Void)](/documentation/montage/snackbar/snackbarmodifier/init(model:handler:).md)

  SnackBarModifier를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/snackbar/snackbarmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/snackbar/snackbarmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

