**ENUM**

# `Spacing`

```swift
public enum Spacing
```

UI 요소 간의 간격을 정의하는 시스템

Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된 
간격을 제공하기 위한 규격화된 값들을 정의합니다. 
모든 간격은 4포인트 기반의 스케일로 구성되어 있어 디자인의 
일관성과 조화를 유지합니다.

**사용 예시**:
```swift
// UIKit에서 사용
let padding = CGFloat.spacing(.pt16)
view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

// SwiftUI에서 사용
Text("Hello, World!")
    .padding(.horizontal, .spacing(.pt24))
    .padding(.vertical, .spacing(.pt16))
```

- Note: 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다.
예를 들어 pt16은 16포인트의 간격을 의미합니다.

## Cases
### `pt01`

```swift
case pt01
```

1포인트 간격

### `pt02`

```swift
case pt02
```

2포인트 간격

### `pt04`

```swift
case pt04
```

4포인트 간격

### `pt08`

```swift
case pt08
```

8포인트 간격

### `pt12`

```swift
case pt12
```

12포인트 간격

### `pt16`

```swift
case pt16
```

16포인트 간격 (기본 간격)

### `pt20`

```swift
case pt20
```

20포인트 간격

### `pt24`

```swift
case pt24
```

24포인트 간격

### `pt28`

```swift
case pt28
```

28포인트 간격

### `pt32`

```swift
case pt32
```

32포인트 간격

### `pt36`

```swift
case pt36
```

36포인트 간격

### `pt40`

```swift
case pt40
```

40포인트 간격

### `pt48`

```swift
case pt48
```

48포인트 간격

### `pt56`

```swift
case pt56
```

56포인트 간격

### `pt64`

```swift
case pt64
```

64포인트 간격

### `pt72`

```swift
case pt72
```

72포인트 간격

### `pt80`

```swift
case pt80
```

80포인트 간격
