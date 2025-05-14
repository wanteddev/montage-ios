---
1title: text(alignment:lengths:cornerradius:linenumber:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Case

# Skeleton.Kind.text(alignment:lengths:cornerRadius:lineNumber:) 

텍스트 줄을 나타내는 스켈레톤

```swift
case text(
    alignment: Align = .leading,
    lengths: [Length] = [._100],
    cornerRadius: CGFloat = 3,
    lineNumber: Int = 1
)
```

## Parameters 

alignment

텍스트 정렬 방식 (기본값: .leading)

lengths

각 줄의 상대적 길이 (기본값: [._100])

cornerRadius

모서리 둥글기 (기본값: 3)

lineNumber

텍스트 줄 수 (기본값: 1)

