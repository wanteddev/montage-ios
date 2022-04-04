//
//  IconButtonStyle.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI

public extension IconButton {
    enum Style {
        case primary
        case blue
        case black

        var foregroundColor: Color {
            switch self {
            case .primary: return .designSystem(.commonWhite)
            case .blue: return .designSystem(.primaryBlue400)
            case .black: return .designSystem(.neutralGray900)
            }
        }

        var borderColor: Color {
            switch self {
            case .primary: return .clear
            case .blue: return .designSystem(.neutralBlueGray200)
            case .black: return .designSystem(.neutralBlueGray200)
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary: return .designSystem(.primaryBlue400)
            case .blue: return .designSystem(.neutralWhite100)
            case .black: return .designSystem(.neutralWhite100)
            }
        }
    }
}
