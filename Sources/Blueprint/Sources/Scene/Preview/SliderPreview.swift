//
//  SliderPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct SliderPreview: View {
    @State private var heading = true
    @State private var label = true
    @State private var disable = false
    @State private var lowerBound: Int = 0
    @State private var upperBound: Int = 10
    @State private var unit = "km"
    @State private var range: ClosedRange<CGFloat> = 0...10
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                Slider(range: range) { value in
                    "\(Int(value.rounded()))\(unit)"
                }
                .heading(heading)
                .label(label)
                .disable(disable)
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
                    TextInput.TextField(text: $unit)
                }
                HStack {
                    Text("heading")
                    Control.Switch($heading)
                }
                HStack {
                    Text("label")
                    Control.Switch($label)
                }
                HStack {
                    Text("disable")
                    Control.Switch($disable)
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: lowerBound) { _ in
            Task {
                if lowerBound > upperBound {
                    upperBound = lowerBound
                }
                range = CGFloat(lowerBound)...CGFloat(upperBound)
            }
        }
        .onChange(of: upperBound) { _ in
            Task {
                if lowerBound > upperBound {
                    lowerBound = upperBound
                }
                range = CGFloat(lowerBound)...CGFloat(upperBound)
            }
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    SliderPreview()
}
