Enumeration

# Toast.Variant 

토스트 메시지의 시각적 스타일을 정의하는 열거형입니다.

```swift
enum Variant
```

## Overview 

- normal: 기본 토스트 스타일 (선택적으로 아이콘과 색상 지정 가능)
- positive: 성공이나 긍정적인 메시지를 위한 녹색 체크 아이콘 스타일
- cautionary: 주의가 필요한 메시지를 위한 주황색 경고 아이콘 스타일
- negative: 오류나 실패 메시지를 위한 빨간색 아이콘 스타일

## Topics 

### Enumeration Cases 

- [case cautionary](/documentation/montage/toast/variant/cautionary.md)

  주의 메시지를 위한 주황색 경고 아이콘 스타일

- [case negative](/documentation/montage/toast/variant/negative.md)

  오류 메시지를 위한 빨간색 경고 아이콘 스타일

- [case normal(Montage.Icon?, tint: Montage.Color.Semantic?)](/documentation/montage/toast/variant/normal(_:tint:).md)

  기본 스타일의 토스트

- [case positive](/documentation/montage/toast/variant/positive.md)

  성공 메시지를 위한 녹색 체크 아이콘 스타일

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/toast/variant/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

