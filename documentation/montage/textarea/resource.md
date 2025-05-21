---
title: TextArea.Resource
description: 텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.
---

```swift
enum Resource
```

## Overview

다양한 종류의 컴포넌트를 텍스트 영역 하단에 배치할 수 있습니다. 문자 수 카운터, 버튼, 아이콘, 칩, 뱃지 등을 지원합니다.

>  Note
>
> 문자 수 카운터는 좌/우측 중 하나에만 사용 가능합니다. 중복 사용 시 좌측이 우선 표시됩니다.

## Topics

### Enumeration Cases


``case actionChip(ActionChip.Variant, title: String, handler: (() -> Void)?)``

액션 칩

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 칩 변형 스타일 |
  | `title` | 칩 텍스트 |
  | `handler` | 칩 클릭 핸들러 |

``case badge(ContentBadge.Variant, title: String)``

뱃지

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 뱃지 변형 스타일 |
  | `title` | 뱃지 텍스트 |

``case characterCount(limit: Int?, overflow: Bool)``

문자 수 카운터

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `limit` | 최대 문자 수 제한 (nil인 경우 제한 없음) |
  | `overflow` | 최대 문자 수 초과 허용 여부 |

``case filterChip(FilterChip.Variant, title: String, handler: (() -> Void)?)``

필터 칩

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 칩 변형 스타일 |
  | `title` | 칩 텍스트 |
  | `handler` | 칩 클릭 핸들러 |

``case icon(Icon, tintColor: SwiftUI.Color)``

단순 아이콘

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
  | `tintColor` | 아이콘 색상 |

``case iconButton(placement: Placement, variant: IconButton.Variant?, icon: Icon, tintColor: SwiftUI.Color, handler: (() -> Void)?)``

아이콘 버튼

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placement` | 버튼 위치 |
  | `variant` | 버튼 변형 스타일 |
  | `icon` | 버튼 아이콘 |
  | `tintColor` | 아이콘 색상 |
  | `handler` | 버튼 클릭 핸들러 |

``case textButton(placement: Placement, varaint: Button.Text.Variant?, title: String, handler: (() -> Void)?)``

텍스트 버튼

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `placement` | 버튼 위치 |
  | `varaint` | 버튼 변형 스타일 |
  | `title` | 버튼 텍스트 |
  | `handler` | 버튼 클릭 핸들러 |

### Enumerations


[``enum Placement``](/documentation/montage/textarea/resource/placement.md)

요소의 배치 위치를 정의합니다.

