//
//  UILabel+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import UIKit

public extension UILabel {
    static func designSystem(
        size: CGFloat,
        weight: DesignSystem.FontType.Weight,
        color: DesignSystem.Color? = nil
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.font = .designSystem(size: size, weight: weight)

        if let color = color {
            label.textColor = .designSystem(color)
        }

        return label
    }
}
