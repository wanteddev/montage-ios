//
//  MultiSelectChipController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import SwiftUI
import Pretendard

extension Chip {
    public struct MultiSelectChipController: UIViewRepresentable {
        public var size: MultiSelect.Size = .medium
        public var text: String = ""
        public var state: Decorate.Interaction.State = .normal
        public var active: Bool = false
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = MultiSelect
        
        public init(
            size: MultiSelect.Size = .medium,
            text: String,
            state: Decorate.Interaction.State = .normal,
            active: Bool = false,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
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
            uiView.size = size
            uiView.text = text
            uiView.state = state
            uiView.active = active
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

var multiSelectChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("State").montage(varient: .headline2)
            HStack(alignment: .center) {
                Chip.MultiSelectChipController(
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.MultiSelectChipController(
                    size: .medium,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
                
                Chip.MultiSelectChipController(
                    size: .medium,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Size").montage(varient: .headline2)
            HStack(alignment: .center) {
                Chip.MultiSelectChipController(
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.MultiSelectChipController(
                    size: .large,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
    }
}

struct MultiSelectChipController_Previews: PreviewProvider {
    static var previews: some View {
        multiSelectChipControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
