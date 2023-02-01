//
//  UIFont+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import UIKit
import Pretendard

public extension UIFont {
    static func montage(size: CGFloat, weight: Montage.Typography.Weight) -> UIFont? {
        UIFont(name: weight.pretendardWeight.fontName, size: size)
    }
    
    static func montage(
        varient: Montage.Typography.Variant = .body1,
        weight: Montage.Typography.Weight = .regular,
        size: Montage.Typography.Size = .small
    ) -> UIFont {
        let sementicWeight = Montage.Typography.getSementicWeight(varient: varient, weight: weight)
        let sementicSize = Montage.Typography.getSementicSize(varient: varient, size: size)
        return UIFont(name: sementicWeight.fontName, size: sementicSize)!
    }
}
