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
        public var variant: Filter.Variant = .filled
        public var size: Filter.Size = .normal
        public var text: String = ""
        public var state: Filter.State = .normal
        public var interactionState: Decorate.Interaction.State = .normal
        public var active: Bool = false
        public var disable: Bool = false
        public var iconColorResolver: ColorResolvable? = nil
        public var fontColorResolver: ColorResolvable? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Filter
        
        public init(
            variant: Filter.Variant = .filled,
            size: Filter.Size = .normal,
            text: String,
            state: Filter.State = .normal,
            interactionState: Decorate.Interaction.State = .normal,
            active: Bool = false,
            disable: Bool = false,
            iconColorResolver: ColorResolvable? = nil,
            fontColorResolver: ColorResolvable? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.interactionState = interactionState
            self.active = active
            self.disable = disable
            self.iconColorResolver = iconColorResolver
            self.fontColorResolver = fontColorResolver
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
            uiView.disable = disable
            uiView.iconColorResolver = iconColorResolver
            uiView.fontColorResolver = fontColorResolver
            uiView.handler = handler
        }
    }
}

var filterChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Variant").montage(variant: .headline2)
            HStack {
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }

        VStack(alignment: .leading) {
            Text("Size").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .filled,
                    size: .xsmall,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    size: .small,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    size: .large,
                    text: "텍스트"
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .xsmall,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .small,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "텍스트"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    size: .large,
                    text: "텍스트"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("State").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    state: .expand
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    state: .expand
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Active").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
            }
        }

        VStack(alignment: .leading) {
            Text("Disable").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Customize").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    iconColorResolver: Color.Alias.accentLime
                ).fixedSize()
                Chip.FilterChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    fontColorResolver: Color.Alias.accentPink
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    iconColorResolver: Color.Alias.accentViolet,
                    fontColorResolver: Color.Alias.accentRedOrange
                ).fixedSize()
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
