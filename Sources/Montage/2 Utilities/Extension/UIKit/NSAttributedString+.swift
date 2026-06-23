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
        let font = UIFont.font(variant: variant, weight: weight)
        // font는 Dynamic Type 스케일이 적용되므로, 고정 lineHeight를 그대로 쓰면 큰 글자에서 줄 높이가
        // 폰트보다 작아져 텍스트가 잘린다. 동일한 텍스트 스타일 곡선으로 lineHeight도 함께 스케일한다.
        let lineHeight = UIFontMetrics(forTextStyle: variant.uiTextStyle)
            .scaledValue(for: variant.lineHeight)

        // http://blog.eppz.eu/uilabel-line-height-letter-spacing-and-more-uilabel-typography-extensions/
        let baselineOffset: CGFloat

        // 16.4 버전에서 offset 적용이 변경된 것 같아서 버전 분기 추가
        if #available(iOS 16.4, *) {
            baselineOffset = (lineHeight - font.lineHeight) / 2
        } else {
            baselineOffset = (lineHeight - font.lineHeight) / 2 / 2
        }

        let foregroundColor = color
        let tracking = variant.tracking

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
