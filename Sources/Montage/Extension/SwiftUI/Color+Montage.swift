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
        Color(UIColor(named: name, in: DesignSystem.bundle, compatibleWith: nil)!)
    }

    public static func designSystem(_ type: DesignSystem.Color) -> Color {
        load(name: type.name)
    }
}
