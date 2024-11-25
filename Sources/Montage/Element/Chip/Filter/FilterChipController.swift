//
//  FilterChipController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import SwiftUI
import Pretendard

extension Chip {
    public struct FilterChipController: UIViewRepresentable {
        public var variant: Filter.Variant = .solid
        public var size: Filter.Size = .normal
        public var text: String = ""
        public var state: Filter.State = .normal
        public var interactionState: Decorate.Interaction.State = .normal
        public var active: Bool = false
        public var activeLabel: String? = nil
        public var disable: Bool = false
        public var iconColor: SwiftUI.Color? = nil
        public var fontColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Filter
        
        public init(
            variant: Filter.Variant = .solid,
            size: Filter.Size = .normal,
            text: String,
            state: Filter.State = .normal,
            interactionState: Decorate.Interaction.State = .normal,
            active: Bool = false,
            activeLabel: String? = nil,
            disable: Bool = false,
            iconColor: SwiftUI.Color? = nil,
            fontColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.interactionState = interactionState
            self.active = active
            self.activeLabel = activeLabel
            self.disable = disable
            self.iconColor = iconColor
            self.fontColor = fontColor
            self.handler = handler
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.text = text
            uiView.state = state
            uiView.interactionState = interactionState
            uiView.active = active
            uiView.activeLabel = activeLabel
            uiView.disable = disable
            if let iconColor {
                uiView.iconUIColor = iconColor.uiColor
            } else {
                uiView.iconUIColor = nil
            }
            if let fontColor {
                uiView.fontUIColor = fontColor.uiColor
            } else {
                uiView.fontUIColor = nil
            }
            uiView.handler = handler
        }
        
        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
            uiView.intrinsicContentSize
        }
    }
}

var filterChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Variant").montage(variant: .headline2)
            HStack {
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
            }
        }

        VStack(alignment: .leading) {
            Text("Size").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .solid,
                    size: .xsmall,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    size: .small,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    size: .large,
                    text: "텍스트"
                )
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .xsmall,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .small,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "텍스트"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .large,
                    text: "텍스트"
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("State").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    state: .expand
                )
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    state: .expand
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Active").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    active: true
                )
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    active: true
                )
            }
        }

        VStack(alignment: .leading) {
            Text("Disable").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    disable: true
                )
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: true
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Customize").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    iconColor: .alias(.accentLime)
                )
                Chip.FilterChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    fontColor: .alias(.accentPink)
                )
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    iconColor: .alias(.accentViolet),
                    fontColor: .alias(.accentRedOrange)
                )
            }
        }
    }
}

struct FilterChipController_Previews: PreviewProvider {
    static var previews: some View {
        filterChipControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
