//
//  PreviewOption.swift
//  Blueprint
//
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

/// `SegmentedControl`로 선택 가능한 Preview 옵션 enum을 위한 공통 프로토콜.
///
/// `CaseIterable`을 채택한 enum이 이 프로토콜을 따르면 ``SegmentedOptionRow``에서
/// 라벨과 선택 바인딩을 자동으로 구성한다. `selectableTitle`은 기본 구현이 제공되며,
/// 필요 시 각 타입에서 재정의할 수 있다.
protocol PreviewSegment: CaseIterable, Equatable {
    /// SegmentedControl 라벨로 표시될 제목.
    var selectableTitle: String { get }
}

extension PreviewSegment {
    var selectableTitle: String {
        let raw = String("\(self)".split(separator: "(").first?.split(separator: ".").last ?? "")
        return raw.prefix(1).uppercased() + raw.dropFirst()
    }
}

/// enum 옵션을 `SegmentedControl`로 선택하는 옵션 행.
///
/// ```swift
/// SegmentedOptionRow("size", selection: $fieldSize)
/// ```
struct SegmentedOptionRow<Option: PreviewSegment>: View {
    private let title: String
    @Binding private var selection: Option

    init(_ title: String, selection: Binding<Option>) {
        self.title = title
        self._selection = selection
    }

    var body: some View {
        let all = Array(Option.allCases)
        HStack {
            Text(title)
            SegmentedControl(
                selectedIndex: Binding(
                    get: { all.firstIndex(of: selection) ?? 0 },
                    set: { selection = all[$0] }
                ),
                labels: all.map(\.selectableTitle)
            )
            .size(.small)
        }
    }
}

/// 정수 인덱스 바인딩과 명시적 라벨 배열로 `SegmentedControl`을 구성하는 옵션 행.
///
/// 컴포넌트의 전체 case 중 일부만 노출하고 싶을 때 사용한다.
///
/// ```swift
/// SegmentedIndexRow("color", index: $colorIndex, labels: colors.map(\.description))
/// ```
struct SegmentedIndexRow: View {
    private let title: String
    @Binding private var index: Int
    private let labels: [String]

    init(_ title: String, index: Binding<Int>, labels: [String]) {
        self.title = title
        self._index = index
        self.labels = labels
    }

    var body: some View {
        HStack {
            Text(title)
            SegmentedControl(selectedIndex: $index, labels: labels)
                .size(.small)
        }
    }
}

/// 제목과 `Switch`를 묶은 토글 쌍.
///
/// `View` 본문이 `Text`와 `Switch`를 함께 반환하므로, 하나의 `HStack` 안에 여러 개를
/// 인라인으로 배치해 한 줄에 여러 토글을 나열할 수 있다.
///
/// ```swift
/// HStack {
///     ToggleOption("disable", isOn: $disable)
///     ToggleOption("loading", isOn: $loading)
/// }
/// ```
struct ToggleOption: View {
    private let title: String
    @Binding private var isOn: Bool

    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    @ViewBuilder
    var body: some View {
        Text(title)
        Switch(checked: isOn) { isOn = $0 }
    }
}

/// 토글 하나를 한 줄에 단독으로 배치하는 옵션 행.
struct ToggleOptionRow: View {
    private let title: String
    @Binding private var isOn: Bool

    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            ToggleOption(title, isOn: $isOn)
            Spacer(minLength: 0)
        }
    }
}

/// 숫자 값을 `Slider`로 조절하는 옵션 행. 현재 값을 제목과 함께 표시한다.
///
/// `Double`·`CGFloat` 등 `BinaryFloatingPoint` 값에 모두 사용할 수 있다.
///
/// ```swift
/// SliderOptionRow("offset", value: $offset, in: 0...200, step: 10)
/// ```
struct SliderOptionRow<Value: BinaryFloatingPoint>: View where Value.Stride: BinaryFloatingPoint {
    private let title: String
    @Binding private var value: Value
    private let range: ClosedRange<Value>
    private let step: Value.Stride
    private let format: (Value) -> String

    init(
        _ title: String,
        value: Binding<Value>,
        in range: ClosedRange<Value>,
        step: Value.Stride = 1,
        format: @escaping (Value) -> String = { "\(Int(Double($0)))" }
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.format = format
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(format(value))")
                .monospacedDigit()
            SwiftUI.Slider(value: $value, in: range, step: step)
        }
    }
}

/// 텍스트 입력을 받는 옵션 행.
///
/// ```swift
/// TextFieldOptionRow("heading", text: $heading)
/// ```
struct TextFieldOptionRow: View {
    private let title: String
    @Binding private var text: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    var body: some View {
        HStack {
            Text(title)
            TextField(text: $text)
        }
    }
}
