//
//  Interaction.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/06.
//

import UIKit

extension Decorate {
    public final class InteractionUIView: UIView {
        var state: Interaction.State {
            didSet {
                updateView()
            }
        }
        
        var color: Color.Alias {
            didSet {
                updateView()
            }
        }
        
        var variant: Interaction.Variant {
            didSet {
                updateView()
            }
        }
        
        init(
            state: Interaction.State = .normal,
            color: Color.Alias = .labelNormal,
            variant: Interaction.Variant = .normal
        ) {
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

extension Decorate.InteractionUIView {
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
