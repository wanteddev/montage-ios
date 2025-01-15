//
//  Interaction.swift
//
//
//  Created by Ahn Sang Hoon on 6/24/24.
//

import SwiftUI

extension Decorate {
    public struct Interaction: View {
        public enum State {
            case normal, hovered, focused, pressed
        }

        public enum Variant {
            case normal, light, strong
        }

        public var state: State = .normal
        public var variant: Variant = .normal
        public var color: Color.Alias = .labelNormal

        public init(
            state: State = .normal,
            variant: Variant = .normal,
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

extension Decorate.Interaction.State {
    var alpha: CGFloat {
        switch self {
        case .normal:
            0
        case .hovered:
            0.05
        case .focused:
            0.08
        case .pressed:
            0.12
        }
    }
}

extension Decorate.Interaction.Variant {
    var weight: CGFloat {
        switch self {
        case .normal:
            1
        case .light:
            0.75
        case .strong:
            1.5
        }
    }
}

struct Interaction_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Decorate.Interaction()
            Decorate.Interaction(
                state: .pressed
            )
        }
    }
}
