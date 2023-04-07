//
//  Interaction.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/06.
//

import UIKit

public final class Interaction: UIView {
    public enum State {
        case normal, hovered, focused, pressed
    }
    
    var state: State {
        didSet {
            debugPrint(">>> new state: \(String(describing: state))")
            updateView()
        }
    }
    
    var color: Color.Alias {
        didSet {
            debugPrint(">>> new color: \(String(describing: color))")
            updateView()
        }
    }
    
    init(state: State = .normal, color: Color.Alias = .labelNormal) {
        self.state = state
        self.color = color
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.state = .normal
        self.color = .labelNormal
        
        super.init(coder: coder)
        
        setupView()
    }
}

extension Interaction {
    private func setupView() {
        isUserInteractionEnabled = false
        alpha = state.alpha
        backgroundColor = .alias(self.color)
    }
    
    private func updateView() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut]
        ) { [self] in
            self.alpha = state.alpha
            self.backgroundColor = .alias(color)
        }
    }
}

extension Interaction.State {
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
