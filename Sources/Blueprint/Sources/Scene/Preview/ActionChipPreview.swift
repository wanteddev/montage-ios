import SwiftUI
import Montage

struct ActionChipPreview: View {
    @State private var variant: Chip.Action.Variant = .solid
    @State private var size: Chip.Action.Size = .medium
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
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                Chip.Action(
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
                        $0.leadingImage(Image.montage(.bell))
                    } else {
                        $0
                    }
                }
                .modifying {
                    if trailingImage {
                        $0.trailingImage(Image.montage(.bell))
                    } else {
                        $0
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
                    TextInput.TextField(text: $text)
                        .placeholder("텍스트를 입력하세요")
                }
                
                HStack {
                    Text("Disable")
                    Control.Switch($disable)
                    Text("Active")
                    Control.Switch($active)
                }
                
                HStack {
                    Text("Leading Image")
                    Control.Switch($leadingImage)
                    Text("Trailing Image")
                    Control.Switch($trailingImage)
                }
                
                SwiftUI.ColorPicker("Background Color", selection: $backgroundColor)
                SwiftUI.ColorPicker("Font Color", selection: $fontColor)
                SwiftUI.ColorPicker("Active Color", selection: $activeColor)
                SwiftUI.ColorPicker("Image Color", selection: $imageColor)
                
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ActionChipPreview()
} 
