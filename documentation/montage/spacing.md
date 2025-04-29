Enumeration

# Spacing 

UI 요소 간의 간격을 정의하는 시스템

```swift
enum Spacing
```

## Overview 

Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된 간격을 제공하기 위한 규격화된 값들을 정의합니다. 모든 간격은 4포인트 기반의 스케일로 구성되어 있어 디자인의 일관성과 조화를 유지합니다.

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

> **Note**
>
> 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다. 예를 들어 pt16은 16포인트의 간격을 의미합니다.

## Topics 

### Enumeration Cases 

- [case pt01](/documentation/montage/spacing/pt01.md)

  1포인트 간격

- [case pt02](/documentation/montage/spacing/pt02.md)

  2포인트 간격

- [case pt04](/documentation/montage/spacing/pt04.md)

  4포인트 간격

- [case pt08](/documentation/montage/spacing/pt08.md)

  8포인트 간격

- [case pt12](/documentation/montage/spacing/pt12.md)

  12포인트 간격

- [case pt16](/documentation/montage/spacing/pt16.md)

  16포인트 간격 (기본 간격)

- [case pt20](/documentation/montage/spacing/pt20.md)

  20포인트 간격

- [case pt24](/documentation/montage/spacing/pt24.md)

  24포인트 간격

- [case pt28](/documentation/montage/spacing/pt28.md)

  28포인트 간격

- [case pt32](/documentation/montage/spacing/pt32.md)

  32포인트 간격

- [case pt36](/documentation/montage/spacing/pt36.md)

  36포인트 간격

- [case pt40](/documentation/montage/spacing/pt40.md)

  40포인트 간격

- [case pt48](/documentation/montage/spacing/pt48.md)

  48포인트 간격

- [case pt56](/documentation/montage/spacing/pt56.md)

  56포인트 간격

- [case pt64](/documentation/montage/spacing/pt64.md)

  64포인트 간격

- [case pt72](/documentation/montage/spacing/pt72.md)

  72포인트 간격

- [case pt80](/documentation/montage/spacing/pt80.md)

  80포인트 간격

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/spacing/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

