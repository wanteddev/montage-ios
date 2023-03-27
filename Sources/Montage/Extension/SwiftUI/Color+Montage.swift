//
//  Color+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI
import UIKit

extension Color {
    private static func load(name: String) -> Color {
        Color(UIColor(named: name, in: Bundle.module, compatibleWith: nil)!)
    }

    public static func atomic(_ type: Montage.Color.Global) -> Color {
        load(name: type.name)
    }
    
    public static func alias(_ type: Montage.Color.Alias) -> Color {
        .init(UIColor.alias(type))
    }
    
    public static func component(_ type: Montage.Color.Component) -> Color {
        .init(UIColor.component(type))
    }
}
