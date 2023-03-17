//
//  CGFloat+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/23.
//

import Foundation

public extension CGFloat {
    static func spacing(_ spacingComponent: Montage.Spacing) -> CGFloat {
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
    
    static func opacity(_ opacityComponent: Montage.Opacity) -> CGFloat {
        switch opacityComponent {
        case .p000:
            return 0
        case .p005:
            return 0.05
        case .p010:
            return 0.10
        case .p015:
            return 0.15
        case .p020:
            return 0.20
        case .p030:
            return 0.30
        case .p040:
            return 0.40
        case .p050:
            return 0.50
        case .p060:
            return 0.60
        case .p070:
            return 0.70
        case .p080:
            return 0.80
        case .p090:
            return 0.90
        case .p095:
            return 0.95
        case .p099:
            return 0.99
        case .p100:
            return 1
        }
    }
}
