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
            .normal(size: 24),
            .background(size: 24, isAlternative: alternative),
            .outlined(size: sizes[sizeIndex]),
            .solid(size: sizes[sizeIndex])
        ]
    }
    
    private let sizes: [IconButton.Variant.Size] = [
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
                        disable: disable,
                        showPushBadge: showPushBadge,
                        padding: padding,
                        iconColor: iconColor,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor
                    ) {
                        print("tapped")
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
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                if isBackground {
                    HStack {
                        Text("alternative")
                        Control.Switch($alternative)
                    }
                }
                HStack {
                    Text("disable")
                    Control.Switch($disable)
                }
                if isNormal {
                    HStack {
                        Text("pushBadge")
                        Control.Switch($showPushBadge)
                    }
                }
                if isOutlinedOrSolid {
                    HStack {
                        Text("padding")
                        Slider(value: $padding, in: 0...24, step: 1)
                    }
                    HStack {
                        Text("backgroundColor")
                        Control.Switch(Binding(
                            get: { backgroundColor != nil },
                            set: { backgroundColor = $0 ? .semantic(.accentBackgroundCyan) : nil }
                        ))
                    }
                }
                if isOutlined {
                    HStack {
                        Text("borderColor")
                        Control.Switch(Binding(
                            get: { borderColor != nil },
                            set: { borderColor = $0 ? .semantic(.accentBackgroundPurple) : nil }
                        ))
                    }
                }
                HStack {
                    Text("iconColor")
                    Control.Switch(Binding(
                        get: { iconColor != nil },
                        set: { iconColor = $0 ? .semantic(.accentForegroundCyan) : nil }
                    ))
                }
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension IconButton.Variant: CaseDescribable {}
extension IconButton.Variant.Size: CaseDescribable {}

#Preview {
    IconButtonPreview()
}
