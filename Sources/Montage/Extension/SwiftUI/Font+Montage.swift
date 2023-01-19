//
//  Font+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI

public extension Font {
    static func montage(size: CGFloat, weight: Montage.Typography.Weight) -> Font {
        .custom(weight.pretendardWeight.fontName, size: size)
    }
    
    static func sementic(
        varient: Montage.Typography.Variant,
        weight: Montage.Typography.Weight,
        size: Montage.Typography.Size
    ) -> Font? {
        let sementicWeight = Montage.Typography.getSementicWeight(varient: varient, weight: weight)
        let sementicSize = Montage.Typography.getSementicSize(varient: varient, size: size)
        return .custom(sementicWeight.fontName, size: sementicSize)
    }
}
