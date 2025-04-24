**STRUCT**

# `TextField.AutoCompletionDataSource`

```swift
public struct AutoCompletionDataSource: Equatable
```

## Properties
<details><summary markdown="span"><code>totalNumberOfItems</code></summary>

```swift
public var totalNumberOfItems: Int
```

</details>

## Methods
<details><summary markdown="span"><code>==(_:_:)</code></summary>

```swift
public static func == (lhs: AutoCompletionDataSource, rhs: AutoCompletionDataSource) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A value to compare. |
| rhs | Another value to compare. |

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

</details>