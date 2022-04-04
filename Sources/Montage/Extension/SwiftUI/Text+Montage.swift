//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func designSystem(
        ofSize size: CGFloat,
        weight: DesignSystem.FontType.Weight,
        color: DesignSystem.Color? = nil
    ) -> Text {
        let text = font(.designSystem(size: size, weight: weight))

        if let color = color {
            return text.foregroundColor(.designSystem(color))
        } else {
            return text
        }
    }
}
