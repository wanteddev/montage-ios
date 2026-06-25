//
//  ButtonPreview.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/04/06.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//
//

import SwiftUI

import Montage

struct ButtonPreview: View {
    @State private var variantIndex = 0
    @State private var colorIndex = 0
    @State private var sizeIndex = 0
    @State private var iconOnly = false
    @State private var leadingIcon = false
    @State private var trailingIcon = false
    @State private var fillWidth = false
    @State private var disable = false
    @State private var contentColor = false
    @State private var backgroundColor = false
    @State private var borderColor = false
    @State private var fontVariant = false
    @State private var fontWeight = false
    @State private var loading = false

    private let variants: [Montage.Button.Variant] = [.solid, .outlined]
    private let colors: [Montage.Button.Color] = [.primary, .assistive, .negative]
    private let sizes: [Montage.Button.Size] = [.xsmall, .small, .medium, .large]

    var body: some View {
        PreviewLayout {
            let color = colors[colorIndex]
            let size = sizes[sizeIndex]

            HStack {
                Spacer(minLength: 0)
                if iconOnly {
                    Button(
                        variant: variants[variantIndex],
                        color: color,
                        size: size,
                        icon: .apps
                    ) {
                        print("tapped")
                    }
                    .disable(disable)
                    .contentColor(contentColor ? .semantic(.accentForegroundCyan) : nil)
                    .backgroundColor(backgroundColor ? .semantic(.accentBackgroundCyan) : nil)
                    .borderColor(borderColor ? .semantic(.accentBackgroundPurple) : nil)
                    .fontVariant(fontVariant ? .heading1 : nil)
                    .fontWeight(fontWeight ? .regular : nil)
                    .loading(loading)
                } else {
                    VStack {
                        Button(
                            variant: variants[variantIndex],
                            color: color,
                            size: size,
                            text: "텍스트",
                            leadingIcon: leadingIcon ? .apps : nil,
                            trailingIcon: trailingIcon ? .apps : nil
                        ) {
                            print("tapped")
                        }
                        .disable(disable)
                        .contentColor(contentColor ? .semantic(.accentForegroundCyan) : nil)
                        .backgroundColor(backgroundColor ? .semantic(.accentBackgroundCyan) : nil)
                        .borderColor(borderColor ? .semantic(.accentBackgroundPurple) : nil)
                        .fontVariant(fontVariant ? .heading1 : nil)
                        .fontWeight(fontWeight ? .regular : nil)
                        .loading(loading)
                        .fillWidth(fillWidth)
                        Button(
                            variant: variants[variantIndex],
                            color: color,
                            size: size,
                            text: "매우 긴~~~~~~~~~~~~~~~~~~~~~~~~~~~~~텍스트입니다",
                            leadingIcon: leadingIcon ? .apps : nil,
                            trailingIcon: trailingIcon ? .apps : nil
                        ) {
                            print("tapped")
                        }
                        .disable(disable)
                        .contentColor(contentColor ? .semantic(.accentForegroundCyan) : nil)
                        .backgroundColor(backgroundColor ? .semantic(.accentBackgroundCyan) : nil)
                        .borderColor(borderColor ? .semantic(.accentBackgroundPurple) : nil)
                        .fontVariant(fontVariant ? .heading1 : nil)
                        .fontWeight(fontWeight ? .regular : nil)
                        .loading(loading)
                        .fillWidth(fillWidth)
                    }
                }

                Spacer(minLength: 0)
            }
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("color", index: $colorIndex, labels: colors.map(\.description))
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            HStack {
                ToggleOption("iconOnly", isOn: $iconOnly)
                ToggleOption("disable", isOn: $disable)
                ToggleOption("loading", isOn: $loading)
            }
            HStack {
                if !iconOnly {
                    ToggleOption("leadingIcon", isOn: $leadingIcon)
                    ToggleOption("trailingIcon", isOn: $trailingIcon)
                }
                ToggleOption("fillWidth", isOn: $fillWidth)
            }
            Divider()
            Text("color")
            HStack {
                ToggleOption("content", isOn: $contentColor)
                ToggleOption("background", isOn: $backgroundColor)
                if variants[variantIndex] == .outlined && colors[colorIndex] != .negative {
                    ToggleOption("border", isOn: $borderColor)
                }
            }
            Divider()
            Text("font")
            HStack {
                ToggleOption("variant", isOn: $fontVariant)
                ToggleOption("weight", isOn: $fontWeight)
            }
        }
        .onChange(of: iconOnly) { _ in
            leadingIcon = false
            trailingIcon = false
        }
        .onChange(of: variantIndex) { _ in
            borderColor = false
        }
        .onChange(of: colorIndex) { _ in
            if variants[variantIndex] == .outlined && colors[colorIndex] == .negative {
                borderColor = false
            }
        }
    }
}

extension Montage.Button.Variant: CaseDescribable {}
extension Montage.Button.Color: CaseDescribable {}
extension Montage.Button.Size: CaseDescribable {}

#Preview {
    ButtonPreview()
}
