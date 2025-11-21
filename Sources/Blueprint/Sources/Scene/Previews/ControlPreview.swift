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
    @State private var showTransparentChecker: Bool = false
    @State private var stateIndex = 0
    @State private var state: Checkbox.State = .unchecked
    @State private var checked: Bool = false
    @State private var selected: Bool = false
    @State private var switched: Bool = false
    @State private var sizeIndex = 0
    @State private var disabled: Bool = false
    @State private var tight: Bool = false
    @State private var label: String = ""
    @State private var bold: Bool = false
    @State private var customTypography = false
    @State private var guideLine: Bool = false

    private let sizeLabels: [String] = ["small", "medium"]
    private let states: [Checkbox.State] = [.unchecked, .checked, .indeterminate]

    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: { guideLine.toggle() }) {
                        Image(systemName: "rectangle.dashed")
                    }
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                VStack {
                    HStack {
                        Spacer()
                        Checkbox(
                            state: state,
                            size: sizeIndex == 0 ? .small : .medium
                        ) {
                            state = $0
                        }
                        .disable(disabled)
                        .bold(bold)
                        .tight(tight)
                        .label(label)
                        .if(customTypography) {
                            $0.labelTypography(.heading2, weight: .medium, color: .semantic(.accentBackgroundPink))
                        }
                        .border(guideLine ? Color.blue : Color.clear)
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
                        .disable(disabled)
                        .bold(bold)
                        .tight(tight)
                        .label(label)
                        .if(customTypography) {
                            $0.labelTypography(.heading2, weight: .bold, color: .semantic(.accentBackgroundPink))
                        }
                        .border(guideLine ? Color.blue : Color.clear)
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
                        .disable(disabled)
                        .bold(bold)
                        .tight(tight)
                        .label(label)
                        .if(customTypography) {
                            $0.labelTypography(.heading2, weight: .bold, color: .semantic(.accentBackgroundPink))
                        }
                        .border(guideLine ? Color.blue : Color.clear)
                        Spacer()
                    }
                    Switch(
                        checked: switched,
                        size: sizeIndex == 0 ? .small : .medium
                    ) {
                        switched = $0
                    }
                    .disable(disabled)
                    .border(guideLine ? Color.blue : Color.clear)
                }
                Text("Options").bold()
                HStack {
                    Text("state")
                    SegmentedControl(selectedIndex: $stateIndex, labels: states.map(\.description)) {
                        state = states[$0]
                        checked = $0 != 0
                        selected = $0 != 0
                        switched = $0 != 0
                    }
                    .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizeLabels
                    )
                    .size(.small)
                }
                HStack {
                    Text("disabled")
                    Switch(checked: disabled) { disabled = $0 }
                    Text("bold")
                    Switch(checked: bold) { bold = $0 }
                    Text("tight")
                    Switch(checked: tight) { tight = $0 }
                }
                HStack {
                    Text("label")
                    TextField(text: $label)
                }
                HStack {
                    Text("custom label typography")
                    Switch(checked: customTypography) { customTypography = $0 }
                }
            }
            .padding(.horizontal)
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Checkbox.State: CaseDescribable {}

#Preview {
    ControlPreview()
}
