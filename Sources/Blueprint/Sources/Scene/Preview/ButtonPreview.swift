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
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                Grid {
                    let variant = Button.Variant.allCases[variantIndex]
                    let size = Button.Size.allCases[sizeIndex]
                    
                    if let solidVariant = Button.Solid.Variant(rawValue: variant.rawValue),
                       let solidSize = Button.Solid.Size(rawValue: size.rawValue) {
                        GridRow {
                            Spacer(minLength: 0)
                            
                            Text("SolidButton")
                            if iconOnly {
                                Button.solid(
                                    variant: solidVariant,
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
                                Button.solid(
                                    variant: solidVariant,
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
                    
                    if let outlinedVariant = Button.Outlined.Variant(rawValue: variant.rawValue),
                       let outlinedSize = Button.Outlined.Size(rawValue: size.rawValue) {
                        GridRow {
                            Spacer(minLength: 0)
                            
                            Text("OutlinedButton")
                            if iconOnly {
                                Button.outlined(
                                    variant: outlinedVariant,
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
                                Button.outlined(
                                    variant: outlinedVariant,
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
                    
                    if let textVariant = Button.Text.Variant(rawValue: variant.rawValue),
                       let textSize = Button.Text.Size(rawValue: size.rawValue) {
                        GridRow {
                            Spacer(minLength: 0)
                            
                            Text("TextButton")
                            Button.text(
                                variant: textVariant,
                                size: textSize,
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
                            .padding(.vertical, 4)
                            
                            Spacer(minLength: 0)
                        }
                    }
                }
                
                Text("Options").bold()
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: Button.Variant.allCases.map(\.rawValue)
                    )
                    .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: Button.Size.allCases.map(\.rawValue)
                    )
                    .size(.small)
                }
                HStack {
                    Text("iconOnly")
                    Control.Switch($iconOnly)
                    Text("disable")
                    Control.Switch($disable)
                    Text("loading")
                    Control.Switch($loading)
                }
                if !iconOnly {
                    HStack {
                        Text("leadingIcon")
                        Control.Switch($leadingIcon)
                        Text("trailingIcon")
                        Control.Switch($trailingIcon)
                    }
                }
                Divider()
                Text("color")
                HStack {
                    Text("content")
                    Control.Switch($contentColor)
                    Text("background")
                    Control.Switch($backgroundColor)
                    Text("border")
                    Control.Switch($borderColor)
                }
                Divider()
                Text("font")
                HStack {
                    Text("variant")
                    Control.Switch($fontVariant)
                    Text("weight")
                    Control.Switch($fontWeight)
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

#Preview {
    ButtonPreview()
}
