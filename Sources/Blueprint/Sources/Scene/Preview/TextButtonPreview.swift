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
    @State private var showTransparentChecker: Bool = false
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
                    Text("disable")
                    Control.switch(checked: disable) { disable = $0 }
                    Text("loading")
                    Control.switch(checked: loading) { loading = $0 }
                }
                HStack {
                    Text("leadingIcon")
                    Control.switch(checked: leadingIcon) { leadingIcon = $0 }
                    Text("trailingIcon")
                    Control.switch(checked: trailingIcon) { trailingIcon = $0 }
                }
                HStack {
                    Text("content color")
                    Control.switch(checked: contentColor) { contentColor = $0 }
                    Text("font variant")
                    Control.switch(checked: fontVariant) { fontVariant = $0 }
                    Text("font weight")
                    Control.switch(checked: fontWeight) { fontWeight = $0 }
                }
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension TextButton.Color: CaseDescribable {}
extension TextButton.Size: CaseDescribable {}

#Preview {
    TextButtonPreview()
}

