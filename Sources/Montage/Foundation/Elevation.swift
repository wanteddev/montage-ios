//
//  Elevation.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/16.
//

import UIKit

/// 높낮이의 차이를 표현하기 위한 그림자 타입입니다.
/// `UIView.setElevation(_:)`을 사용하여 레이어에 그림자를 적용할 수 있습니다.
public enum Elevation: Equatable {
    case none
    case shadowNormal
    case shadowEmphasize
    case shadowStrong
    case shadowHeavy
}

extension Elevation {
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
