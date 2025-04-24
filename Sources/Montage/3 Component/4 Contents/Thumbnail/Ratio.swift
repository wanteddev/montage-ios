//
//  Ratio.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/12.
//

import Foundation

public enum Ratio {
    case r21x9, r2x1, r16x9, r1_618x1, r16x10, r3x2, r4x3, r5x4
    case r1x1
    case r4x5, r3x4, r2x3, r10x16, r1x1_618, r9x16, r1x2, r9x21
    
    public var rawValue: CGFloat {
        size.width / size.height
    }
}

extension Ratio {
    var size: CGSize {
        switch self {
        // 가로가 긴 비율
        case .r21x9: .init(width: 21, height: 9)
        case .r2x1: .init(width: 2, height: 1)
        case .r16x9: .init(width: 16, height: 9)
        case .r1_618x1: .init(width: 1.618, height: 1)
        case .r16x10: .init(width: 16, height: 10)
        case .r3x2: .init(width: 3, height: 2)
        case .r4x3: .init(width: 4, height: 3)
        case .r5x4: .init(width: 5, height: 4)
        
        // 정사각형
        case .r1x1: .init(width: 1, height: 1)
        
        // 세로가 긴 비율
        case .r4x5: .init(width: 4, height: 5)
        case .r3x4: .init(width: 3, height: 4)
        case .r2x3: .init(width: 2, height: 3)
        case .r10x16: .init(width: 10, height: 16)
        case .r1x1_618: .init(width: 1, height: 1.618)
        case .r9x16: .init(width: 9, height: 16)
        case .r1x2: .init(width: 1, height: 2)
        case .r9x21: .init(width: 9, height: 21)
        }
    }
}
