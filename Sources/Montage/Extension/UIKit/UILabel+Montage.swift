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
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        colorResolver: ColorResolvable
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .montage(string, varient: varient, weight: weight, colorResolver: colorResolver)
        return label
    }
    
    static func montage(
        _ string: String,
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        alias: Color.Alias = .labelNormal
    ) -> UILabel {
        montage(string, varient: varient, weight: weight, colorResolver: alias)
    }
    
    static func montage(
        _ string: String,
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        component: Color.Component = .fillNormal
    ) -> UILabel {
        montage(string, varient: varient, weight: weight, colorResolver: component)
    }
    
    static func montage(
        _ string: String,
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        global: Color.Global = .globalRed0
    ) -> UILabel {
        montage(string, varient: varient, weight: weight, colorResolver: global)
    }
    
    static func montage(
        _ string: String,
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> UILabel {
        montage(
            string,
            varient: varient,
            weight: weight,
            alias: .labelNormal
        )
    }
    
    static func montage(
        _ string: String
    ) -> UILabel {
        montage(
            string,
            varient: .body1,
            weight: .regular,
            alias: .labelNormal
        )
    }

    
    @available(swift, deprecated: 1.0, message: "alias color 사용 시 montage(_:varient:weight:alias:) 사용을 권장합니다.")
    static func montage(
        _ string: String,
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .montage(string, varient: varient, weight: weight, color: color)
        return label
    }
}
