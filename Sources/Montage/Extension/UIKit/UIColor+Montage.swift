//
//  UIColor+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import UIKit

extension UIColor {
    static func load(name: String) -> UIColor {
        UIColor(named: name, in: Montage.bundle, compatibleWith: nil) ?? .clear
    }
    
    public static func atomic(_ type: Montage.Color.Global) -> UIColor {
        load(name: type.name)
    }
    
    public static func alias(_ type: Montage.Color.Alias) -> UIColor {
        .init(dynamicProvider: type.convert)
    }
}
