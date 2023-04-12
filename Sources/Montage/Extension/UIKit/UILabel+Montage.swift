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
        size: Typography.Size = .small,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .montage(string, varient: varient, size: size, weight: weight, color: color)
        return label
    }
}
