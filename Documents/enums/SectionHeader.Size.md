**ENUM**

# `SectionHeader.Size`

```swift
public enum Size
```

섹션 헤더의 크기를 정의하는 열거형입니다.

콘텐츠의 중요도나 시각적 계층 구조에 따라 4가지 크기 옵션을 제공합니다.
각 크기는 서로 다른 폰트 크기와 높이를 가지며, 콘텐츠 구조에 맞게 선택할 수 있습니다.

**사용 예시**:
```swift
SectionHeader(title: "주요 기능")
    .size(.large) // 큰 크기의 헤더 사용
```

- Note: xsmall(20pt), small(24pt), medium(28pt), large(32pt) 네 가지 크기를 제공합니다.

## Cases
### `xsmall`

```swift
case xsmall
```

가장 작은 크기 (20pt, label1 폰트)

### `small`

```swift
case small
```

작은 크기 (24pt, headline2 폰트)

### `medium`

```swift
case medium
```

중간 크기 (28pt, heading2 폰트, 기본값)

### `large`

```swift
case large
```

큰 크기 (32pt, title3 폰트)
