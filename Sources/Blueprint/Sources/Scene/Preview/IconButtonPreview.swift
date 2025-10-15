//
//  IconButtonPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 3/28/25.
//

import SwiftUI
import Montage

struct IconButtonPreview: View {
    @State private var variantIndex = 0
    @State private var customSize: CGFloat = 24
    @State private var sizeIndex = 0
    @State private var alternative = false
    @State private var disable = false
    @State private var showPushBadge = false
    @State private var padding: CGFloat = 0
    @State private var iconColor: SwiftUI.Color?
    @State private var backgroundColor: SwiftUI.Color?
    @State private var borderColor: SwiftUI.Color?
    
    private var variants: [IconButton.Variant] {
        [
            .normal(size: Int(customSize)),
            .background(size: Int(customSize), isAlternative: alternative),
            .outlined(size: sizes[sizeIndex]),
            .solid(size: sizes[sizeIndex])
        ]
    }
    
    private let sizes: [IconButton.Size] = [
        .small,
        .medium,
        .custom(size: 8)
    ]
    
    private var currentVariant: IconButton.Variant {
        variants[variantIndex]
    }
    
    private var isBackground: Bool {
        if case .background = currentVariant { return true }
        return false
    }
    
    private var isOutlinedOrSolid: Bool {
        if case .outlined = currentVariant { return true }
        if case .solid = currentVariant { return true }
        return false
    }
    
    private var isOutlined: Bool {
        if case .outlined = currentVariant { return true }
        return false
    }
    
    private var isNormal: Bool {
        if case .normal = currentVariant { return true }
        return false
    }
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                HStack {
                    Spacer(minLength: 0)
                    
                    IconButton(
                        variant: currentVariant,
                        icon: .apps,
                        handler: {
                            print("tapped")
                        }
                    )
                    .disable(disable)
                    .showPushBadge(isNormal ? showPushBadge : false)
                    .padding(isOutlinedOrSolid ? padding : 0)
                    .modifying {
                        if iconColor != nil {
                            $0.iconColor(iconColor!)
                        } else {
                            $0
                        }
                    }
                    .modifying {
                        if isOutlinedOrSolid && backgroundColor != nil {
                            $0.backgroundColor(backgroundColor!)
                        } else {
                            $0
                        }
                    }
                    .modifying {
                        if isOutlined && borderColor != nil {
                            $0.borderColor(borderColor!)
                        } else {
                            $0
                        }
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
                    Text("size")
                    if variantIndex == 0 || variantIndex == 1 {
                        SwiftUI.Slider(value: $customSize, in: 10...30, step: 1)
                    } else {
                        SegmentedControl(
                            selectedIndex: $sizeIndex,
                            labels: sizes.map(\.description)
                        )
                        .size(.small)
                    }
                }
                if isBackground {
                    HStack {
                        Text("alternative")
                        Control.switch(checked: alternative) { alternative = $0 }
                    }
                }
                HStack {
                    Text("disable")
                    Control.switch(checked: disable) { disable = $0 }
                }
                if isNormal {
                    HStack {
                        Text("pushBadge")
                        Control.switch(checked: showPushBadge) { showPushBadge = $0 }
                    }
                }
                if isOutlinedOrSolid {
                    HStack {
                        Text("padding")
                        Slider(value: $padding, in: 0...24, step: 1)
                    }
                    HStack {
                        Text("backgroundColor")
                        Control.switch(checked: backgroundColor != nil) {
                            backgroundColor = $0 ? .semantic(.accentBackgroundCyan) : nil
                        }
                    }
                }
                if isOutlined {
                    HStack {
                        Text("borderColor")
                        Control.switch(checked: borderColor != nil) {
                            borderColor = $0 ? .semantic(.accentBackgroundPurple) : nil
                        }
                    }
                }
                HStack {
                    Text("iconColor")
                    Control.switch(checked: iconColor != nil) {
                        iconColor = $0 ? .semantic(.accentForegroundCyan) : nil
                    }
                }
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension IconButton.Variant: CaseDescribable {}
extension IconButton.Size: CaseDescribable {}

#Preview {
    IconButtonPreview()
}
