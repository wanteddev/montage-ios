//
//  HorizontalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import Montage
import SwiftUI

struct HorizontalProgressTrackerPreview: View {
    @State private var progress: Int = 1
    @State private var stepCount: CGFloat = 4
    @State private var labels: [String] = ["1단계", "2단계", "3단계", "마지막\n단계"]

    init() {}

    var body: some View {
        PreviewLayout {
            ProgressTracker(
                progress: $progress,
                variant: .horizontal(labels: Array(labels.prefix(Int(stepCount)))))
        } options: {
            PrevNextOptionRow(value: $progress, in: 1...Int(stepCount))

            SliderOptionRow("stepCount", value: $stepCount, in: 2...10, step: 1)
                .onChange(of: stepCount) {
                    if progress > Int($0) {
                        progress = Int($0)
                    }
                }
            ForEach(0..<Int(stepCount), id: \.self) { index in
                TextAreaOptionRow("step\(index + 1) label", text: Binding<String>(
                    get: {
                        labels[safe: index] ?? ""
                    },
                    set: {
                        if index < labels.count {
                            labels[index] = $0
                        } else {
                            labels.append($0)
                        }
                    }
                ))
            }
            .onChange(of: stepCount) {
                if labels.count < Int($0) {
                    for _ in labels.count..<Int($0) {
                        labels.append("")
                    }
                }
            }
        }
    }
}

#Preview {
    HorizontalProgressTrackerPreview()
}
