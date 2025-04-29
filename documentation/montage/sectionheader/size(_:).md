Instance Method

# size(_:) 

섹션 헤더의 크기를 설정합니다.

```swift
@MainActor
func size(_ size: Size) -> SectionHeader
```

## Parameters 

size

적용할 헤더 크기

## Return Value 

수정된 SectionHeader 인스턴스

## Discussion 

크기에 따라 폰트 크기와 높이가 자동으로 조정됩니다. xsmall 크기를 선택하면 타이틀 색상이 .labelAlternative로 변경됩니다.

> **Note**
>
> 기본값은 .medium입니다.

