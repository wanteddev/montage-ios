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

    public static func atomic(_ type: Color.Atomic) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.atomic(type))
    }

    public static func semantic(_ type: Color.Semantic) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.semantic(type))
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
