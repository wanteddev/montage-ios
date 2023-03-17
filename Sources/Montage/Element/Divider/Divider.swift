//
//  Divider.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/09.
//

import UIKit

public extension Montage {
    class Divider: UIView {
        public enum Weight {
            case thick, normal
        }
        
        var weight: Weight
        var isVertical: Bool
        
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
