Structure

# Triangle 

삼각형 모양을 그리는 Shape 컴포넌트입니다.

```swift
struct Triangle
```

## Overview 

정해진 영역 내에 정삼각형 형태를 그립니다. 화살표 포인터, 툴팁, 인디케이터 등 다양한 UI 요소에 활용할 수 있습니다.

**사용 예시**:

```swift
Triangle()
    .frame(width: 20, height: 10)
    .foregroundColor(.blue)
    .rotationEffect(.degrees(180)) // 방향 변경

// 버튼 위에 삼각형 인디케이터 표시
Button("메뉴") {
    // 작업 수행
}
.overlay(alignment: .top) {
    Triangle()
        .frame(width: 12, height: 6)
        .foregroundColor(.red)
        .offset(y: -6)
}
```

> **See Also**
>
> SwiftUI.Shape 프로토콜

## Topics 

### Initializers 

- [init()](/documentation/montage/triangle/init().md)

  삼각형을 초기화합니다.

### Instance Methods 

- [func path(in: CGRect) -> Path](/documentation/montage/triangle/path(in:).md)

  삼각형 경로를 정의합니다.

### Default Implementations 

- [API ReferenceAnimatable Implementations](/documentation/montage/triangle/animatable-implementations.md)

- [API ReferenceShape Implementations](/documentation/montage/triangle/shape-implementations.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.Animatable
- SwiftUICore.Shape
- SwiftUICore.View

