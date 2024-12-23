//
//  InteractionController.swift
//
//
//  Created by Ahn Sang Hoon on 6/24/24.
//

import SwiftUI

extension Decorate {
    public struct InteractionController: View {
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

        public var body: some View {
            Rectangle()
                .foregroundStyle(SwiftUI.Color.alias(color))
                .opacity(state.alpha * variant.weight)
        }
    }
}

struct Interaction_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Decorate.InteractionController()
            Decorate.InteractionController(
                state: .pressed
            )
        }
    }
}
