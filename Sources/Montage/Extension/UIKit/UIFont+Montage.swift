//
//  UIFont+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import UIKit

public extension UIFont {
    static func designSystem(size: CGFloat, weight: DesignSystem.FontType.Weight) -> UIFont {
        .systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
}
