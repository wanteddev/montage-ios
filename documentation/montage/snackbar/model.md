Structure

# SnackBar.Model 

SnackBar의 데이터 모델을 정의하는 구조체입니다.

```swift
struct Model
```

## Overview 

스낵바에 표시할 콘텐츠와 동작 방식을 설정할 수 있습니다.

**사용 예시**:

```swift
// 기본 스낵바 모델
SnackBar.Model(
    description: "저장되었습니다.",
    action: "확인"
)

// 모든 요소를 활용한 스낵바 모델
SnackBar.Model(
    duration: .long,
    heading: "알림",
    description: "새로운 메시지가 도착했습니다.",
    extraContents: {
        Image.montage(.bell)
            .resizable()
            .frame(width: 24, height: 24)
    },
    action: "보기"
)
```

## Topics 

### Operators 

- [static func == (`Self`, `Self`) -> Bool](/documentation/montage/snackbar/model/==(_:_:).md)

### Initializers 

- [init(duration: Duration, heading: String?, description: String?, extraContents: (() -> any View)?, action: String)](/documentation/montage/snackbar/model/init(duration:heading:description:extracontents:action:).md)

  SnackBar 모델을 초기화합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/snackbar/model/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

