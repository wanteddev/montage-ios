//
//  Color.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import Foundation

public extension DesignSystem {
    enum Color: String {
        // Neutral
        case neutralWhite100

        case neutralGray100
        case neutralGray200
        case neutralGray300
        case neutralGray400
        case neutralGray500
        case neutralGray600
        case neutralGray700
        case neutralGray800
        case neutralGray900

        case neutralBlack100

        case neutralBlueGray100
        case neutralBlueGray200

        // Primary
        case primaryBlue400
        case primaryBlue800

        // Secondary
        case secondaryGreen400
        case secondaryPink400
        case secondaryPurple400
        case secondaryRed400
        case secondaryOrange800

        // Secondary Pastel
        case secondaryPastelBlue50
        case secondaryPastelCyan50
        case secondaryPastelGreen50
        case secondaryPastelGreen100
        case secondaryPastelIndigo50
        case secondaryPastelLightBlue50
        case secondaryPastelLime50
        case secondaryPastelPurple50

        // Semantic
        case baseBg
        case contentsBg
        case elevatedBg
        case commonWhite

        var name: String { rawValue }
    }
}
