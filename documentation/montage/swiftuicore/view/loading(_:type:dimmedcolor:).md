Instance Method

# loading(_:type:dimmedColor:) 

현재 뷰에 로딩 인디케이터와 함께 로딩 오버레이를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func loading(
    _ isLoading: Binding<Bool>,
    type: Loading.Kind,
    dimmedColor: SwiftUI.Color = .clear
) -> some View
```

## Parameters 

isLoading

로딩 상태를 제어하는 바인딩 불리언 값

type

로딩 애니메이션 종류 (.wanted 또는 .circular)

dimmedColor

오버레이 배경색 (기본값: 투명)

## Return Value 

로딩 기능이 적용된 뷰

## Discussion 

로딩 상태일 때 뷰 위에 반투명 배경과 로딩 애니메이션을 표시합니다. 로딩 중에는 사용자 상호작용이 비활성화됩니다.

**사용 예시**:

```swift
@State private var isLoading = false

contentView
    .loading($isLoading, type: .wanted)
    .onAppear {
        // 로딩 상태 시작
        isLoading = true
    }
```

