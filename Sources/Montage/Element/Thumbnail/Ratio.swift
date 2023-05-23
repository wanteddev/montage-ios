//
//  Ratio.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/12.
//

import Foundation

public enum Ratio {
    case r1x1, r4x3, r3x2, r16x9, r2x1, r16x10, r21x9, r1_618x1, r5x4
}

extension Ratio {
    var size: CGSize {
        switch self {
        case .r1x1:
            return .init(width: 1, height: 1)
        case .r4x3:
            return .init(width: 4, height: 3)
        case .r3x2:
            return .init(width: 3, height: 2)
        case .r16x9:
            return .init(width: 16, height: 9)
        case .r2x1:
            return .init(width: 2, height: 1)
        case .r16x10:
            return .init(width: 16, height: 10)
        case .r21x9:
            return .init(width: 21, height: 9)
        case .r1_618x1:
            return .init(width: 1.618, height: 1)
        case .r5x4:
            return .init(width: 5, height: 4)
        }
    }
}
