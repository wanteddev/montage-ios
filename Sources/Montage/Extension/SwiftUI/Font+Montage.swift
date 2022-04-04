//
//  Font+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI

public extension Font {
    static func designSystem(size: CGFloat, weight: DesignSystem.FontType.Weight) -> Font {
        .system(size: size, weight: weight.fontWeight, design: .default)
    }
}
