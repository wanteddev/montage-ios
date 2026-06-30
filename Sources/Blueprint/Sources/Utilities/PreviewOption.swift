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
/// `title`을 생략(`nil`)하면 라벨 없이 `SegmentedControl`만 그린다(다른 컨트롤 옆에 인라인 배치할 때).
///
/// ```swift
/// SegmentedOptionRow("size", selection: $fieldSize)
/// SegmentedOptionRow(selection: $fieldSize) // 라벨 없음
/// ```
struct SegmentedOptionRow<Option: PreviewSegment>: View {
    private let title: String?
    @Binding private var selection: Option

    init(_ title: String? = nil, selection: Binding<Option>) {
        self.title = title
        self._selection = selection
    }

    var body: some View {
        let all = Array(Option.allCases)
        HStack {
            if let title {
                Text(title)
            }
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
/// `title`을 생략(`nil`)하면 라벨 없이 `SegmentedControl`만 그린다(다른 컨트롤 옆에 인라인 배치할 때).
///
/// ```swift
/// SegmentedIndexRow("color", index: $colorIndex, labels: colors.map(\.description))
/// SegmentedIndexRow(index: $buttonsIndex, labels: buttons) // 라벨 없음
/// ```
struct SegmentedIndexRow: View {
    private let title: String?
    @Binding private var index: Int
    private let labels: [String]
    private let onSelect: ((Int) -> Void)?

    init(_ title: String? = nil, index: Binding<Int>, labels: [String], onSelect: ((Int) -> Void)? = nil) {
        self.title = title
        self._index = index
        self.labels = labels
        self.onSelect = onSelect
    }

    var body: some View {
        HStack {
            if let title {
                Text(title)
            }
            SegmentedControl(selectedIndex: $index, labels: labels, onSelect: onSelect)
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
    /// 드래그가 끝났을 때(놓았을 때) 호출된다. (`Slider`의 onEditingChanged 중 종료 시점)
    private let onEditingEnded: (() -> Void)?

    init(
        _ title: String,
        value: Binding<Value>,
        in range: ClosedRange<Value>,
        step: Value.Stride = 1,
        format: @escaping (Value) -> String = { "\(Int(Double($0)))" },
        onEditingEnded: (() -> Void)? = nil
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.format = format
        self.onEditingEnded = onEditingEnded
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(format(value))")
                .monospacedDigit()
            SwiftUI.Slider(value: $value, in: range, step: step) { isEditing in
                if !isEditing { onEditingEnded?() }
            }
        }
    }
}

/// 텍스트 입력을 받는 옵션 행. `placeholder`로 입력 전 안내 문구를 지정할 수 있다.
///
/// ```swift
/// TextFieldOptionRow("heading", text: $heading)
/// TextFieldOptionRow("Active Label", text: $label, placeholder: "활성화 상태일 때 표시할 텍스트")
/// ```
struct TextFieldOptionRow: View {
    private let title: String
    @Binding private var text: String
    private let placeholder: String?

    init(_ title: String, text: Binding<String>, placeholder: String? = nil) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(title)
            TextField(text: $text)
                .placeholder(placeholder)
        }
    }
}

/// 여러 줄 텍스트 입력을 받는 옵션 행. `placeholder`로 입력 전 안내 문구를 지정할 수 있다.
///
/// 한 줄 입력은 ``TextFieldOptionRow``를, 여러 줄 입력은 이 행을 쓴다.
///
/// ```swift
/// TextAreaOptionRow("step1 label", text: $label)
/// TextAreaOptionRow("memo", text: $memo, placeholder: "내용을 입력하세요")
/// ```
struct TextAreaOptionRow: View {
    private let title: String
    @Binding private var text: String
    private let placeholder: String?

    init(_ title: String, text: Binding<String>, placeholder: String? = nil) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(title)
            TextArea(text: $text)
                .placeholder(placeholder)
        }
    }
}

/// 색상을 고르는 `ColorPicker` 옵션 행. (`ColorPicker` 자체가 "라벨 … 스와치" 한 줄로 배치된다)
///
/// ```swift
/// ColorPickerOptionRow("backgroundColor", selection: $backgroundColor)
/// ColorPickerOptionRow("color", selection: $color, supportsOpacity: false)
/// ```
struct ColorPickerOptionRow: View {
    private let title: String
    @Binding private var selection: SwiftUI.Color
    private let supportsOpacity: Bool

    init(_ title: String, selection: Binding<SwiftUI.Color>, supportsOpacity: Bool = true) {
        self.title = title
        self._selection = selection
        self.supportsOpacity = supportsOpacity
    }

    var body: some View {
        SwiftUI.ColorPicker(title, selection: $selection, supportsOpacity: supportsOpacity)
    }
}

/// 라벨 + `Menu` 옵션 행. 메뉴 항목을 누르면 액션이 실행되는 형태에 쓴다.
///
/// "현재 선택값을 메뉴 라벨로 보여주며 각 항목이 임의 액션을 실행"하거나(예: 인덱스 변경)
/// "항목을 누를 때마다 컬렉션에 추가"하는 등 항목별 액션이 단순 바인딩이 아닐 때 쓴다.
/// `accessory`로 메뉴 옆에 reset 버튼 같은 보조 컨트롤을 둘 수 있다.
///
/// ```swift
/// // 현재 선택값을 라벨로 표시하는 단일 선택 메뉴
/// MenuOptionRow("Variant: ", menuLabel: variants[index].title) {
///     ForEach(variants.indices, id: \.self) { i in
///         Button(variants[i].title) { index = i }
///     }
/// }
///
/// // 항목을 누르면 추가, 옆에 reset 버튼
/// MenuOptionRow("leading", menuLabel: "add") {
///     ForEach(resources) { Button($0.title) { append($0) } }
/// } accessory: {
///     Button("reset") { resources.removeAll() }
/// }
/// ```
struct MenuOptionRow<Content: View, Accessory: View>: View {
    private let title: String
    private let menuLabel: String
    private let content: Content
    private let accessory: Accessory

    init(
        _ title: String,
        menuLabel: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.menuLabel = menuLabel
        self.content = content()
        self.accessory = accessory()
    }

    var body: some View {
        HStack {
            Text(title)
            Menu(menuLabel) { content }
            accessory
            Spacer(minLength: 0)
        }
    }
}

// accessory가 필요 없는 일반적인 경우를 위한 편의 이니셜라이저.
extension MenuOptionRow where Accessory == EmptyView {
    init(_ title: String, menuLabel: String, @ViewBuilder content: () -> Content) {
        self.init(title, menuLabel: menuLabel, content: content, accessory: { EmptyView() })
    }
}

/// 현재 정수 값을 1씩 증감하는 Previous / Next 버튼 쌍 옵션 행.
///
/// `value`를 `range` 안에서 ±1 하며, 경계(하한/상한)에 도달하면 해당 버튼을 비활성화한다.
/// PageCounter·PaginationDots·ProgressTracker처럼 "현재 페이지/단계"를 이동시키는 미리보기에 쓴다.
///
/// ```swift
/// PrevNextOptionRow(value: $selectedPage, in: 1...totalPages)
/// PrevNextOptionRow(value: $progress, in: 1...Int(stepCount))
/// ```
struct PrevNextOptionRow: View {
    @Binding private var value: Int
    private let range: ClosedRange<Int>

    init(value: Binding<Int>, in range: ClosedRange<Int>) {
        self._value = value
        self.range = range
    }

    var body: some View {
        HStack {
            Spacer()
            Button(variant: .outlined, size: .small, text: "Previous") {
                value = max(range.lowerBound, value - 1)
            }
            .disable(value <= range.lowerBound)

            Button(variant: .outlined, size: .small, text: "Next") {
                value = min(range.upperBound, value + 1)
            }
            .disable(value >= range.upperBound)
            Spacer()
        }
    }
}
