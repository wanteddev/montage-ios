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
    @State private var customSize: CGFloat = 36
    @State private var sizeIndex = 1 // 기본값 .medium
    @State private var normalSizeIndex = 3 // 기본값 .xlarge
    @State private var alternative = false
    @State private var disable = false
    @State private var disableInteraction = false
    @State private var showPushBadge = false
    @State private var padding: CGFloat = 0
    @State private var iconColor: SwiftUI.Color?
    @State private var backgroundColor: SwiftUI.Color?
    @State private var borderColor: SwiftUI.Color?
    @State private var interactionColor: Montage.Color.Semantic?

    private var variants: [IconButton.Variant] {
        [
            .normal(size: resolvedNormalSize),
            .background(size: Int(customSize), isAlternative: alternative),
            .outlined(size: resolvedSize),
            .solid(size: resolvedSize)
        ]
    }

    private let sizes: [IconButton.Size] = [
        .small,
        .medium
    ]
    private let sizeLabels: [String] = ["small", "medium", "custom"]

    private let normalSizes: [IconButton.NormalSize] = [.small, .medium, .large, .xlarge]
    private let normalSizeLabels: [String] = ["small", "medium", "large", "xlarge", "custom"]
    
    private var isCustomSize: Bool {
        switch variantIndex {
        case 0:
            normalSizeIndex == normalSizes.count
        case 1:
            true
        default:
            sizeIndex == sizes.count
        }
    }

    private var resolvedNormalSize: IconButton.NormalSize {
        if normalSizeIndex >= normalSizes.count {
            .custom(size: Int(customSize))
        } else {
            normalSizes[normalSizeIndex]
        }
    }

    private var resolvedSize: IconButton.Size {
        if sizeIndex >= sizes.count {
            .custom(size: Int(customSize))
        } else {
            sizes[sizeIndex]
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
        switch currentVariant {
        case .normal, .background:
            false
        case .outlined, .solid:
            true
        }
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
        PreviewLayout {
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
                .disableInteraction(disableInteraction)
                .showPushBadge(isNormal ? showPushBadge : false)
                .padding(isOutlinedOrSolid ? padding : 0)
                .modifying {
                    if let interactionColor {
                        $0.interactionColor(interactionColor)
                    } else {
                        $0
                    }
                }
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
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            if variantIndex == 0 {
                SegmentedIndexRow("size", index: $normalSizeIndex, labels: normalSizeLabels)
                if isCustomSize {
                    SliderOptionRow("custom", value: $customSize, in: 24...64)
                }
            } else if variantIndex == 1 {
                SliderOptionRow("size", value: $customSize, in: 24...64)
            } else {
                SegmentedIndexRow("size", index: $sizeIndex, labels: sizeLabels)
                if isCustomSize {
                    SliderOptionRow("custom", value: $customSize, in: 24...64)
                }
            }
            if isBackground {
                ToggleOptionRow("alternative", isOn: $alternative)
            }
            ToggleOptionRow("disable", isOn: $disable)
            ToggleOptionRow("disableInteraction", isOn: $disableInteraction)
            if isNormal {
                ToggleOptionRow("pushBadge", isOn: $showPushBadge)
            }
            if isOutlinedOrSolid {
                SliderOptionRow("padding", value: $padding, in: 0...24)
                ToggleOptionRow("backgroundColor", isOn: Binding(
                    get: { backgroundColor != nil },
                    set: { backgroundColor = $0 ? .semantic(.accentBackgroundCyan) : nil }
                ))
            }
            if isOutlined {
                ToggleOptionRow("borderColor", isOn: Binding(
                    get: { borderColor != nil },
                    set: { borderColor = $0 ? .semantic(.accentBackgroundPurple) : nil }
                ))
            }
            ToggleOptionRow("iconColor", isOn: Binding(
                get: { iconColor != nil },
                set: { iconColor = $0 ? .semantic(.accentForegroundCyan) : nil }
            ))
            ToggleOptionRow("interactionColor", isOn: Binding(
                get: { interactionColor != nil },
                set: { interactionColor = $0 ? .accentForegroundRed : nil }
            ))
        }
    }
}

extension IconButton.Variant: CaseDescribable {}
extension IconButton.NormalSize: CaseDescribable {}
extension IconButton.Size: CaseDescribable {}

#Preview {
    IconButtonPreview()
}
