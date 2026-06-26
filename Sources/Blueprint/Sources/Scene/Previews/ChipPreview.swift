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
    @State private var leadingImage = false
    @State private var trailingImage = false
    @State private var imageColor: SwiftUI.Color = .clear

    var body: some View {
        PreviewLayout {
            Chip(
                variant: variant,
                size: size,
                text: text
            )
            .active(active)
            .disabled(disable)
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
                if imageColor == .clear {
                    $0
                } else {
                    $0.imageColor(imageColor)
                }
            }
            .modifying {
                if leadingImage {
                    $0.leadingImage(Image.icon(.bell))
                } else {
                    $0
                }
            }
            .modifying {
                if trailingImage {
                    $0.trailingImage(Image.icon(.bell))
                } else {
                    $0
                }
            }
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
                ToggleOption("Leading Image", isOn: $leadingImage)
                ToggleOption("Trailing Image", isOn: $trailingImage)
            }
            ColorPickerOptionRow("Background Color", selection: $backgroundColor)
            ColorPickerOptionRow("Font Color", selection: $fontColor)
            ColorPickerOptionRow("Active Color", selection: $activeColor)
            ColorPickerOptionRow("Image Color", selection: $imageColor)
        }
    }
}

#Preview {
    ChipPreview()
} 

