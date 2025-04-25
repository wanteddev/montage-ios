**ENUM**

# `Typography`

```swift
public enum Typography
```

Montage 디자인 시스템의 타이포그래피 체계

Typography는 Montage 디자인 시스템에서 사용되는 모든 텍스트 스타일을
정의합니다. 폰트 크기, 두께, 자간, 행간 등 텍스트의 시각적 특성을
일관되게 적용할 수 있도록 표준화된 타이포그래피 시스템을 제공합니다.

**사용 예시**:
```swift
// UIKit에서 사용
let label = UILabel()
label.font = UIFont.montage(.body1, .regular)

// SwiftUI에서 사용
Text("Hello, World!")
    .montage(.heading1, .bold)
```

- Note: 텍스트 스타일을 적용할 때는 일관성을 위해 직접 폰트를 지정하기보다
  Typography 시스템을 사용하는 것이 권장됩니다.

- SeeAlso: `Typography.Weight`, `Typography.Variant`
