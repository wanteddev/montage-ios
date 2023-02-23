//
//  Elevation.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/16.
//

import UIKit

extension Montage {
    public enum Elevation: Equatable {
        case none
        case shadowNormal
        case shadowEmphasize
        case shadowStrong
        case shadowHeavy
    }
}

extension Montage.Elevation {
    struct Descriptor {
        let offset: CGSize
        let blur: CGFloat
        let color: UIColor?
        let alpha: CGFloat
    }
    
    var descriptor: Descriptor {
        let shadowColor = UIColor.alias(.staticBlack)
        
        switch self {
        case .none:
            return .init(offset: .init(width: 0, height: -3), blur: 0, color: nil, alpha: 0)
        case .shadowNormal:
            return .init(offset: .init(width: 0, height: 1), blur: 2, color: shadowColor, alpha: 0.16)
        case .shadowEmphasize:
            return .init(offset: .init(width: 0, height: 2), blur: 8, color: shadowColor, alpha: 0.16)
        case .shadowStrong:
            return .init(offset: .init(width: 0, height: 4), blur: 12, color: shadowColor, alpha: 0.22)
        case .shadowHeavy:
            return .init(offset: .init(width: 0, height: 8), blur: 24, color: shadowColor, alpha: 0.28)
        }
    }
}
