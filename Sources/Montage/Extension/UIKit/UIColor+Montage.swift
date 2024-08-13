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
