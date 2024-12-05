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
            1
        case .pt02:
            2
        case .pt04:
            4
        case .pt08:
            8
        case .pt12:
            12
        case .pt16:
            16
        case .pt20:
            20
        case .pt24:
            24
        case .pt28:
            28
        case .pt32:
            32
        case .pt36:
            36
        case .pt40:
            40
        case .pt48:
            48
        case .pt56:
            56
        case .pt64:
            64
        case .pt72:
            72
        case .pt80:
            80
        }
    }

    static func opacity(_ opacityComponent: Decorate.Opacity) -> CGFloat {
        switch opacityComponent {
        case .p000:
            0
        case .p005:
            0.05
        case .p008:
            0.08
        case .p012:
            0.12
        case .p016:
            0.16
        case .p022:
            0.22
        case .p028:
            0.28
        case .p032:
            0.32
        case .p035:
            0.35
        case .p043:
            0.43
        case .p052:
            0.52
        case .p061:
            0.61
        case .p074:
            0.74
        case .p088:
            0.88
        case .p097:
            0.97
        case .p100:
            1
        }
    }
}
