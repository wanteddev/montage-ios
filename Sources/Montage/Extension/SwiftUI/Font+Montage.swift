//
//  Font+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI

public extension Font {
    static func montage(size: CGFloat, weight: Typography.Weight) -> Font {
        .custom(weight.pretendardWeight.fontName, size: size)
    }
    
    static func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> Font? {
        let sementicWeight = Typography.getSementicWeight(variant: variant, weight: weight)
        let sementicSize = Typography.getSementicSize(variant: variant)
        return .custom(sementicWeight.fontName, size: sementicSize)
    }
}
