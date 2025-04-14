//
//  InputPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/20/25.
//

import SwiftUI
import Montage

public struct InputPreview: View {
    @State var guideLine: Bool = true
    @State var isSmallSize: Bool = false
    @State var isDisable: Bool = false
    @State var text: String = "텍스트"
    @State var bold: Bool = false
    @State var tight: Bool = false
    @State private var stateIndex = 0
    @State private var state: Control.State = .unchecked
    @State private var checked: Bool = false
    @State private var selected: Bool = false
    @State var customTypography = false
    
    public var body: some View {
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Text("guide line").font(.caption)
                    Control.Switch($guideLine)
                }
                HStack {
                    Group {
                        Input.checkbox(
                            state: state,
                            text: text
                        ) {
                            state = $0
                        }
                        .size(isSmallSize ? .small : .medium)
                        .disable(isDisable)
                        .bold(bold)
                        .tight(tight)
                        .if(customTypography) {
                            $0.title(.heading2, weight: .bold, color: .semantic(.accentBackgroundPink))
                        }
                        Input.checkmark(
                            $checked,
                            text: text
                        )
                        .size(isSmallSize ? .small : .medium)
                        .disable(isDisable)
                        .bold(bold)
                        .tight(tight)
                        .if(customTypography) {
                            $0.title(.heading2, weight: .bold, color: .semantic(.accentBackgroundPink))
                        }
                        Input.radio(
                            $selected,
                            text: text
                        )
                        .size(isSmallSize ? .small : .medium)
                        .disable(isDisable)
                        .bold(bold)
                        .tight(tight)
                        .if(customTypography) {
                            $0.title(.heading2, weight: .bold, color: .semantic(.accentBackgroundPink))
                        }
                    }
                    .if(guideLine) {
                        $0.border(.blue)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
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
                    Text("small size")
                    Control.Switch($isSmallSize)
                    Text("disable")
                    Control.Switch($isDisable)
                }
                HStack {
                    Text("bold")
                    Control.Switch($bold)
                    Text("tight")
                    Control.Switch($tight)
                }
                HStack {
                    Text("text")
                    TextInput.TextField(text: $text)
                }
                HStack {
                    Text("custom title typography")
                    Control.Switch($customTypography)
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    InputPreview()
}
