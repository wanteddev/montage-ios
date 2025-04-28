**ENUM**

# `Dot.Variant`

```swift
public enum Variant
```

점 페이지네이션의 색상 변형을 지정하는 열거형입니다.

배경색이나 사용 컨텍스트에 따라 적합한 색상 테마를 선택할 수 있습니다.

**사용 예시**:
```swift
// 어두운 배경에 사용
Pagination.Dot(selectedPage: $currentPage, totalPages: 5)
    .variant(.white)
```

## Cases
### `normal`

```swift
case normal
```

기본 스타일 (회색 배경에 검은색 점)

### `white`

```swift
case white
```

흰색 스타일 (어두운 배경에 적합)
