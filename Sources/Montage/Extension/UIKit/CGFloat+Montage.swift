//
//  CGFloat+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/23.
//

import Foundation

public extension CGFloat {
    static func spacing(from spacingComponent: Montage.Spacing) -> CGFloat {
        switch spacingComponent {
        case .pt01:
            return 1
        case .pt02:
            return 2
        case .pt04:
            return 4
        case .pt08:
            return 8
        case .pt12:
            return 12
        case .pt16:
            return 16
        case .pt20:
            return 20
        case .pt24:
            return 24
        case .pt28:
            return 28
        case .pt32:
            return 32
        case .pt36:
            return 36
        case .pt40:
            return 40
        case .pt48:
            return 48
        case .pt56:
            return 56
        case .pt64:
            return 64
        case .pt72:
            return 72
        case .pt80:
            return 80
        }
    }
}
