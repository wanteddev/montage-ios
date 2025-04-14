//
//  HorizontalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct HorizontalProgressTrackerPreview: View {
    @State private var progress: Int = 1
    private let labels: [String] = ["처음이에요\n진짜", "중간이구요", "또\n중간", "끝입니다\n정말\n진짜로"]
    init() {}
    var body: some View {
        VStack(spacing: 20) {
            ProgressTracker.Horizontal(progress: $progress, labels: labels)
            
            ProgressTracker.Horizontal(progress: $progress, count: 4)
            
            Spacer(minLength: 0)
            HStack {
                SwiftUI.Button("Prev") { progress = max(1, progress - 1) }
                SwiftUI.Button("Next") { progress = min(progress + 1, labels.count + 1) }
            }
        }
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    HorizontalProgressTrackerPreview()
}
