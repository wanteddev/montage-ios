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

    /// step 수와 항상 동일한 길이의 라벨 배열. 부족하면 빈 문자열로 채워 모델 불일치를 막는다.
    private var displayLabels: [String] {
        let count = Int(stepCount)
        var result = Array(labels.prefix(count))
        if result.count < count {
            result.append(contentsOf: Array(repeating: "", count: count - result.count))
        }
        return result
    }

    var body: some View {
        PreviewLayout {
            ProgressTracker(
                progress: $progress,
                variant: .horizontal(labels: displayLabels))
        } options: {
            PrevNextOptionRow(value: $progress, in: 1...Int(stepCount))

            SliderOptionRow("stepCount", value: $stepCount, in: 2...10, step: 1)
                // stepCount가 바뀌면 labels·progress를 같은 지점에서 함께 정규화해 모델이 잠시도 어긋나지 않게 한다.
                .onChange(of: stepCount) {
                    let count = Int($0)
                    if labels.count < count {
                        labels.append(contentsOf: Array(repeating: "", count: count - labels.count))
                    }
                    if progress > count {
                        progress = count
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
        }
    }
}

#Preview {
    HorizontalProgressTrackerPreview()
}
