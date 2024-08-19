//
//  ListCell+Helper.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/20/24.
//

import SwiftUI

extension Montage.List.Cell {
    struct ListCellCustomButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .overlay(
                    Decorate.InteractionController(
                        state: configuration.isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .labelNormal
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                )
        }
    }
}

extension ButtonStyle where Self == Montage.List.Cell.ListCellCustomButtonStyle {
    static var interaction: Montage.List.Cell.ListCellCustomButtonStyle {
        Montage.List.Cell.ListCellCustomButtonStyle()
    }
}
