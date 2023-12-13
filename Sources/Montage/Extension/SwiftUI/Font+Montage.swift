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
        varient: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> Font? {
        let sementicWeight = Typography.getSementicWeight(varient: varient, weight: weight)
        let sementicSize = Typography.getSementicSize(varient: varient)
        return .custom(sementicWeight.fontName, size: sementicSize)
    }
}
