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
        public var variant: Filter.Variant = .normal
        public var size: Filter.Size = .medium
        public var text: String = ""
        public var state: Decorate.Interaction.State = .normal
        public var active: Bool = false
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Filter
        
        public init(
            variant: Filter.Variant = .normal,
            size: Filter.Size = .medium,
            text: String,
            state: Decorate.Interaction.State = .normal,
            active: Bool = false,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.active = active
            self.disable = disable
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
            uiView.active = active
            uiView.disable = disable
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
                    variant: .normal,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .expand,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("State").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .normal,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .normal,
                    size: .medium,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .normal,
                    size: .medium,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Size").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    variant: .normal,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    variant: .normal,
                    size: .large,
                    text: "안녕하세요"
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
