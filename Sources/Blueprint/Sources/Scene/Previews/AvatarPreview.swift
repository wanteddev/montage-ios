//
//  AvatarPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import Montage
import SwiftUI

struct AvatarPreview: View {
    @State private var variantIndex: Int = 0
    @State private var sizeIndex: Int = 0
    @State private var useCustomSize: Bool = false
    @State private var customSize: CGFloat = 40
    @State private var pushBadge = false
    @State private var pushBadgeSizeIndex: Int = 0
    @State private var useCustomCornerRadius: Bool = false
    @State private var customCornerRadius: CGFloat = 10
    @State private var borderColor: SwiftUI.Color = .semantic(.lineAlternative)
    @State private var borderWidth: CGFloat = 1
    @State private var contentModeIndex: Int = 0
    @State private var useLocalImage: Bool = false
    @State private var invalidUrl: Bool = false

    let contentModes: [ContentMode] = [.fit, .fill]
    let pushBadgeSizes: [PushBadge.Size?] = [nil, .xsmall, .small, .medium]
    let pushBadgeSizeLabels = ["auto", "xsmall", "small", "medium"]

    let variants: [Avatar.Variant] = [.person, .company, .academy]
    let sizes: [Avatar.Size] = [.xsmall, .small, .medium, .large, .xlarge]

    var body: some View {
        PreviewLayout {
            HStack {
                Spacer()
                avatar
                Spacer()
            }
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            if variants[variantIndex] == .person {
                ToggleOptionRow("pushBadge", isOn: $pushBadge)
                if pushBadge {
                    SegmentedIndexRow("pushBadge size", index: $pushBadgeSizeIndex, labels: pushBadgeSizeLabels)
                }
            }
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
                .opacity(useCustomSize ? 0.3 : 1)
                .disabled(useCustomSize)
            ToggleOptionRow("custom size", isOn: $useCustomSize)
            if useCustomSize {
                SliderOptionRow("customSize", value: $customSize, in: 16...120, step: 1)
            }
            if variants[variantIndex] != .person {
                ToggleOptionRow("cornerRadius", isOn: $useCustomCornerRadius)
                if useCustomCornerRadius {
                    SliderOptionRow("cornerRadius", value: $customCornerRadius, in: 0...60, step: 1)
                }
            }
            SegmentedIndexRow("contentMode", index: $contentModeIndex, labels: ["fit", "fill"])
            ToggleOptionRow("local image", isOn: $useLocalImage)
            if !useLocalImage {
                ToggleOptionRow("invalid image url", isOn: $invalidUrl)
            }
            HStack {
                SwiftUI.ColorPicker("borderColor", selection: $borderColor)
                Text("borderWidth")
                SwiftUI.Slider(value: $borderWidth, in: 0...5)
            }
        }
    }
}

extension AvatarPreview {
    private var selectedSize: Avatar.Size {
        useCustomSize ? .custom(customSize) : sizes[sizeIndex]
    }

    @ViewBuilder
    private var avatar: some View {
        let base: Avatar = if useLocalImage {
            Avatar(
                Image("portrait", bundle: .main),
                variant: variants[variantIndex],
                size: selectedSize
            )
        } else {
            Avatar(
                invalidUrl
                    ? "https://invalid-url"
                    : "https://png.pngtree.com/background/20250608/original/pngtree-beautiful-korean-woman-posing-for-high-quality-photograph-picture-image_16640418.jpg",
                variant: variants[variantIndex],
                size: selectedSize
            )
        }
        base
            .contentMode(contentModes[contentModeIndex])
            .pushBadge(pushBadge, size: pushBadgeSizes[pushBadgeSizeIndex])
            .border(color: borderColor, width: borderWidth)
            .if(useCustomCornerRadius) { $0.cornerRadius(customCornerRadius) }
    }
}

extension Avatar.Variant: CaseDescribable {}
extension Avatar.Size: CaseDescribable {}

#Preview {
    AvatarPreview()
}
