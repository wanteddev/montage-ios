# Foundation 요소 사용하기

## Overview

디자인시스템의 기본 요소인 Foundation 요소 중 일부는 각 UI 프레임워크의 Extension를 통해 사용할 수 있습니다.

### Color

![Figma에서 확인할 수 있는 Color 속성](figma-color)

디자인시스템에서 정의된 색상들은 UIKit의 `UIColor`와 SwiftUI의 `Color` Extension을 통해서 각각의 실제 값을 불러올 수 있습니다. 정의된 색상의 타입은 두가지로, 용도에 맞춰서 선택해서 사용하시면 됩니다.

| Type          | Description |
| ------------- | ----------- |
| `.alias(_:)`  | 의미를 부여한 색상 세트. UIColor 타입으로 사용시 라이트/다크 모드를 지원합니다. 대부분의 경우에 이쪽을 사용하시면 됩니다. |  
| `.atomic(_:)` | 디자인 시스템에서 정의한 모든 색상 파레트. 디자이너가 이 색상을 사용했을 경우, 실제로 이 Atomic 색상을 의도하고 사용한 건지 추가 확인이 필요합니다. |

UIKit과 SwiftUI에서의 사용법은 아래의 샘플 코드와 같습니다.

```swift
/// UIKit
let label = UILabel()
label.textColor = .alias(.primaryNormal)

/// SwiftUI
struct CustomView: View {
    public var body: some View {
        Group {
            Text("hello, world")
                .foregroundColor(.alias(.primaryNormal))
        }
    }
}
```

### Typography

![Figma에서 확인할 수 있는 Typography 속성](figma-typography)

Typography에서 정의한 파라미터는 크게 세가지로, 각각의 용도는 다음과 같습니다. 

| Parameter | Description |
| --------- | ----------- |
| ``Montage/Typography/Variant`` | 타이포의 용도를 정의하는 파라미터입니다. 기본값은 `.body1`을 사용하고 있습니다. | 
| ``Montage/Typography/Weight`` | 타이포의 굵기를 정의하는 파라미터입니다. Varient와 조합하여 어떤 폰트 Weight를 사용할 지 결정합니다. | 
| ``Montage/Typography/Size`` | 타이포의 크기를 정의하는 파라미터입니다. 모바일 환경에서는 `.small`이 기본값이며, 특별한 언급이 없는 한 `.large`를 사용하지 않습니다. |

일반적으로 사용할 때는 Montage에서 구현한 `NSAttributedString`의 Extension을 통해 새로운 Attributed String을 생성하여 사용하시면 됩니다. SwiftUI에서는 `Text`의 Extension인 `.montage` 속성을 사용하실 수 있습니다.

```swift
/// UIKit
let label = UILabel()
label.attributedText = .montage("Hello, World")

/// SwiftUI
struct CustomView: View {
    public var body: some View {
        VStack {
            /// Title1/Bold
            Text("hello, world").montage(varient: .title1, weight: .bold)

            /// Body1/Regular
            Text("hello, world").montage()
        }
    }
}

```

### Icon

디자인시스템에서 정의한 Icon 타입과 `UIImage.montage(_:)` Extension을 사용하여 실제 이미지를 불러와 사용할 수 있습니다. 불러온 이미지는 템플릿 이미지이기 때문에 `tintColor`를 지정하여 색을 입힐 수 있습니다.

```swift
/// UIKit
let imageView = UIImageView()
imageView.tintColor = .alias(.primaryNormal)
let iconImage: UIImage = .montage(.bell)
imageView.image = iconImage

/// SwiftUI
struct CustomView: View {
    public var body: some View {
        VStack {
            /// Image with Icon
            Image.montage(.bell)
        }
    }
}
```

### Spacing

디자인시스템에서는 각 UI 요소간의 간격들을 지정할 때 사용할 수 있는 수치들을 미리 정의하여 사용할 수 있도록 제공하고 있습니다. 실제 수치는 `CGFloat.spacing(_:)` Extension을 사용하여 불러올 수 있습니다. 

```swift
let stackView = UIStackView()
stackView.axis = .horizontal
stackView.spacing = .spacing(.pt08)

addSubview(stackView)
stackView.snp.makeConstraint {
    $0.edges.equalToSuperview().inset(CGFloat.spacing(.pt16)
}
```
