//
//  MontageSwitch.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import UIKit

public protocol MontageSwitchDelegate: AnyObject {
    func didValueChangedSwitch(_ switch: Montage.Switch)
}

public extension Montage {
    final class Switch: UISwitch {
        public weak var delegate: MontageSwitchDelegate?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupViews()
            bindEvent()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            setupViews()
            bindEvent()
        }
    }
}

extension Montage.Switch {
    private func setupViews() {
        tintColor = .component(.fillNormal)
        onTintColor = .alias(.primaryNormal)
    }
    
    private func bindEvent() {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        delegate?.didValueChangedSwitch(self)
    }
}
