//
//  InteractiveCellStyle.swift
//  Montage
//
//  Created by 김삼열 on 1/3/25.
//

import SwiftUI

struct InteractiveCellStyle: ButtonStyle {
    private let fillWidth: Bool
    private let interactionPadding: CGFloat
    init(fillWidth: Bool, interactionPadding: CGFloat) {
        self.fillWidth = fillWidth
        self.interactionPadding = interactionPadding
    }
    @State private var labelSize: CGSize = .zero
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { labelSize = $0 })
            .overlay(
                Decorate.InteractionController(
                    state: configuration.isPressed ? .pressed : .normal,
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
