Structure

# Category 

카테고리 선택 옵션을 가로로 나열하는 컴포넌트입니다.

```swift
@MainActor
struct Category
```

## Overview 

사용자가 카테고리 목록에서 하나의 항목을 선택할 수 있는 스크롤 가능한 컴포넌트입니다. 다양한 크기와 스타일을 지원하며, 선택된 항목에 대한 시각적 피드백을 제공합니다.

**사용 예시**:

```swift
@State private var selectedIndex = 0
let categories = ["전체", "디자인", "개발", "마케팅", "경영"]

Category(
    selectedIndex: $selectedIndex,
    items: categories,
    actions: { index in
        print("선택된 카테고리: \(categories[index])")
    }
)
.variant(.alternative)
.size(.medium)
.horizontalPadding()
```

> **Note**
>
> 측면 그라데이션 효과와 아이콘 버튼을 추가할 수 있어 스크롤 가능한 콘텐츠임을 시각적으로 나타냅니다.

## Topics 

### Initializers 

- [init(selectedIndex: Binding<Int>, items: [String], actions: (Int) -> Void)](/documentation/montage/category/init(selectedindex:items:actions:).md)

  카테고리 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/category/body.md)

### Instance Methods 

- [func horizontalPadding(Bool) -> Category](/documentation/montage/category/horizontalpadding(_:).md)

  카테고리 컴포넌트의 좌우 패딩을 설정합니다.

- [func iconButton(Icon, action: () -> Void) -> Category](/documentation/montage/category/iconbutton(_:action:).md)

  카테고리 컴포넌트 오른쪽에 표시할 아이콘 버튼을 설정합니다.

- [func size(Size) -> Category](/documentation/montage/category/size(_:).md)

  카테고리 아이템 크기를 설정합니다.

- [func variant(Variant) -> Category](/documentation/montage/category/variant(_:).md)

  카테고리 아이템 스타일을 설정합니다.

- [func verticalPadding(Bool) -> Category](/documentation/montage/category/verticalpadding(_:).md)

  카테고리 컴포넌트의 상하 패딩을 설정합니다.

### Enumerations 

- [enum Size](/documentation/montage/category/size.md)

  카테고리 사이즈를 결정하는 열거형입니다.

- [enum Variant](/documentation/montage/category/variant.md)

  카테고리 아이템의 종류를 결정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

