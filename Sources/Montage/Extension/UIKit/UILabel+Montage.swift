//
//  UILabel+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/05/28.
//

import UIKit

public extension UILabel {
    static func montage(
        size: CGFloat,
        weight: Montage.Typography.Weight,
        color: Montage.Color.Global? = nil
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.font = .montage(size: size, weight: weight)

        if let color = color {
            label.textColor = .atomic(color)
        }

        return label
    }
}
