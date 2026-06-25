//
//  SliderPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct SliderPreview: View {
    @State private var variantIndex: Int = 0
    @State private var heading = true
    @State private var label = true
    @State private var disable = false
    @State private var lowerBound: Int = 0
    @State private var upperBound: Int = 10
    @State private var unit = "km"

    var body: some View {
        PreviewLayout {
            if variantIndex == 0 {
                Slider(minValue: CGFloat(lowerBound), maxValue: CGFloat(upperBound), labelFormatter: { value in
                    "\(Int(value.rounded()))\(unit)"
                })
                .heading(heading)
                .label(label)
                .disable(disable)
            } else {
                Slider(isRangeSlider: true, minValue: CGFloat(lowerBound), maxValue: CGFloat(upperBound), labelFormatter: { value in
                    "\(Int(value.rounded()))\(unit)"
                })
                .heading(heading)
                .label(label)
                .disable(disable)
            }
        } options: {
            HStack {
                Text("range")
                Picker("from", selection: $lowerBound) {
                    ForEach(0...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.inline)
                Picker("to", selection: $upperBound) {
                    ForEach(0...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.inline)
            }
            TextFieldOptionRow("unit", text: $unit)
            SegmentedIndexRow("variant", index: $variantIndex, labels: ["single", "double"])
            ToggleOptionRow("heading", isOn: $heading)
            ToggleOptionRow("label", isOn: $label)
            ToggleOptionRow("disable", isOn: $disable)
        }
        .onChange(of: lowerBound) { _ in
            Task {
                if lowerBound > upperBound {
                    upperBound = lowerBound
                }
            }
        }
        .onChange(of: upperBound) { _ in
            Task {
                if lowerBound > upperBound {
                    lowerBound = upperBound
                }
            }
        }
    }
}

#Preview {
    SliderPreview()
}
