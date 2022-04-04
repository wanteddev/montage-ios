//
//  FontType.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI
import UIKit

public extension DesignSystem {
    enum FontType {
        public enum Weight {
            case regular
            case medium
            case bold

            var uiFontWeight: UIFont.Weight {
                switch self {
                case .regular: return .regular
                case .medium: return .medium
                case .bold: return .bold
                }
            }

            var fontWeight: Font.Weight {
                switch self {
                case .regular: return .regular
                case .medium: return .medium
                case .bold: return .bold
                }
            }
        }
    }
}
