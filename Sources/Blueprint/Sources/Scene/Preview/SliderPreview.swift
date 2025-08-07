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
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                if variantIndex == 0 {
                    Slider(minValue: CGFloat(lowerBound), maxValue: CGFloat(upperBound), labelFormatter: { value in
                        "\(Int(value.rounded()))\(unit)"
                    })
                    .heading(heading)
                    .label(label)
                    .disable(disable)
                } else {
                    Slider(.range, minValue: CGFloat(lowerBound), maxValue: CGFloat(upperBound), labelFormatter: { value in
                        "\(Int(value.rounded()))\(unit)"
                    })
                    .heading(heading)
                    .label(label)
                    .disable(disable)
                }
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                Text("Options").bold()
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
                HStack {
                    Text("unit")
                    TextField(text: $unit)
                }
                HStack {
                    Text("variant")
                    SegmentedControl(selectedIndex: $variantIndex, labels: ["single", "double"])
                        .size(.small)
                }
                HStack {
                    Text("heading")
                    Switch($heading)
                }
                HStack {
                    Text("label")
                    Switch($label)
                }
                HStack {
                    Text("disable")
                    Switch($disable)
                }
            }
            .padding(.horizontal)
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
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    SliderPreview()
}
