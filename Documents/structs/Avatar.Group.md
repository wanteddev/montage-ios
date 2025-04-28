**STRUCT**

# `Avatar.Group`

```swift
public struct Group: View
```

여러 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.

최대 5개의 아바타를 부분적으로 겹쳐 표시하며, 각 아바타에 개별 탭 동작을 지정할 수 있습니다.

**사용 예시**:
```swift
// 기본 그룹 아바타
Avatar.Group(
    ["https://example.com/user1.jpg", "https://example.com/user2.jpg"],
    variant: .person,
    size: .small
)

// 탭 동작과 후행 콘텐츠가 있는 그룹 아바타
Avatar.Group(
    imageUrls,
    variant: .person,
    size: .small,
    onTap: { index in
        print("탭한 아바타 인덱스: \(index)")
    }
)
.trailingContent {
    Text("+3").montage(variant: .body2)
}
```

- Note: 아바타는 왼쪽에서 오른쪽으로 겹쳐서 표시되며, 마지막 아바타가 가장 앞에 표시됩니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:variant:size:onTap:)</code></summary>

```swift
public init(
    _ imageUrls: [String],
    variant: Avatar.Variant,
    size: Size,
    onTap: ((_ index: Int) -> Void)? = nil
)
```

그룹 아바타를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| imageUrls | 표시할 이미지의 URL 문자열 배열 (최대 5개) |
| variant | 아바타 유형 (.person, .company, .academy) |
| size | 그룹 아바타 크기 |
| onTap | 각 아바타 탭 시 실행할 액션 (인덱스가 전달됨) (기본값: nil) |




</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ trailingContent: @escaping () -> any View) -> Self
```

그룹 아바타 오른쪽에 추가적인 콘텐츠를 표시합니다.

이 수정자를 사용하여 아바타 그룹 옆에 추가 정보(예: "+3" 같은 추가 멤버 수)를 표시할 수 있습니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| trailingContent | 표시할 뷰를 생성하는 클로저 |

#### Returns

수정된 그룹 아바타 인스턴스



</details>
