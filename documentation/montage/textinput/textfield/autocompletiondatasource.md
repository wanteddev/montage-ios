Structure

# TextInput.TextField.AutoCompletionDataSource 

텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.

```swift
struct AutoCompletionDataSource
```

## Overview 

이 구조체를 사용하여 자동완성 목록의 섹션, 항목, 레이아웃 등을 정의할 수 있습니다.

## Topics 

### Operators 

- [static func == (AutoCompletionDataSource, AutoCompletionDataSource) -> Bool](/documentation/montage/textinput/textfield/autocompletiondatasource/==(_:_:).md)

### Initializers 

- [init(numberOfSections: Int, sectionTitleAt: ((Int) -> String)?, numberOfItemsInSection: (Int) -> Int, cellForItemAt: (IndexPath) -> any View, headerView: (() -> any View)?, footerView: (() -> any View)?, maxHeight: CGFloat)](/documentation/montage/textinput/textfield/autocompletiondatasource/init(numberofsections:sectiontitleat:numberofitemsinsection:cellforitemat:headerview:footerview:maxheight:).md)

  자동완성 데이터 소스를 초기화합니다.

### Instance Properties 

- [var totalNumberOfItems: Int](/documentation/montage/textinput/textfield/autocompletiondatasource/totalnumberofitems.md)

  전체 항목 수를 반환합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/textinput/textfield/autocompletiondatasource/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

