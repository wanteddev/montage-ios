//
//  UIColor+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import UIKit

extension UIColor {
    private static func load(name: String) -> UIColor {
        UIColor(named: name, in: DesignSystem.bundle, compatibleWith: nil) ?? .clear
    }

    public static func designSystem(_ type: DesignSystem.Color) -> UIColor {
        load(name: type.name)
    }
}
