# ``Montage``

Wanted Design System

## Overview

Montage는 원티드랩 내부에서 UI를 작성할 때 사용할 수 있는 디자인시스템 모듈입니다. 이 모듈은 미리 만들어진 여러 엘리먼트들과 시스템 UI 프레임워크의 Extension 등을 제공하여, 조직에서 요구되는 UI 결과물을 빠르고 일관성 있게 제작할 수 있도록 돕습니다.

Montage가 제공하는 여러 구성 요소와 사용 예시들을 한눈에 볼 수 있도록 샘플 앱 프로젝트를 제공하고 있습니다. Github의 [wanteddev/blueprint-ios](https://github.com/wanteddev/blueprint-ios) 저장소를 참고해 주세요.

![Screenshot of Blueprint app](montage-introduction.jpg)

## Topics

### Foundation

Foundation 요소들은 모두 UI 프레임워크 내 특정 클래스의 Extension을 통해 사용할 수 있도록 구현되었습니다. 아래 문서에서 Foundation 요소들의 사용법과 샘플 코드를 확인할 수 있습니다.

- <doc:UseFoundation>

### Element

Element 요소는 UI의 기본이 될 수 있는 작은 단위를 이루는 요소들입니다. 

- ``Montage/Checkbox``
- ``Montage/Radio``
- ``Montage/NestedCheck``
- ``Montage/Switch``
- ``Montage/Divider``
- ``Montage/Opacity``

### Component

Component 요소는 자주 쓰일 수 있는 UI 요소를 미리 만든 것으로, 여러개의 Element 요소가 함께 결합하여 이루어집니다.      

- ``Montage/InputLabel``
