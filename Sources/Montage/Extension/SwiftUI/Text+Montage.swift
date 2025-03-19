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
        color: SwiftUI.Color
    ) -> Text {
        font(.montage(variant: variant, weight: weight))
            .tracking(Typography.getTracking(variant: variant))
            .foregroundColor(color)
    }
    
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        colorResolver: ColorResolvable
    ) -> Text {
        montage(variant: variant, weight: weight, color: .init(uiColor: colorResolver.resolve(.current)))
    }
    
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        semantic: Color.Semantic = .labelNormal
    ) -> Text {
        montage(variant: variant, weight: weight, color: .semantic(semantic))
    }
    
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        atomic: Color.Atomic
    ) -> Text {
        montage(variant: variant, weight: weight, color: .atomic(atomic))
    }
}
