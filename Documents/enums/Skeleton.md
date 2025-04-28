**ENUM**

# `Skeleton`

```swift
public enum Skeleton
```

콘텐츠 로딩 중 표시되는 스켈레톤 UI 컴포넌트입니다.

데이터 로딩 중에 UI의 구조를 미리 보여주는 스켈레톤 뷰를 제공합니다.
텍스트, 사각형, 원형 등 다양한 형태의 스켈레톤 로딩 플레이스홀더를 지원합니다.

**사용 예시**:
```swift
// 텍스트 스켈레톤 사용
Text("콘텐츠")
    .skeleton(isPresented: isLoading, kind: .text(lineNumber: 3))

// 이미지를 위한 원형 스켈레톤 사용
Image(systemName: "person.circle")
    .skeleton(isPresented: isLoading, kind: .circle)

// 커스텀 스켈레톤 뷰 사용
contentView
    .skeleton(isPresented: isLoading) {
        Skeleton.SkeletonView(.rectangle(cornerRadius: 8))
            .color(.gray)
            .opacity(0.7)
    }
```

- Note: 스켈레톤 뷰는 로딩 상태일 때 부드러운 페이드 인/아웃 애니메이션을 제공합니다.
