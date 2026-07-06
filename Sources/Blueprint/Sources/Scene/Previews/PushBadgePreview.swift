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
        [.dot, .new, .number(Int(number))]
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

    @State var variantIndex = 0
    @State var number = 1.0
    @State var sizeIndex = 0
    @State var positionXIndex = 2
    @State var positionYIndex = 0
    @State var fontColor: SwiftUI.Color = .semantic(.staticWhite)
    @State var backgroundColor: SwiftUI.Color = .semantic(.primaryNormal)
    @State var inset = false

    var body: some View {
        PreviewLayout {
            Rectangle()
                .frame(width: 50, height: 50)
                .foregroundStyle(SwiftUI.Color.semantic(.accentBackgroundViolet))
                .opacity(0.3)
                .pushBadge(
                    variant: variants[variantIndex],
                    size: sizes[sizeIndex],
                    fontColor: fontColor,
                    backgroundColor: backgroundColor,
                    position: positionYs[positionYIndex],
                    inset: inset ? .init(width: 20, height: 20) : .zero
                )
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            if case .number = variants[variantIndex] {
                SliderOptionRow("number", value: $number, in: 1...110, step: 1)
            }
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            ColorPickerOptionRow("fontColor", selection: $fontColor)
            ColorPickerOptionRow("backgroundColor", selection: $backgroundColor)
            Divider()
            Text("position")
            SegmentedIndexRow("horizontal", index: $positionXIndex, labels: horizontalPositions.map(\.description))
            SegmentedIndexRow("vertical", index: $positionYIndex, labels: positionYs.map(\.description))
            Divider()
            ToggleOptionRow("inset(20,20)", isOn: $inset)
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
