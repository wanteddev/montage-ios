//
//  PushBadgePreview.swift
//  Blueprint
//
//  Created by 김삼열 on 3/24/25.
//

import SwiftUI
import Montage

struct PushBadgePreview: View {
    var variants: [PushBadge.Variant] {
        [.dot, .text("N"), .maxCount(Int(number))]
    }

    var positionYs: [PushBadge.Position] {
        let horizontalPosition = horizontalPositions[positionXIndex]
        return [.top(horizontalPosition), .center(horizontalPosition), .bottom(horizontalPosition)]
    }

    private let sizes: [PushBadge.Size] = [
        .xsmall, .small, .medium
    ]

    private let horizontalPositions: [PushBadge.Position.HorizontalPosition] = [
        .leading, .center, .trailing
    ]

    @State private var variantIndex = 0
    @State private var number = 1.0
    @State private var sizeIndex = 0
    @State private var positionXIndex = 2
    @State private var positionYIndex = 0
    @State private var fontColor: SwiftUI.Color = .semantic(.staticWhite)
    @State private var backgroundColor: SwiftUI.Color = .semantic(.surfaceBrandPrimary)
    @State private var ringBg = false
    @State private var ringBgColor: SwiftUI.Color = .semantic(.backgroundNeutralPrimary)
    @State private var insetX: CGFloat = 0
    @State private var insetY: CGFloat = 0

    var body: some View {
        PreviewLayout {
            Rectangle()
                .frame(width: 50, height: 50)
                .foregroundStyle(SwiftUI.Color.semantic(.surfaceAccentVioletOpaque))
                .opacity(0.3)
                .pushBadge(
                    variant: variants[variantIndex],
                    size: sizes[sizeIndex],
                    fontColor: fontColor,
                    backgroundColor: backgroundColor,
                    ringBg: ringBg,
                    ringBgColor: ringBgColor,
                    position: positionYs[positionYIndex],
                    inset: .init(width: insetX, height: insetY)
                )
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            if case .maxCount = variants[variantIndex] {
                SliderOptionRow("count", value: $number, in: 1...110, step: 1)
            }
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            ColorPickerOptionRow("fontColor", selection: $fontColor)
            ColorPickerOptionRow("backgroundColor", selection: $backgroundColor)
            Divider()
            ToggleOptionRow("ringBg", isOn: $ringBg)
            if ringBg {
                ColorPickerOptionRow("ringBgColor", selection: $ringBgColor)
            }
            Divider()
            Text("position")
            SegmentedIndexRow("horizontal", index: $positionXIndex, labels: horizontalPositions.map(\.description))
            SegmentedIndexRow("vertical", index: $positionYIndex, labels: positionYs.map(\.description))
            Divider()
            Text("inset")
            SliderOptionRow("inset x", value: $insetX, in: 0...20, step: 1)
            SliderOptionRow("inset y", value: $insetY, in: 0...20, step: 1)
        }
    }
}

extension PushBadge.Variant: CaseDescribable {}
extension PushBadge.Size: CaseDescribable {}
extension PushBadge.Position: CaseDescribable {}
extension PushBadge.Position.HorizontalPosition: CaseDescribable {}

#Preview {
    PushBadgePreview()
}
