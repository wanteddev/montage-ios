//
//  Divider.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/09.
//

import UIKit

public extension Montage {
    /// 구획을 나누기 위해 사용되는 Element입니다.
    class Divider: UIView {
        public enum Weight {
            case thick, normal
        }
        
        var weight: Weight
        var isVertical: Bool
        
        /// 새로운 Divider를 생성합니다.
        /// - Parameters:
        ///   - weight: Divider의 두께를 결정합니다.
        ///   - isVertical: Divider의 축을 결정합니다. true일 경우 세로 방향으로 폭에 대한 제약 조건이 설정됩니다. false일 경우 가로 방향으로 높이에 대한 제약 조건이 설정됩니다.
        public init(weight: Weight = .normal, isVertical: Bool = false) {
            self.weight = weight
            self.isVertical = isVertical
            
            super.init(frame: .zero)
            
            setupView()
        }
        
        required init?(coder: NSCoder) {
            self.weight = .normal
            self.isVertical = false
            
            super.init(coder: coder)
            
            setupView()
        }
    }
}

extension Montage.Divider {
    private func setupView() {
        if isVertical {
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        } else {
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
        if weight == .normal {
            backgroundColor = .alias(.lineNormal)
        } else {
            backgroundColor = .alias(.lineAlternative)
        }
    }
}
