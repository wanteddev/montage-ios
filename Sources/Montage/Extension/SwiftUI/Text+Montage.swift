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
        alias: Color.Alias = .labelNormal
    ) -> Text {
        montage(variant: variant, weight: weight, color: .alias(alias))
    }
    
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        component: Color.Component
    ) -> Text {
        montage(variant: variant, weight: weight, color: .component(component))
    }
    
    func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        global: Color.Global
    ) -> Text {
        montage(variant: variant, weight: weight, color: .atomic(global))
    }
}
