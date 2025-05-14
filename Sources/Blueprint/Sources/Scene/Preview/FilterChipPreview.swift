import SwiftUI
import Montage

struct FilterChipPreview: View {
    @State private var variant: FilterChip.Variant = .solid
    @State private var size: FilterChip.Size = .medium
    @State private var text = "텍스트"
    @State private var state: FilterChip.State = .normal
    @State private var active = false
    @State private var activeLabel: String? = nil
    @State private var disable = false
    @State private var iconColor: SwiftUI.Color = .clear
    @State private var fontColor: SwiftUI.Color = .clear
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                FilterChip(
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
                
                Text("Options").bold()
                
                HStack {
                    Text("Variant")
                    SegmentedControl(
                        selectedIndex: Binding(
                            get: { variant == .solid ? 0 : 1 },
                            set: { variant = $0 == 0 ? .solid : .outlined }
                        ),
                        labels: ["Solid", "Outlined"]
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("Size")
                    SegmentedControl(
                        selectedIndex: Binding(
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
                        ),
                        labels: ["XSmall", "Small", "Medium", "Large"]
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("Text")
                    TextField(text: $text)
                        .placeholder("텍스트를 입력하세요")
                }
                
                HStack {
                    Text("State")
                    SegmentedControl(
                        selectedIndex: Binding(
                            get: { state == .normal ? 0 : 1 },
                            set: { state = $0 == 0 ? .normal : .expand }
                        ),
                        labels: ["Normal", "Expand"]
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("Active")
                    Control.Switch($active)
                    Text("Disable")
                    Control.Switch($disable)
                }
                
                HStack {
                    Text("Active Label")
                    TextField(text: Binding(
                        get: { activeLabel ?? "" },
                        set: { activeLabel = $0.isEmpty ? nil : $0 }
                    ))
                    .placeholder("활성화 상태일 때 표시할 텍스트")
                }
                
                SwiftUI.ColorPicker("Icon Color", selection: $iconColor)
                SwiftUI.ColorPicker("Font Color", selection: $fontColor)
                
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    FilterChipPreview()
} 
