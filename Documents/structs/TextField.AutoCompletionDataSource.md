**STRUCT**

# `TextField.AutoCompletionDataSource`

```swift
public struct AutoCompletionDataSource: Equatable
```

텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.

이 구조체를 사용하여 자동완성 목록의 섹션, 항목, 레이아웃 등을 정의할 수 있습니다.

## Properties
<details><summary markdown="span"><code>totalNumberOfItems</code></summary>

```swift
public var totalNumberOfItems: Int
```

전체 항목 수를 반환합니다.

</details>

## Methods
<details><summary markdown="span"><code>==(_:_:)</code></summary>

```swift
public static func == (lhs: AutoCompletionDataSource, rhs: AutoCompletionDataSource) -> Bool
```



</details>

<details><summary markdown="span"><code>init(numberOfSections:sectionTitleAt:numberOfItemsInSection:cellForItemAt:headerView:footerView:maxHeight:)</code></summary>

```swift
public init(
    numberOfSections: Int = 1,
    sectionTitleAt: ((Int) -> String)? = nil,
    numberOfItemsInSection: @escaping (Int) -> Int,
    cellForItemAt: @escaping (IndexPath) -> any View,
    headerView: (() -> any View)? = nil,
    footerView: (() -> any View)? = nil,
    maxHeight: CGFloat = 400
)
```

자동완성 데이터 소스를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| numberOfSections | 섹션 수, 기본값은 1 |
| sectionTitleAt | 섹션 제목을 반환하는 클로저 |
| numberOfItemsInSection | 각 섹션의 항목 수를 반환하는 클로저 |
| cellForItemAt | 각 항목의 뷰를 반환하는 클로저 |
| headerView | 헤더 뷰를 반환하는 클로저 |
| footerView | 푸터 뷰를 반환하는 클로저 |
| maxHeight | 자동완성 목록의 최대 높이, 기본값은 400 |

#### Returns

구성된 자동완성 데이터 소스 인스턴스



</details>
