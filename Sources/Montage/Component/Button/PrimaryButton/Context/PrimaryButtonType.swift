//
//  PrimaryButtonType.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/14.
//

import SwiftUI

public extension PrimaryButton {
    enum `Type` {
        case fill
        case line(style: Style)

        public enum Style {
            case primary
            case blue
            case black
        }

        var backgroundColor: (default: Color, pressed: Color, disabled: Color) {
            switch self {
            case .fill:
                return (
                    default: .designSystem(.primaryBlue400),
                    pressed: .designSystem(.primaryBlue800),
                    disabled: .designSystem(.neutralBlueGray100)
                )
            case .line:
                return (
                    default: .clear,
                    pressed: .clear,
                    disabled: .designSystem(.neutralBlueGray100)
                )
            }
        }

        var tintColor: (default: Color, pressed: Color, disabled: Color) {
            switch self {
            case .fill:
                return (
                    default: .designSystem(.commonWhite),
                    pressed: .designSystem(.commonWhite),
                    disabled: .designSystem(.neutralGray300)
                )
            case .line(let style):
                return (
                    default: style == .black
                        ? .designSystem(.neutralGray900) : .designSystem(.primaryBlue400),
                    pressed: .designSystem(.primaryBlue800),
                    disabled: .designSystem(.neutralGray300)
                )
            }
        }

        var borderColor: (default: Color, pressed: Color, disabled: Color?)? {
            switch self {
            case .fill:
                return nil
            case .line(let style):
                return (
                    default: style == .primary
                        ? .designSystem(.primaryBlue400) : .designSystem(.neutralBlueGray200),
                    pressed: style == .primary
                        ? .designSystem(.primaryBlue800) : .designSystem(.neutralBlueGray200),
                    disabled: nil
                )
            }
        }
    }
}
