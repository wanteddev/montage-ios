//
//  UIColor+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI

extension UIColor {
    static func load(name: String) -> UIColor {
        .init(named: name, in: Bundle.module, compatibleWith: nil) ?? .clear
    }

    public static func atomic(_ type: Color.Global) -> UIColor {
        load(name: type.name)
    }

    public static func alias(_ type: Color.Alias) -> UIColor {
        .init(dynamicProvider: type.resolve)
    }

    public static func component(_ type: Color.Component) -> UIColor {
        .init(dynamicProvider: type.resolve)
    }

    public static func montage(_ type: ColorResolvable) -> UIColor {
        .init(dynamicProvider: type.resolve)
    }
}

extension UIColor {
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}
