//
//  AvatarPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import Montage
import SwiftUI

struct AvatarPreview: View {
    @State private var showTransparentChecker: Bool = false
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
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Preview").bold()
                        Spacer()
                        Button(action: {
                            showTransparentChecker.toggle()
                        }) {
                            Image(systemName: "checkerboard.rectangle")
                                .foregroundColor(.semantic(.primaryNormal))
                        }
                    }
                    HStack {
                        Spacer()
                        avatar
                        Spacer()
                    }

                    Text("Options").bold()
                    HStack {
                        Text("variant")
                        SegmentedControl(
                            selectedIndex: $variantIndex, labels: variants.map(\.description)
                        )
                        .size(.small)
                    }
                    if variants[variantIndex] == .person {
                        HStack {
                            Text("pushBadge")
                            Switch(checked: pushBadge) { pushBadge = $0 }
                        }
                        if pushBadge {
                            HStack {
                                Text("pushBadge size")
                                SegmentedControl(
                                    selectedIndex: $pushBadgeSizeIndex,
                                    labels: pushBadgeSizeLabels
                                )
                                .size(.small)
                            }
                        }
                    }
                    HStack {
                        Text("size")
                        SegmentedControl(
                            selectedIndex: $sizeIndex, labels: sizes.map(\.description)
                        )
                        .size(.small)
                    }
                    .opacity(useCustomSize ? 0.3 : 1)
                    .disabled(useCustomSize)
                    HStack {
                        Text("custom size")
                        Switch(checked: useCustomSize) { useCustomSize = $0 }
                    }
                    if useCustomSize {
                        HStack {
                            Text("\(Int(customSize))pt")
                                .monospacedDigit()
                            SwiftUI.Slider(value: $customSize, in: 16...120, step: 1)
                        }
                    }
                    if variants[variantIndex] != .person {
                        HStack {
                            Text("cornerRadius")
                            Switch(checked: useCustomCornerRadius) { useCustomCornerRadius = $0 }
                        }
                        if useCustomCornerRadius {
                            HStack {
                                Text("\(Int(customCornerRadius))pt")
                                    .monospacedDigit()
                                SwiftUI.Slider(value: $customCornerRadius, in: 0...60, step: 1)
                            }
                        }
                    }
                    HStack {
                        Text("contentMode")
                        SegmentedControl(
                            selectedIndex: $contentModeIndex, labels: ["fit", "fill"]
                        )
                        .size(.small)
                    }
                    HStack {
                        Text("local image")
                        Switch(checked: useLocalImage) { useLocalImage = $0 }
                    }
                    if !useLocalImage {
                        HStack {
                            Text("invalid image url")
                            Switch(checked: invalidUrl) { invalidUrl = $0 }
                        }
                    }
                    HStack {
                        SwiftUI.ColorPicker("borderColor", selection: $borderColor)
                        Text("borderWidth")
                        SwiftUI.Slider(value: $borderWidth, in: 0...5)
                    }
                }
                .font(.caption)
                .padding(.horizontal)
            }
            .hidesIndicators()
        }
        .transparentChecking(
            isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red
        )
        .background(SwiftUI.Color.semantic(.backgroundNormal))
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
