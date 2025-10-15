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
    
    private let colors: [Montage.Button.Color] = [.primary, .assistive]
    private let sizes: [Montage.Button.Size] = [.small, .medium, .large]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                Grid {
                    let color = colors[colorIndex]
                    let size = sizes[sizeIndex]
                    
                    if let solidColor = Button.Color(rawValue: color.description),
                       let solidSize = Button.Size(rawValue: size.description) {
                        GridRow {
                            Spacer(minLength: 0)
                            
                            Text("SolidButton")
                            if iconOnly {
                                Button(
                                    color: solidColor,
                                    size: solidSize,
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
                                    color: solidColor,
                                    size: solidSize,
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
                    }
                    
                    if let outlinedColor = Button.Color(rawValue: color.description),
                       let outlinedSize = Button.Size(rawValue: size.description) {
                        GridRow {
                            Spacer(minLength: 0)
                            
                            Text("OutlinedButton")
                            if iconOnly {
                                Button(
                                    variant: .outlined,
                                    color: outlinedColor,
                                    size: outlinedSize,
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
                                    variant: .outlined,
                                    color: outlinedColor,
                                    size: outlinedSize,
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
                    }
                    
                }
                
                Text("Options").bold()
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
                    Switch($iconOnly)
                    Text("disable")
                    Switch($disable)
                    Text("loading")
                    Switch($loading)
                }
                if !iconOnly {
                    HStack {
                        Text("leadingIcon")
                        Switch($leadingIcon)
                        Text("trailingIcon")
                        Switch($trailingIcon)
                    }
                }
                Divider()
                Text("color")
                HStack {
                    Text("content")
                    Switch($contentColor)
                    Text("background")
                    Switch($backgroundColor)
                    Text("border")
                    Switch($borderColor)
                }
                Divider()
                Text("font")
                HStack {
                    Text("variant")
                    Switch($fontVariant)
                    Text("weight")
                    Switch($fontWeight)
                }
            }
            .font(.caption)
            .padding()
        }
        .onChange(of: iconOnly) { _ in
            leadingIcon = false
            trailingIcon = false
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Montage.Button.Color: CaseDescribable {}
extension Montage.Button.Size: CaseDescribable {}

#Preview {
    ButtonPreview()
}
