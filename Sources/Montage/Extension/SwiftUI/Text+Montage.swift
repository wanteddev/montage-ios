//
//  Text+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import SwiftUI

public extension Text {
    func montage(
        varient: Montage.Typography.Variant = .body1,
        size: Montage.Typography.Size = .small,
        weight: Montage.Typography.Weight = .regular,
        color: Montage.Color.Alias = .labelNormal
    ) -> some View {
        font(.montage(varient: varient, weight: weight, size: size))
            .foregroundColor(.alias(color))
            .tracking(Montage.Typography.getTracking(varient: varient, size: size))
            .lineSpacing(varient.lineSpacing)
            .padding(.vertical, varient.padding)
    }
}
