//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func montage(
        ofSize size: CGFloat,
        weight: Montage.Typography.Weight,
        color: Montage.Color.Global? = nil
    ) -> Text {
        let text = font(.montage(size: size, weight: weight))

        if let color = color {
            return text.foregroundColor(.atomic(color))
        } else {
            return text
        }
    }
}
