---
title: Typography.Variant
description: 텍스트 변형을 정의하는 열거형
---

```swift
enum Variant
```

## Overview

Variant는 텍스트의 용도와 계층 구조에 따라 서로 다른 사이즈, 자간, 행간 값을 갖는 텍스트 스타일을 정의합니다.

:

- Display: 가장 크고 강조된 텍스트 (배너, 랜딩 페이지 등)
- Title: 주요 제목 텍스트
- Heading: 중간 크기의 제목 텍스트
- Headline: 소제목 텍스트
- Body: 기본 본문 텍스트
- Label: 작은 텍스트 (버튼, 폼 레이블 등)
- Caption: 가장 작은 보조 텍스트

## Topics

### Enumeration Cases


``case body1``

기본 본문 텍스트

``case body1Reading``

긴 텍스트용 본문

``case body2``

작은 본문 텍스트

``case body2Reading``

긴 텍스트용 작은 본문

``case caption1``

캡션 텍스트

``case caption2``

작은 캡션 텍스트

``case display1``

가장 큰 디스플레이 텍스트

``case display2``

큰 디스플레이 텍스트

``case heading1``

주요 헤딩

``case heading2``

보조 헤딩

``case headline1``

강조 헤드라인

``case headline2``

일반 헤드라인

``case label1``

라벨 텍스트

``case label1Reading``

긴 텍스트용 라벨

``case label2``

작은 라벨 텍스트

``case title1``

대제목

``case title2``

중간 제목

``case title3``

소제목

### Instance Properties


``var lineSpacing: CGFloat``

``var padding: CGFloat``

### Default Implementations


[Equatable Implementations](/documentation/montage/typography/variant/equatable-implementations.md)

## Relationships

Conforms To

`Swift.CaseIterable`

`Swift.Equatable`

`Swift.Hashable`



