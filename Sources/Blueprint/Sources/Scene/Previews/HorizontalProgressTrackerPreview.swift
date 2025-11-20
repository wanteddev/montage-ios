//
//  HorizontalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct HorizontalProgressTrackerPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var progress: Int = 1
    @State private var stepCount: CGFloat = 4
    @State private var labels: [String] = ["처음이에요\n진짜", "중간이구요", "또\n중간", "끝입니다\n정말\n진짜로"]
    
    init() {}
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                
                ProgressTracker(progress: $progress, variant: .horizontal(labels: Array(labels.prefix(Int(stepCount)))))
				
                Text("Options").bold()
                
                HStack {
                    Spacer()
                    Button(variant: .outlined, size: .small, text: "Previous") {
                        progress = max(1, progress - 1)
                    }
                    .disable(progress <= 1)
                    
                    Button(variant: .outlined, size: .small, text: "Next") {
                        progress = min(progress + 1, Int(stepCount))
                    }
                    .disable(progress >= Int(stepCount))
                    Spacer()
                }
                
                HStack {
                    Text("stepCount")
                    SwiftUI.Slider(value: $stepCount, in: 2...10, step: 1)
                    Text("\(Int(stepCount))")
                        .frame(width: 30)
                }
                ForEach(0..<Int(stepCount), id: \.self) { index in
                    HStack {
                        Text("step\(index + 1) label")
                        TextArea(text: Binding<String>(get: {
                            labels[safe: index] ?? ""
                        }, set: {
                            labels[index] = $0
                        }))
                    }
                }
                .onChange(of: stepCount) {
                    if labels.count < Int($0) {
                        for _ in labels.count..<Int($0) {
                            labels.append("")
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    HorizontalProgressTrackerPreview()
}
