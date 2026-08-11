import SwiftUI
import Montage

struct ChipPreview: View {
    @State private var variant: Chip.Variant = .solid
    @State private var size: Chip.Size = .medium
    @State private var text = "텍스트"
    @State private var disable = false
    @State private var active = false
    @State private var backgroundColor: SwiftUI.Color = .clear
    @State private var fontColor: SwiftUI.Color = .clear
    @State private var activeColor: SwiftUI.Color = .clear
    @State private var borderColor: SwiftUI.Color = .clear
    @State private var leadingContent = false
    @State private var trailingContent = false
    @State private var iconColor: SwiftUI.Color = .semantic(.foregroundNeutralPrimary)

    /// 칩 사이즈별 시안 권장 슬롯 크기.
    ///
    /// `Chip`은 슬롯 뷰에 크기를 강제하지 않으므로 사용처인 프리뷰가 직접 지정한다.
    private var slotIconSize: CGFloat {
        switch size {
        case .large: return 16
        case .medium, .small: return 14
        case .xsmall: return 12
        }
    }

    private func slotIcon(_ icon: Icon) -> some View {
        Image.icon(icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: slotIconSize, height: slotIconSize)
            .foregroundStyle(iconColor)
    }

    var body: some View {
        PreviewLayout {
            Chip(
                variant: variant,
                size: size,
                text: text
            )
            .active(active)
            .modifying {
                if backgroundColor == .clear {
                    $0
                } else {
                    $0.backgroundColor(backgroundColor)
                }
            }
            .modifying {
                if fontColor == .clear {
                    $0
                } else {
                    $0.fontColor(fontColor)
                }
            }
            .modifying {
                if activeColor == .clear {
                    $0
                } else {
                    $0.activeColor(activeColor)
                }
            }
            .modifying {
                if borderColor == .clear {
                    $0
                } else {
                    $0.borderColor(borderColor)
                }
            }
            .modifying {
                if leadingContent {
                    $0.leadingContent { slotIcon(.bell) }
                } else {
                    $0
                }
            }
            .modifying {
                if trailingContent {
                    $0.trailingContent { slotIcon(.closeThick) }
                } else {
                    $0
                }
            }
            .disabled(disable)
        } options: {
            SegmentedIndexRow("Variant", index: Binding(
                get: { variant == .solid ? 0 : 1 },
                set: { variant = $0 == 0 ? .solid : .outlined }
            ), labels: ["Solid", "Outlined"])
            SegmentedIndexRow("Size", index: Binding(
                get: {
                    switch size {
                    case .xsmall: return 0
                    case .small: return 1
                    case .medium: return 2
                    case .large: return 3
                    }
                },
                set: {
                    switch $0 {
                    case 0: size = .xsmall
                    case 1: size = .small
                    case 2: size = .medium
                    case 3: size = .large
                    default: break
                    }
                }
            ), labels: ["XSmall", "Small", "Medium", "Large"])
            TextFieldOptionRow("Text", text: $text)
            HStack {
                ToggleOption("Disable", isOn: $disable)
                ToggleOption("Active", isOn: $active)
            }
            HStack {
                ToggleOption("Leading Content", isOn: $leadingContent)
                ToggleOption("Trailing Content", isOn: $trailingContent)
            }
            ColorPickerOptionRow("Background Color", selection: $backgroundColor)
            ColorPickerOptionRow("Font Color", selection: $fontColor)
            ColorPickerOptionRow("Active Color", selection: $activeColor)
            ColorPickerOptionRow("Slot Icon Color", selection: $iconColor)
            ColorPickerOptionRow("Border Color", selection: $borderColor)
        }
    }
}

#Preview {
    ChipPreview()
} 

