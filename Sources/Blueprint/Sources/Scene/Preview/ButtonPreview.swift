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
    @State private var showTransparentChecker: Bool = false
    @State private var variantIndex = 0
    @State private var colorIndex = 0
    @State private var sizeIndex = 0
    @State private var iconOnly = false
    @State private var leadingIcon = false
    @State private var trailingIcon = false
    @State private var disable = false
    @State private var contentColor = false
    @State private var backgroundColor = false
    @State private var borderColor = false
    @State private var fontVariant = false
    @State private var fontWeight = false
    @State private var loading = false
    
    private let variants: [Montage.Button.Variant] = [.solid, .outlined]
    private let colors: [Montage.Button.Color] = [.primary, .assistive]
    private let sizes: [Montage.Button.Size] = [.small, .medium, .large]
    
    var body: some View {
        SwiftUI.ScrollView {
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
                    }
                    
                    Spacer(minLength: 0)
                }
                
                Text("Options").bold()
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: variants.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("color")
                    SegmentedControl(
                        selectedIndex: $colorIndex,
                        labels: colors.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("iconOnly")
                    Control.switch(checked: iconOnly) { iconOnly = $0 }
                    Text("disable")
                    Control.switch(checked: disable) { disable = $0 }
                    Text("loading")
                    Control.switch(checked: loading) { loading = $0 }
                }
                if !iconOnly {
                    HStack {
                        Text("leadingIcon")
                        Control.switch(checked: leadingIcon) { leadingIcon = $0 }
                        Text("trailingIcon")
                        Control.switch(checked: trailingIcon) { trailingIcon = $0 }
                    }
                }
                Divider()
                Text("color")
                HStack {
                    Text("content")
                    Control.switch(checked: contentColor) { contentColor = $0 }
                    Text("background")
                    Control.switch(checked: backgroundColor) { backgroundColor = $0 }
                    Text("border")
                    Control.switch(checked: borderColor) { borderColor = $0 }
                }
                Divider()
                Text("font")
                HStack {
                    Text("variant")
                    Control.switch(checked: fontVariant) { fontVariant = $0 }
                    Text("weight")
                    Control.switch(checked: fontWeight) { fontWeight = $0 }
                }
            }
            .font(.caption)
            .padding()
        }
        .onChange(of: iconOnly) { _ in
            leadingIcon = false
            trailingIcon = false
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Montage.Button.Variant: CaseDescribable {}
extension Montage.Button.Color: CaseDescribable {}
extension Montage.Button.Size: CaseDescribable {}

#Preview {
    ButtonPreview()
}
