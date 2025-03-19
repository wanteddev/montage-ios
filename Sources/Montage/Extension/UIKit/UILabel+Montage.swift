//
//  UILabel+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import UIKit

public extension UILabel {
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        colorResolver: ColorResolvable
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .montage(
            string,
            variant: variant,
            weight: weight,
            colorResolver: colorResolver
        )
        return label
    }
    
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        semantic: Color.Semantic = .labelNormal
    ) -> UILabel {
        montage(string, variant: variant, weight: weight, colorResolver: semantic)
    }
    
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        atomic: Color.Atomic = .red0
    ) -> UILabel {
        montage(string, variant: variant, weight: weight, colorResolver: atomic)
    }
    
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> UILabel {
        montage(
            string,
            variant: variant,
            weight: weight,
            semantic: .labelNormal
        )
    }
    
    static func montage(
        _ string: String
    ) -> UILabel {
        montage(
            string,
            variant: .body1,
            weight: .regular,
            semantic: .labelNormal
        )
    }
}
