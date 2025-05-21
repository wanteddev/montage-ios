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
        ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                HStack {
                    Spacer()
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
                    Spacer()
                }
                Text("Options").bold()
                HStack {
                    Text("variant")
                    SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                        .size(.small)
                }
                if case .number = variants[variantIndex] {
                    Text("number")
                    SwiftUI.Slider(value: $number, in: 1...1000) { isEditing in
                        if !isEditing {
                            number = Double(Int(number))
                        }
                    }
                }
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                SwiftUI.ColorPicker("fontColor", selection: $fontColor)
                SwiftUI.ColorPicker("backgroundColor", selection: $backgroundColor)
                Divider()
                Text("position")
                HStack {
                    Text("horizontal")
                    SegmentedControl(
                        selectedIndex: $positionXIndex,
                        labels: horizontalPositions.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("vertical")
                    SegmentedControl(
                        selectedIndex: $positionYIndex,
                        labels: positionYs.map(\.description)
                    )
                    .size(.small)
                }
                Divider()
                HStack {
                    Text("inset(20,20)")
                    Control.Switch($inset)
                }
            }
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension PushBadge.Variant: CaseDescribable {}
extension PushBadge.Size: CaseDescribable {}
extension PushBadge.Position: CaseDescribable {}
extension PushBadge.Position.HorizontalPosition: CaseDescribable {}

#Preview {
    PushBadgePreview()
}
