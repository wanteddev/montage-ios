---
1title: init(numberofsections:sectiontitleat:numberofitemsinsection:cellforitemat:headerview:footerview:maxheight:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(numberOfSections:sectionTitleAt:numberOfItemsInSection:cellForItemAt:headerView:footerView:maxHeight:) 

자동완성 데이터 소스를 초기화합니다.

```swift
init(
    numberOfSections: Int = 1,
    sectionTitleAt: ((Int) -> String)? = nil,
    numberOfItemsInSection: @escaping (Int) -> Int,
    cellForItemAt: @escaping (IndexPath) -> any View,
    headerView: (() -> any View)? = nil,
    footerView: (() -> any View)? = nil,
    maxHeight: CGFloat = 400
)
```

## Parameters 

numberOfSections

섹션 수, 기본값은 1

sectionTitleAt

섹션 제목을 반환하는 클로저

numberOfItemsInSection

각 섹션의 항목 수를 반환하는 클로저

cellForItemAt

각 항목의 뷰를 반환하는 클로저

headerView

헤더 뷰를 반환하는 클로저

footerView

푸터 뷰를 반환하는 클로저

maxHeight

자동완성 목록의 최대 높이, 기본값은 400

## Return Value 

구성된 자동완성 데이터 소스 인스턴스

