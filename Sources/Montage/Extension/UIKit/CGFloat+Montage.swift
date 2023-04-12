//
//  CGFloat+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/23.
//

import Foundation

public extension CGFloat {
    static func spacing(_ spacingComponent: Spacing) -> CGFloat {
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
    
    static func opacity(_ opacityComponent: Decorate.Opacity) -> CGFloat {
        switch opacityComponent {
        case .p000:
            return 0
        case .p005:
            return 0.05
        case .p010:
            return 0.08
        case .p015:
            return 0.12
        case .p020:
            return 0.16
        case .p030:
            return 0.22
        case .p040:
            return 0.28
        case .p050:
            return 0.35
        case .p060:
            return 0.43
        case .p070:
            return 0.52
        case .p080:
            return 0.61
        case .p090:
            return 0.74
        case .p095:
            return 0.88
        case .p099:
            return 0.97
        case .p100:
            return 1
        }
    }
}
