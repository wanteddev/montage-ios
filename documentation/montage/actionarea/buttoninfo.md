---
title: ActionArea.ButtonInfo
description: ActionArea에 표시될 버튼 정보를 정의하는 구조체입니다.
---

```swift
struct ButtonInfo
```

## Overview

버튼의 텍스트, 액션, 커스텀 뷰 등을 지정할 수 있습니다.

## Topics

### Initializers


``init(text: String, action: (() -> Void))``

기본 버튼 정보를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 버튼에 표시할 텍스트 |
  | `action` | 버튼 클릭 시 실행할 액션 |
- **Return Value**

  구성된 ButtonInfo 인스턴스

### Type Methods


``static func custom((() -> any View)) -> ActionArea.ButtonInfo``

커스텀 버튼 뷰를 사용하는 버튼 정보를 생성합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `custom` | 커스텀 버튼 뷰를 생성하는 클로저 |
- **Return Value**

  커스텀 뷰가 포함된 ButtonInfo 인스턴스
- **Discussion**
  >  Note
  >
  > 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하세요.


