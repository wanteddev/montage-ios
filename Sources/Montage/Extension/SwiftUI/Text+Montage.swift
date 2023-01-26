//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func montage(
        varient: Montage.Typography.Variant,
        size: Montage.Typography.Size = .small,
        weight: Montage.Typography.Weight = .regular,
        color: Montage.Color.Alias = .labelNormal
    ) -> Text {
        font(
            .sementic(varient: varient, weight: weight, size: size)
        ).foregroundColor(
            .alias(color)
        )
    }
}
