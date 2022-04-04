//
//  TextButtonStyle.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI

public extension TextButton {
    enum Style {
        case primary
        case gray

        var color: Color {
            switch self {
            case .primary: return .designSystem(.primaryBlue400)
            case .gray: return .designSystem(.neutralGray500)
            }
        }
    }
}
