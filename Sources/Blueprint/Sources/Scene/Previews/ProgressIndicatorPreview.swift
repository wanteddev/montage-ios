//
//  ProgressIndicatorPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/19/24.
//

import SwiftUI
import Montage

struct ProgressIndicatorPreview: View {
    @State private var percentage: CGFloat = 0

    var body: some View {
        PreviewLayout {
            ProgressIndicator(percentage: $percentage)
        } options: {
            SliderOptionRow("Percentage", value: $percentage, in: 0...1, step: 0.01, format: { String(format: "%.1f%%", Double($0) * 100) })
        }
    }
}

#Preview {
    ProgressIndicatorPreview()
}
