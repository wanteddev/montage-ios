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
        varient: Typography.Variant = .body1,
        size: Typography.Size = .small,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        let font = UIFont.montage(varient: varient, weight: weight, size: size)
        let lineHeight = Typography.getLineHeight(varient: varient, size: size)
        
        // http://blog.eppz.eu/uilabel-line-height-letter-spacing-and-more-uilabel-typography-extensions/
        let baselineOffset: CGFloat
        
        // 16.4 버전에서 offset 적용이 변경된 것 같아서 버전 분기 추가
        if #available(iOS 16.4, *) {
            baselineOffset = (lineHeight - font.lineHeight) / 2
        } else {
            baselineOffset = (lineHeight - font.lineHeight) / 2 / 2
        }
        
        let foregroundColor = UIColor.alias(color)
        let tracking = Typography.getTracking(varient: varient, size: size)
        
        return .init(string: string, attributes: [
            .font: font,
            .tracking: tracking,
            .baselineOffset: baselineOffset,
            .foregroundColor: foregroundColor,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .left
                style.minimumLineHeight = lineHeight
                style.lineBreakMode = lineBreakMode
                return style
            }()
        ])
    }
}

