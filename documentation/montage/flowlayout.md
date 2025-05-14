---
1title: flowlayout
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# FlowLayout 

항목들을 자동으로 여러 줄에 배치하는 흐름 레이아웃 컴포넌트입니다.

```swift
struct FlowLayout
```

## Overview 

이 레이아웃은 컨테이너의 너비를 초과할 경우 항목을 자동으로 다음 줄로 넘겨 배치합니다. 항목 간 수평 간격과 줄 간 수직 간격을 설정할 수 있습니다.

**사용 예시**:

```swift
FlowLayout(spacing: 8, lineSpacing: 12) {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(16)
    }
}
```

## Topics 

### Structures 

- [struct Cache](/documentation/montage/flowlayout/cache.md)

  레이아웃 계산에 사용되는 캐시 구조체입니다.

### Initializers 

- [init(spacing: CGFloat?, lineSpacing: CGFloat)](/documentation/montage/flowlayout/init(spacing:linespacing:).md)

  FlowLayout을 초기화합니다.

### Instance Methods 

- [func makeCache(subviews: Subviews) -> Cache](/documentation/montage/flowlayout/makecache(subviews:).md)

  레이아웃 캐시를 생성합니다.

- [func placeSubviews(in: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache)](/documentation/montage/flowlayout/placesubviews(in:proposal:subviews:cache:).md)

  서브뷰들을 실제 위치에 배치합니다.

- [func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize](/documentation/montage/flowlayout/sizethatfits(proposal:subviews:cache:).md)

  레이아웃의 전체 크기를 계산합니다.

### Default Implementations 

- [API ReferenceAnimatable Implementations](/documentation/montage/flowlayout/animatable-implementations.md)

- [API ReferenceLayout Implementations](/documentation/montage/flowlayout/layout-implementations.md)

## Relationships 

### Conforms To 

- SwiftUICore.Animatable
- SwiftUICore.Layout

