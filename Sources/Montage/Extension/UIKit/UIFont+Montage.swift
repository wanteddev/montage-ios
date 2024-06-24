//
//  UIFont+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import UIKit
import Pretendard

public extension UIFont {
    static func montage(size: CGFloat, weight: Typography.Weight) -> UIFont? {
        UIFont(name: weight.pretendardWeight.fontName, size: size)
    }
    
    static func montage(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> UIFont {
        let sementicWeight = Typography.getSementicWeight(varient: variant, weight: weight)
        let failbackWeight = Typography.getFailbackWeight(varient: variant, weight: weight)
        let sementicSize = Typography.getSementicSize(varient: variant)
        return UIFont(name: sementicWeight.fontName, size: sementicSize) ??
            .systemFont(ofSize: sementicSize, weight: failbackWeight)
    }
}
