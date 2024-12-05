//
//  Interaction.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/06.
//

import UIKit

extension Decorate {
    public final class Interaction: UIView {
        public enum State {
            case normal, hovered, focused, pressed
        }
        
        public enum Variant {
            case normal, light, strong
        }
        
        var state: State {
            didSet {
                updateView()
            }
        }
        
        var color: Color.Alias {
            didSet {
                updateView()
            }
        }
        
        var variant: Variant {
            didSet {
                updateView()
            }
        }
        
        init(state: State = .normal, color: Color.Alias = .labelNormal, variant: Variant = .normal) {
            self.state = state
            self.color = color
            self.variant = variant
            
            super.init(frame: .zero)
            
            setupView()
        }
        
        required init?(coder: NSCoder) {
            state = .normal
            color = .labelNormal
            variant = .normal
            
            super.init(coder: coder)
            
            setupView()
        }
    }
}

extension Decorate.Interaction {
    private func setupView() {
        isUserInteractionEnabled = false
        alpha = state.alpha * variant.weight
        backgroundColor = .alias(color)
    }
    
    private func updateView() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut]
        ) { [self] in
            alpha = state.alpha * variant.weight
            backgroundColor = .alias(color)
        }
    }
}

extension Decorate.Interaction.State {
    var alpha: CGFloat {
        switch self {
        case .normal:
            0
        case .hovered:
            0.05
        case .focused:
            0.08
        case .pressed:
            0.12
        }
    }
}

extension Decorate.Interaction.Variant {
    var weight: CGFloat {
        switch self {
        case .normal:
            1
        case .light:
            0.75
        case .strong:
            1.5
        }
    }
}
