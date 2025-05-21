---
title: TextField.AutoCompletionDataSource
description: 텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.
---

```swift
struct AutoCompletionDataSource
```

## Overview

이 구조체를 사용하여 자동완성 목록의 섹션, 항목, 레이아웃 등을 정의할 수 있습니다.

## Topics

### Operators


``static func == (AutoCompletionDataSource, AutoCompletionDataSource) -> Bool``

### Initializers


``init(numberOfSections: Int, sectionTitleAt: ((Int) -> String)?, numberOfItemsInSection: (Int) -> Int, cellForItemAt: (IndexPath) -> any View, headerView: (() -> any View)?, footerView: (() -> any View)?, maxHeight: CGFloat)``

자동완성 데이터 소스를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `numberOfSections` | 섹션 수, 기본값은 1 |
  | `sectionTitleAt` | 섹션 제목을 반환하는 클로저 |
  | `numberOfItemsInSection` | 각 섹션의 항목 수를 반환하는 클로저 |
  | `cellForItemAt` | 각 항목의 뷰를 반환하는 클로저 |
  | `headerView` | 헤더 뷰를 반환하는 클로저 |
  | `footerView` | 푸터 뷰를 반환하는 클로저 |
  | `maxHeight` | 자동완성 목록의 최대 높이, 기본값은 400 |
- **Return Value**

  구성된 자동완성 데이터 소스 인스턴스

### Instance Properties


``var totalNumberOfItems: Int``

전체 항목 수를 반환합니다.

### Default Implementations


[Equatable Implementations](/documentation/montage/textfield/autocompletiondatasource/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`



