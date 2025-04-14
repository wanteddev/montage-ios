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
                            size: Control.Size.allCases[sizeIndex]
                        )
                        .disable(disabled)
                        .tight(tight)
                        Control.checkmark(
                            checked: checked,
                            size: Control.Size.allCases[sizeIndex]
                        ) {
                            self.checked = $0
                        }
                        .disable(disabled)
                        .tight(tight)
                        Control.radio(
                            $selected,
                            size: Control.Size.allCases[sizeIndex]
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
                    SegmentedControl(selectedIndex: $stateIndex, labels: Control.State.allCases.map(\.rawValue)) {
                        state = Control.State.allCases[$0]
                        checked = $0 != 0
                        selected = $0 != 0
                    }
                    .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: Control.Size.allCases.map(\.rawValue))
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


struct CheckboxPreview_Previews: PreviewProvider {
    @State static private var isOn: Bool = true
    static var previews: some View {
        ControlPreview()
    }
}
