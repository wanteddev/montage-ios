Structure

# SectionHeader 

섹션 제목과 부가 정보를 표시하는 헤더 컴포넌트입니다.

```swift
@MainActor
struct SectionHeader
```

## Overview 

SectionHeader는 콘텐츠를 논리적으로 구분하는 섹션 제목을 표시하며, 선택적으로 추가 액션이나 정보를 제공할 수 있습니다.

**사용 예시**:

```swift
// 기본 섹션 헤더
SectionHeader(title: "추천 콘텐츠")

// 부제목이 있는 섹션 헤더
SectionHeader(title: "인기 영화", subtitle: "이번 주 TOP 10")

// 더보기 버튼이 있는 섹션 헤더
SectionHeader(title: "최신 업데이트", hasMoreButton: true) {
    print("더보기 버튼 클릭됨")
}

// 커스텀 트레일링 컨텐츠가 있는 섹션 헤더
SectionHeader(title: "카테고리") {
    Text("필터")
        .font(.caption)
        .foregroundColor(.blue)
}
```

> **Note**
>
> 본 컴포넌트는 타이틀, 서브타이틀, 더보기 버튼, 커스텀 트레일링 콘텐츠를 조합하여 다양한 형태의 섹션 헤더를 구성할 수 있습니다.

## Topics 

### Initializers 

- [init(title: String)](/documentation/montage/sectionheader/init(title:).md)

  섹션 헤더를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/sectionheader/body.md)

### Instance Methods 

- [func headingContent((() -> any View)?) -> SectionHeader](/documentation/montage/sectionheader/headingcontent(_:).md)

  헤더 타이틀 옆에 추가 콘텐츠를 표시합니다.

- [func size(Size) -> SectionHeader](/documentation/montage/sectionheader/size(_:).md)

  섹션 헤더의 크기를 설정합니다.

- [func titleColor(SwiftUI.Color) -> SectionHeader](/documentation/montage/sectionheader/titlecolor(_:).md)

  타이틀 텍스트의 색상을 설정합니다.

- [func trailingContent((() -> any View)?) -> SectionHeader](/documentation/montage/sectionheader/trailingcontent(_:).md)

  헤더의 오른쪽에 추가적인 콘텐츠를 표시합니다.

### Enumerations 

- [enum Size](/documentation/montage/sectionheader/size.md)

  섹션 헤더의 크기를 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

