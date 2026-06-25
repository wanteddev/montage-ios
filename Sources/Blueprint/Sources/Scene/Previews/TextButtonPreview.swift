//
//  TextButtonPreview.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/04/06.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//
//

import SwiftUI

import Montage

struct TextButtonPreview: View {
    @State private var colorIndex = 0
    @State private var sizeIndex = 0
    @State private var leadingIcon = false
    @State private var trailingIcon = false
    @State private var disable = false
    @State private var contentColor = false
    @State private var backgroundColor = false
    @State private var borderColor = false
    @State private var fontVariant = false
    @State private var fontWeight = false
    @State private var loading = false

    private let colors: [TextButton.Color] = [.primary, .assistive]
    private let sizes: [TextButton.Size] = [.small, .medium]

    var body: some View {
        PreviewLayout {
            let color = colors[colorIndex]
            let size = sizes[sizeIndex]
            HStack {
                Spacer()
                TextButton(
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
                .fontVariant(fontVariant ? .heading1 : nil)
                .fontWeight(fontWeight ? .regular : nil)
                .loading(loading)
                .padding(.vertical, 4)
                Spacer()
            }
        } options: {
            SegmentedIndexRow("color", index: $colorIndex, labels: colors.map(\.description))
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            HStack {
                ToggleOption("disable", isOn: $disable)
                ToggleOption("loading", isOn: $loading)
            }
            HStack {
                ToggleOption("leadingIcon", isOn: $leadingIcon)
                ToggleOption("trailingIcon", isOn: $trailingIcon)
            }
            HStack {
                ToggleOption("content color", isOn: $contentColor)
                ToggleOption("font variant", isOn: $fontVariant)
                ToggleOption("font weight", isOn: $fontWeight)
            }
        }
    }
}

extension TextButton.Color: CaseDescribable {}
extension TextButton.Size: CaseDescribable {}

#Preview {
    TextButtonPreview()
}

