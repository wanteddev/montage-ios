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
    @State private var state: Control.State = .unchecked
    @State private var checked: Bool = false
    @State private var selected: Bool = false
    @State private var switched: Bool = false
    @State private var sizeIndex = 0
    @State private var disabled: Bool = false
    @State private var tight: Bool = false
    @State private var label: String = ""
    @State private var bold: Bool = false
    @State private var customTypography = false
    @State private var guideLine: Bool = true
    
    private let sizes: [Control.Size] = [.small, .medium]
    private let states: [Control.State] = [.unchecked, .checked, .indeterminate]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Text("guide line").font(.caption)
                    Control.switch(checked: guideLine) { guideLine = $0 }
                }
                VStack {
                    HStack {
                        Spacer()
                        Control.checkbox(
                            state: state,
                            size: sizes[sizeIndex]
                        ) {
                            state = $0
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
                        Control.checkmark(
                            checked: checked,
                            size: sizes[sizeIndex]
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
                        Control.radio(
                            checked: selected,
                            size: sizes[sizeIndex]
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
                    Control.switch(
                        checked: switched,
                        size: sizes[sizeIndex]
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
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("disabled")
                    Control.switch(checked: disabled) { disabled = $0 }
                    Text("bold")
                    Control.switch(checked: bold) { bold = $0 }
                    Text("tight")
                    Control.switch(checked: tight) { tight = $0 }
                }
                HStack {
                    Text("label")
                    TextField(text: $label)
                }
                HStack {
                    Text("custom label typography")
                    Control.switch(checked: customTypography) { customTypography = $0 }
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Control.Size: CaseDescribable {}
extension Control.Variant: CaseDescribable {}
extension Control.State: CaseDescribable {}

#Preview {
    ControlPreview()
}
