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
        @State public var varient: Filter.Varient = .normal
        @State public var size: Filter.Size = .medium
        @State public var text: String = ""
        @State public var state: Decorate.Interaction.State = .normal
        @State public var active: Bool = false
        @State public var disable: Bool = false
        
        public typealias UIViewType = Filter
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
            uiView.size = size
            uiView.text = text
            uiView.state = state
            uiView.active = active
            uiView.disable = disable
        }
    }
}

var filterChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Varient").montage(varient: .heading2)
            HStack {
                Chip.FilterChipController(
                    varient: .normal,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    varient: .expand,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("State").montage(varient: .heading2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    varient: .normal,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    varient: .normal,
                    size: .medium,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
                
                Chip.FilterChipController(
                    varient: .normal,
                    size: .medium,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Size").montage(varient: .heading2)
            HStack(alignment: .center) {
                Chip.FilterChipController(
                    varient: .normal,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.FilterChipController(
                    varient: .normal,
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
