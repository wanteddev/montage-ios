//
//  PrimaryButtonSize.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/14.
//

import SwiftUI

public extension PrimaryButton {
    enum Size {
        case large
        case medium
        case small

        var height: CGFloat {
            switch self {
            case .large: return 50.0
            case .medium: return 40.0
            case .small: return 32.0
            }
        }

        var font: Font {
            switch self {
            case .large:
                return .designSystem(size: 16.0, weight: .bold)
            case .medium:
                return .designSystem(size: 15.0, weight: .bold)
            case .small:
                return .designSystem(size: 14.0, weight: .bold)
            }
        }

        var cornerRadius: CGFloat { 25.0 }
    }
}
