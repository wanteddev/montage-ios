**ENUM**

# `TextField.Status`

```swift
public enum Status
```

텍스트 필드의 상태를 정의합니다.

- `.normal`: 기본 상태, 선택적으로 설명 텍스트 포함 가능
- `.positive`: 유효한 입력 상태, 선택적으로 설명 텍스트 포함 가능
- `.negative`: 오류 상태, 선택적으로 오류 설명 텍스트 포함 가능

## Cases
### `normal(description:)`

```swift
case normal(description: String = "")
```

### `positive(description:)`

```swift
case positive(description: String = "")
```

### `negative(description:)`

```swift
case negative(description: String = "")
```
