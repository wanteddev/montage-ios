//
//  FramedStylePreview.swift
//  Montage
//
//  Created by 김삼열 on 8/22/25.
//

import SwiftUI
import Montage

struct FramedStylePreview: View {
    @State private var statusIndex: Int = 0
    @State private var borderRadius: CGFloat = 0
    @State private var shadowIndex: Int = 0
    @State private var disabled: Bool = false

    var body: some View {
        PreviewLayout {
            ZStack {
                Rectangle()
                    .foregroundColor(.semantic(.backgroundNormalAlternative))
                    .frame(height: 80)
                Text("Preview")
            }
            .framedStyle(
                status: FramedStyle.Status.allCases[statusIndex],
                borderRadius: borderRadius,
                shadowLevel: Shadow.Level.allCases[shadowIndex],
                disabled: disabled
            )
        } options: {
            SegmentedIndexRow("status", index: $statusIndex, labels: FramedStyle.Status.allCases.map(\.description))
            SliderOptionRow("borderRadius", value: $borderRadius, in: 0...20, step: 1)
            SegmentedIndexRow("shadow", index: $shadowIndex, labels: Shadow.Level.allCases.map(\.description))
            ToggleOptionRow("disabled", isOn: $disabled)
        }
    }
}

extension FramedStyle.Status: CaseDescribable {}

#Preview {
    FramedStylePreview()
}
