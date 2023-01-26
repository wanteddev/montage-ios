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
        varient: Montage.Typography.Variant,
        size: Montage.Typography.Size = .small,
        weight: Montage.Typography.Weight = .regular,
        color: Montage.Color.Alias = .labelNormal
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .montage(string, varient: varient, size: size, weight: weight, color: color)
        return label
    }
}
