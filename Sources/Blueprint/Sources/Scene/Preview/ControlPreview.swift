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
    @State private var sizeIndex = 0
    @State private var disabled: Bool = false
    @State private var tight: Bool = false
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
                    Control.Switch($guideLine)
                }
                HStack {
                    Spacer()
                    Group {
                        Control.checkbox(
                            $state,
                            size: sizes[sizeIndex]
                        )
                        .disable(disabled)
                        .tight(tight)
                        Control.checkmark(
                            checked: checked,
                            size: sizes[sizeIndex]
                        ) {
                            self.checked = $0
                        }
                        .disable(disabled)
                        .tight(tight)
                        Control.radio(
                            $selected,
                            size: sizes[sizeIndex]
                        )
                        .disable(disabled)
                        .tight(tight)
                    }
                    .border(guideLine ? Color.blue : Color.clear)
                    Spacer()
                }
                Text("Options").bold()
                HStack {
                    Text("state")
                    SegmentedControl(selectedIndex: $stateIndex, labels: states.map(\.description)) {
                        state = states[$0]
                        checked = $0 != 0
                        selected = $0 != 0
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
                    Control.Switch($disabled)
                    Text("tight")
                    Control.Switch($tight)
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

struct CheckboxPreview_Previews: PreviewProvider {
    @State static private var isOn: Bool = true
    static var previews: some View {
        ControlPreview()
    }
}
