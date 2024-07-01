//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal
    ) -> Text {
        font(.montage(variant: variant, weight: weight))
            .tracking(Typography.getTracking(variant: variant))
            .foregroundColor(.alias(color))
    }
}
