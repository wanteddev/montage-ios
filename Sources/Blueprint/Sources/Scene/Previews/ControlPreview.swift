//
//  ControlPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 9/20/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//


import SwiftUI
import Montage

struct ControlPreview: View {
    @State private var stateIndex = 0
    @State private var state: Checkbox.State = .unchecked
    @State private var checked: Bool = false
    @State private var selected: Bool = false
    @State private var switched: Bool = false
    @State private var sizeIndex = 0
    @State private var disabled: Bool = false
    @State private var tight: Bool = false
    @State private var fillWidth: Bool = true
    @State private var label: String = ""
    @State private var bold: Bool = false
    @State private var customTypography = false
    @State private var guideLine: Bool = false

    private let sizeLabels: [String] = ["small", "medium"]
    private let states: [Checkbox.State] = [.unchecked, .checked, .indeterminate]

    var body: some View {
        PreviewLayout {
            VStack {
                HStack {
                    Spacer()
                    Checkbox(
                        state: state,
                        size: sizeIndex == 0 ? .small : .medium
                    ) {
                        state = $0
                    }
                    .bold(bold)
                    .tight(tight)
                    .label(label, fillWidth: fillWidth)
                    .if(customTypography) {
                        $0.labelTypography(.heading2, weight: .medium, color: .semantic(.foregroundAccentPink))
                    }
                    .border(guideLine ? Color.blue : Color.clear)
                    .disabled(disabled)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Checkmark(
                        checked: checked,
                        size: sizeIndex == 0 ? .small : .medium
                    ) {
                        checked = $0
                    }
                    .bold(bold)
                    .tight(tight)
                    .label(label, fillWidth: fillWidth)
                    .if(customTypography) {
                        $0.labelTypography(.heading2, weight: .bold, color: .semantic(.foregroundAccentPink))
                    }
                    .border(guideLine ? Color.blue : Color.clear)
                    .disabled(disabled)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Radio(
                        checked: selected,
                        size: sizeIndex == 0 ? .small : .medium
                    ) {
                        selected = $0
                    }
                    .bold(bold)
                    .tight(tight)
                    .label(label, fillWidth: fillWidth)
                    .if(customTypography) {
                        $0.labelTypography(.heading2, weight: .bold, color: .semantic(.foregroundAccentPink))
                    }
                    .border(guideLine ? Color.blue : Color.clear)
                    .disabled(disabled)
                    Spacer()
                }
                Switch(
                    checked: switched,
                    size: sizeIndex == 0 ? .small : .medium
                ) {
                    switched = $0
                }
                .disabled(disabled)
                .border(guideLine ? Color.blue : Color.clear)
            }
        } options: {
            SegmentedIndexRow("state", index: $stateIndex, labels: states.map(\.description)) {
                state = states[$0]
                checked = $0 != 0
                selected = $0 != 0
                switched = $0 != 0
            }
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizeLabels)
            HStack {
                ToggleOption("disabled", isOn: $disabled)
                ToggleOption("bold", isOn: $bold)
            }
            HStack {
                ToggleOption("tight", isOn: $tight)
                ToggleOption("fillWidth", isOn: $fillWidth)
            }
            TextFieldOptionRow("label", text: $label)
            ToggleOptionRow("custom label typography", isOn: $customTypography)
        } accessory: {
            SwiftUI.Button(action: { guideLine.toggle() }) {
                Image(systemName: "rectangle.dashed")
            }
        }
    }
}

extension Checkbox.State: CaseDescribable {}

#Preview {
    ControlPreview()
}
