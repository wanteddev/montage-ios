//
//  PressInteractionModifier.swift
//  Montage
//
//  Created by 김삼열 on 1/3/25.
//

import SwiftUI

struct PressInteractionModifier: ViewModifier {
    @Binding private var pressed: Bool
    private let fillWidth: Bool
    private let interactionPadding: CGFloat
    init(pressed: Binding<Bool>, fillWidth: Bool, interactionPadding: CGFloat) {
        _pressed = pressed
        self.fillWidth = fillWidth
        self.interactionPadding = interactionPadding
    }

    @State private var labelSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { labelSize = $0 })
            .overlay(
                Decorate.Interaction(
                    state: pressed ? .pressed : .normal,
                    variant: .light,
                    color: .labelNormal
                )
                .frame(
                    width: labelSize.width + (fillWidth ? 0 : interactionPadding * 2),
                    height: labelSize.height
                )
                .clipShape(RoundedRectangle(cornerRadius: fillWidth ? 0 : 12))
            )
    }
}
