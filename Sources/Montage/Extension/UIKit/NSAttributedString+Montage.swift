//
//  NSAttributedString+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/25.
//

import UIKit

extension NSAttributedString {
    static func _montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: UIColor,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        let font = UIFont.montage(variant: variant, weight: weight)
        let lineHeight = Typography.getLineHeight(variant: variant)

        // http://blog.eppz.eu/uilabel-line-height-letter-spacing-and-more-uilabel-typography-extensions/
        let baselineOffset: CGFloat

        // 16.4 버전에서 offset 적용이 변경된 것 같아서 버전 분기 추가
        if #available(iOS 16.4, *) {
            baselineOffset = (lineHeight - font.lineHeight) / 2
        } else {
            baselineOffset = (lineHeight - font.lineHeight) / 2 / 2
        }

        let foregroundColor = color
        let tracking = Typography.getTracking(variant: variant)

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
                style.lineBreakStrategy = .hangulWordPriority
                return style
            }()
        ])
    }
}

public extension NSAttributedString {
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        colorResolver: ColorResolvable,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        _montage(
            string,
            variant: variant,
            weight: weight,
            color: colorResolver.resolve(.current),
            lineBreakMode: lineBreakMode
        )
    }

    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        alias: Color.Alias,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        montage(
            string,
            variant: variant,
            weight: weight,
            colorResolver: alias,
            lineBreakMode: lineBreakMode
        )
    }

    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        component: Color.Component,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        montage(
            string,
            variant: variant,
            weight: weight,
            colorResolver: component,
            lineBreakMode: lineBreakMode
        )
    }

    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        global: Color.Global,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        montage(
            string,
            variant: variant,
            weight: weight,
            colorResolver: global,
            lineBreakMode: lineBreakMode
        )
    }

    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> NSAttributedString {
        montage(
            string,
            variant: variant,
            weight: weight,
            alias: .labelNormal,
            lineBreakMode: .byWordWrapping
        )
    }

    static func montage(
        _ string: String
    ) -> NSAttributedString {
        montage(
            string,
            variant: .body1,
            weight: .regular,
            alias: .labelNormal,
            lineBreakMode: .byWordWrapping
        )
    }

    @available(
        swift,
        deprecated: 1.0,
        message: "alias color 사용 시 montage(_:variant:weight:alias:lineBreakMode:) 사용을 권장합니다."
    )
    static func montage(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: Color.Alias = .labelNormal,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        _montage(
            string,
            variant: variant,
            weight: weight,
            color: .alias(color),
            lineBreakMode: lineBreakMode
        )
    }
}
