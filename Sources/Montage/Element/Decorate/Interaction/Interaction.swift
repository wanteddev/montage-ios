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
        
        public enum Varient {
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
        
        var varient: Varient {
            didSet {
                updateView()
            }
        }
        
        init(state: State = .normal, color: Color.Alias = .labelNormal, varient: Varient = .normal) {
            self.state = state
            self.color = color
            self.varient = varient
            
            super.init(frame: .zero)
            
            setupView()
        }
        
        required init?(coder: NSCoder) {
            self.state = .normal
            self.color = .labelNormal
            self.varient = .normal
            
            super.init(coder: coder)
            
            setupView()
        }
    }
}

extension Decorate.Interaction {
    private func setupView() {
        isUserInteractionEnabled = false
        alpha = state.alpha * varient.weight
        backgroundColor = .alias(self.color)
    }
    
    private func updateView() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut]
        ) { [self] in
            self.alpha = state.alpha * varient.weight
            self.backgroundColor = .alias(color)
        }
    }
}

extension Decorate.Interaction.State {
    var alpha: CGFloat {
        switch self {
        case .normal:
            return 0
        case .hovered:
            return 0.05
        case .focused:
            return 0.08
        case .pressed:
            return 0.12
        }
    }
}

extension Decorate.Interaction.Varient {
    var weight: CGFloat {
        switch self {
        case .normal:
            return 1
        case .light:
            return 0.75
        case .strong:
            return 1.5
        }
    }
}
