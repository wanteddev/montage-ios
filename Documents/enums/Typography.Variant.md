**ENUM**

# `Typography.Variant`

```swift
public enum Variant: CaseIterable
```

텍스트 변형을 정의하는 열거형

Variant는 텍스트의 용도와 계층 구조에 따라 서로 다른 사이즈, 
자간, 행간 값을 갖는 텍스트 스타일을 정의합니다.

**계층 구조**:
- Display: 가장 크고 강조된 텍스트 (배너, 랜딩 페이지 등)
- Title: 주요 제목 텍스트
- Heading: 중간 크기의 제목 텍스트
- Headline: 소제목 텍스트
- Body: 기본 본문 텍스트
- Label: 작은 텍스트 (버튼, 폼 레이블 등)
- Caption: 가장 작은 보조 텍스트

## Cases
### `display1`

```swift
case display1
```

가장 큰 디스플레이 텍스트 (56pt)

### `display2`

```swift
case display2
```

큰 디스플레이 텍스트 (40pt)

### `title1`

```swift
case title1
```

대제목 (36pt)

### `title2`

```swift
case title2
```

중간 제목 (28pt)

### `title3`

```swift
case title3
```

소제목 (24pt)

### `heading1`

```swift
case heading1
```

주요 헤딩 (22pt)

### `heading2`

```swift
case heading2
```

보조 헤딩 (20pt)

### `headline1`

```swift
case headline1
```

강조 헤드라인 (18pt)

### `headline2`

```swift
case headline2
```

일반 헤드라인 (17pt)

### `body1`

```swift
case body1
```

기본 본문 텍스트 (16pt)

### `body1Reading`

```swift
case body1Reading
```

긴 텍스트용 본문 (16pt, 높은 행간)

### `body2`

```swift
case body2
```

작은 본문 텍스트 (15pt)

### `body2Reading`

```swift
case body2Reading
```

긴 텍스트용 작은 본문 (15pt, 높은 행간)

### `label1`

```swift
case label1
```

라벨 텍스트 (14pt)

### `label1Reading`

```swift
case label1Reading
```

긴 텍스트용 라벨 (14pt, 높은 행간)

### `label2`

```swift
case label2
```

작은 라벨 텍스트 (13pt)

### `caption1`

```swift
case caption1
```

캡션 텍스트 (12pt)

### `caption2`

```swift
case caption2
```

작은 캡션 텍스트 (11pt)
