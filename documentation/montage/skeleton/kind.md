Enumeration

# Skeleton.Kind 

스켈레톤 요소의 종류를 지정하는 열거형입니다.

```swift
enum Kind
```

## Overview 

다양한 콘텐츠 유형에 맞게 적절한 스켈레톤 형태를 선택할 수 있습니다.

**사용 예시**:

```swift
// 3줄 텍스트 스켈레톤
.text(lineNumber: 3)

// 둥근 모서리 사각형 스켈레톤
.rectangle(cornerRadius: 8)

// 원형 스켈레톤 (프로필 이미지 등에 적합)
.circle
```

## Topics 

### Enumeration Cases 

- [case circle](/documentation/montage/skeleton/kind/circle.md)

  원형 스켈레톤

- [case rectangle(cornerRadius: CGFloat)](/documentation/montage/skeleton/kind/rectangle(cornerradius:).md)

  사각형 모양의 스켈레톤

- [case text(alignment: Align, lengths: [Length], cornerRadius: CGFloat, lineNumber: Int)](/documentation/montage/skeleton/kind/text(alignment:lengths:cornerradius:linenumber:).md)

