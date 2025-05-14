---
1title: emptystate
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# EmptyState 

콘텐츠가 빈 상태일 때 사용자의 이해를 돕기 위한 컴포넌트입니다.

```swift
@MainActor
struct EmptyState
```

## Overview 

빈 화면, 데이터 없음, 검색 결과 없음 등의 상태를 시각적으로 표현하고 사용자에게 적절한 안내를 제공합니다. 이미지, 제목, 설명, 버튼 요소를 조합하여 다양한 상황에 맞는 빈 상태 화면을 구성할 수 있습니다.

**사용 예시**:

```swift
// 기본 사용법
EmptyState(
    description: "검색 결과가 없습니다."
)

// 모든 요소를 사용한 예시
EmptyState(
    image: { 
        Image.montage(.emptyBox)
            .resizable()
            .frame(width: 120, height: 120)
    },
    title: "데이터가 없습니다.",
    description: "새로운 항목을 추가해 보세요.",
    button: {
        Button.filled(text: "추가하기") {
            // 버튼 동작
        }
    }
)
```

> **Note**
>
> 컴포넌트가 기본적으로 화면 전체를 차지하므로 필요하다면 .frame modifier를 사용하여 크기를 조절하여 사용하시길 권장합니다.

## Topics 

### Initializers 

- [init(image: (() -> any View)?, title: String?, description: String, button: (() -> any View)?)](/documentation/montage/emptystate/init(image:title:description:button:).md)

  EmptyState 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/emptystate/body.md)

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

