//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func montage(
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal
    ) -> Text {
        font(.montage(varient: varient, weight: weight))
            .tracking(Typography.getTracking(varient: varient))
            .foregroundColor(.alias(color))
    }
}
