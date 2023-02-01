//
//  NSAttributedString+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/25.
//

import UIKit

public extension NSAttributedString {
    static func montage(
        _ string: String,
        varient: Montage.Typography.Variant = .body1,
        size: Montage.Typography.Size = .small,
        weight: Montage.Typography.Weight = .regular,
        color: Montage.Color.Alias = .labelNormal
    ) -> NSAttributedString {
        .init(string: string, attributes: [
            .font: UIFont.montage(varient: varient, weight: weight, size: size),
            .foregroundColor: UIColor.alias(color),
            .tracking: Montage.Typography.getTracking(varient: varient, size: size),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .left
                style.lineSpacing = varient.lineSpacing
                return style
            }()
        ])
    }
}

