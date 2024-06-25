//
//  InteractionController.swift
//
//
//  Created by Ahn Sang Hoon on 6/24/24.
//

import SwiftUI

extension Decorate {
    public struct InteractionController: UIViewRepresentable {
        public var state: Interaction.State = .normal
        public var variant: Interaction.Variant = .normal
        public var color: Color.Alias = .labelNormal
        
        public typealias UIViewType = Interaction
        
        
        public init(
            state: Interaction.State = .normal,
            variant: Interaction.Variant = .normal,
            color: Color.Alias = .labelNormal
        ) {
            self.state = state
            self.variant = variant
            self.color = color
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init(
                state: state,
                color: color,
                variant: variant
            )
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
            uiView.variant = variant
            uiView.color = color
        }
    }
}

#Preview {
    HStack {
        Decorate.InteractionController()
            .background(SwiftUI.Color.cyan)
        
        Decorate.InteractionController(
            state: .pressed
        )
        .background(SwiftUI.Color.red)
    }
}
