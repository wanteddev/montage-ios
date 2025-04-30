**ENUM**

# `Dot.Size`

```swift
public enum Size
```

점 페이지네이션의 크기를 지정하는 열거형입니다.

UI 디자인 요구사항에 따라 점의 크기를 선택할 수 있습니다.

**사용 예시**:
```swift
// 작은 크기의 점 페이지네이션
Pagination.Dot(selectedPage: $currentPage, totalPages: 5)
    .size(.small)
```

## Cases
### `normal`

```swift
case normal
```

표준 크기 (10pt 직경)

### `small`

```swift
case small
```

작은 크기 (6pt 직경)
