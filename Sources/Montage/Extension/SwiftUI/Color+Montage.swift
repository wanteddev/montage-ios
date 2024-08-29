//
//  Color+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI

extension SwiftUI.Color {
    private static func load(name: String) -> SwiftUI.Color {
        .init(UIColor(named: name, in: Bundle.module, compatibleWith: nil)!)
    }

    public static func atomic(_ type: Color.Global) -> SwiftUI.Color {
        load(name: type.name)
    }
    
    public static func alias(_ type: Color.Alias) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.alias(type))
    }
    
    public static func component(_ type: Color.Component) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.component(type))
    }
    
    public static func montage(_ type: ColorResolvable) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.montage(type))
    }
}

extension SwiftUI.Color {
    public var uiColor: UIColor {
        UIColor(self)
    }
}
