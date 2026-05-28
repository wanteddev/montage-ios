//
//  IconButtonPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 3/28/25.
//

import SwiftUI
import Montage

struct IconButtonPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var variantIndex = 0
    @State private var customSize: CGFloat = 20
    @State private var sizeIndex = 0
    @State private var normalSizeIndex = 3 // 기본값 24 (.xlarge)
    @State private var alternative = false
    @State private var disable = false
    @State private var showPushBadge = false
    @State private var padding: CGFloat = 0
    @State private var iconColor: SwiftUI.Color?
    @State private var backgroundColor: SwiftUI.Color?
    @State private var borderColor: SwiftUI.Color?
    @State private var showDebugFrame = false

    private var variants: [IconButton.Variant] {
        [
            .normal(size: resolvedNormalSize),
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

    private let normalSizes: [IconButton.NormalSize] = [.small, .medium, .large, .xlarge]
    private let normalSizeLabels: [String] = ["small", "medium", "large", "xlarge", "custom"]

    private var isNormalCustomSize: Bool {
        normalSizeIndex == normalSizes.count
    }

    private var resolvedNormalSize: IconButton.NormalSize {
        if isNormalCustomSize {
            .custom(size: Int(customSize))
        } else {
            normalSizes[normalSizeIndex]
        }
    }
    
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
                    .overlay {
                        if showDebugFrame {
                            Rectangle()
                                .stroke(SwiftUI.Color.red.opacity(0.6), lineWidth: 1)
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
                if variantIndex == 0 {
                    HStack {
                        Text("size")
                        SegmentedControl(
                            selectedIndex: $normalSizeIndex,
                            labels: normalSizeLabels
                        )
                        .size(.small)
                    }
                    if isNormalCustomSize {
                        HStack {
                            Text("custom")
                            SwiftUI.Slider(value: $customSize, in: 10...128, step: 1)
                            Text("\(Int(customSize))")
                        }
                    }
                } else if variantIndex == 1 {
                    HStack {
                        Text("size")
                        SwiftUI.Slider(value: $customSize, in: 10...128, step: 1)
                        Text("\(Int(customSize))")
                    }
                } else {
                    HStack {
                        Text("size")
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
                        Switch(checked: alternative) { alternative = $0 }
                    }
                }
                HStack {
                    Text("disable")
                    Switch(checked: disable) { disable = $0 }
                }
                if isNormal {
                    HStack {
                        Text("pushBadge")
                        Switch(checked: showPushBadge) { showPushBadge = $0 }
                    }
                }
                if isOutlinedOrSolid {
                    HStack {
                        Text("padding")
                        Slider(value: $padding, in: 0...24, step: 1)
                    }
                    HStack {
                        Text("backgroundColor")
                        Switch(checked: backgroundColor != nil) {
                            backgroundColor = $0 ? .semantic(.accentBackgroundCyan) : nil
                        }
                    }
                }
                if isOutlined {
                    HStack {
                        Text("borderColor")
                        Switch(checked: borderColor != nil) {
                            borderColor = $0 ? .semantic(.accentBackgroundPurple) : nil
                        }
                    }
                }
                HStack {
                    Text("iconColor")
                    Switch(checked: iconColor != nil) {
                        iconColor = $0 ? .semantic(.accentForegroundCyan) : nil
                    }
                }
                HStack {
                    Text("debug frame")
                    Switch(checked: showDebugFrame) { showDebugFrame = $0 }
                }
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension IconButton.Variant: CaseDescribable {}
extension IconButton.Size: CaseDescribable {}

#Preview {
    IconButtonPreview()
}
