Instance Method

# skeleton(isPresented:kind:color:opacity:size:) 

현재 뷰에 미리 정의된 스켈레톤 로딩 UI를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func skeleton(
    isPresented: Bool,
    kind: Skeleton.Kind,
    color: SwiftUI.Color? = nil,
    opacity: CGFloat? = nil,
    size: CGSize? = nil
) -> some View
```

## Parameters 

isPresented

스켈레톤 표시 여부를 제어하는 불리언 값

kind

스켈레톤 종류 (텍스트, 사각형, 원형 등)

color

스켈레톤 색상 (기본값: 시스템 색상)

opacity

스켈레톤 투명도 (기본값: 1.0)

size

스켈레톤 크기 (지정하지 않으면 원본 뷰 크기를 사용)

## Return Value 

스켈레톤 기능이 적용된 뷰

