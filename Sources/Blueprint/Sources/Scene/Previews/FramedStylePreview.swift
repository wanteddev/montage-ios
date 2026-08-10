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
            // 콘텐츠를 Button으로 두면 disabled가 프레임 테두리뿐 아니라 내부 콘텐츠까지
            // 전달되는지 함께 확인할 수 있다. (Text는 `disabled(_:)`에 시각적으로 반응하지 않는다)
            ZStack {
                Rectangle()
                    .foregroundColor(.semantic(.backgroundNeutralSecondary))
                    .frame(height: 80)
                Montage.Button(size: .small, text: "Preview") {
                    print("tapped")
                }
            }
            .framedStyle(
                status: FramedStyle.Status.allCases[statusIndex],
                borderRadius: borderRadius,
                shadowLevel: Shadow.Level.allCases[shadowIndex]
            )
            .disabled(disabled)
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
