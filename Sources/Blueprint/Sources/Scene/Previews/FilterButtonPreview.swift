import SwiftUI
import Montage

struct FilterButtonPreview: View {
    @State private var variant: FilterButton.Variant = .solid
    @State private var size: FilterButton.Size = .medium
    @State private var text = "텍스트"
    @State private var state: FilterButton.State = .normal
    @State private var active = false
    @State private var activeLabel: String? = nil
    @State private var disable = false
    @State private var iconColor: SwiftUI.Color = .clear
    @State private var fontColor: SwiftUI.Color = .clear
    
    var body: some View {
        PreviewLayout {
            FilterButton(
                variant: variant,
                size: size,
                text: text,
                state: $state
            )
            .active(active, label: activeLabel)
            .disabled(disable)
            .modifying {
                if fontColor == .clear {
                    $0
                } else {
                    $0.fontColor(fontColor)
                }
            }
            .modifying {
                if iconColor == .clear {
                    $0
                } else {
                    $0.iconColor(iconColor)
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
            SegmentedIndexRow("State", index: Binding(
                get: { state == .normal ? 0 : 1 },
                set: { state = $0 == 0 ? .normal : .expand }
            ), labels: ["Normal", "Expand"])
            HStack {
                ToggleOption("Active", isOn: $active)
                ToggleOption("Disable", isOn: $disable)
            }
            TextFieldOptionRow("Active Label", text: Binding(
                get: { activeLabel ?? "" },
                set: { activeLabel = $0.isEmpty ? nil : $0 }
            ), placeholder: "활성화 상태일 때 표시할 텍스트")
            ColorPickerOptionRow("Icon Color", selection: $iconColor)
            ColorPickerOptionRow("Font Color", selection: $fontColor)
        }
    }
}

#Preview {
    FilterButtonPreview()
} 

