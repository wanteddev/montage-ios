---
title: ActionArea.Model
description: ActionArea를 구성하기 위한 모델 구조체입니다.
---

```swift
struct Model
```

## Overview

이 구조체는 ActionArea의 모든 구성 정보를 담아 ActionAreaModifier에 전달합니다. 버튼 레이아웃, 배경 가시성, 캡션 텍스트, 추가 콘텐츠 등을 구성할 수 있습니다.

## Topics

### Initializers


``init(variant: ActionArea.Variant, backgroundVisibility: BackgroundVisibility, caption: String?, extra: (() -> any View)?, extraDivider: Bool)``

ActionArea 모델을 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 버튼 레이아웃 변형 |
  | `backgroundVisibility` | 배경 가시성 설정 |
  | `caption` | 캡션 텍스트 |
  | `extra` | 추가 콘텐츠를 생성하는 클로저 |
  | `extraDivider` | 추가 콘텐츠 위에 구분선 표시 여부 |

