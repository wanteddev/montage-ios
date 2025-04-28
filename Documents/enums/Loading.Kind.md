**ENUM**

# `Loading.Kind`

```swift
public enum Kind
```

로딩 애니메이션의 종류를 정의하는 열거형입니다.

애플리케이션의 디자인 요구사항이나 컨텍스트에 따라 적절한 로딩 스타일을 선택할 수 있습니다.

**사용 예시**:
```swift
// Wanted 스타일 로딩 사용
Loading(kind: .wanted)

// 원형 로딩 사용
Loading(kind: .circular)
```

## Cases
### `wanted`

```swift
case wanted
```

Wanted 브랜드 스타일의 로딩 애니메이션

### `circular`

```swift
case circular
```

원형 회전 로딩 애니메이션
