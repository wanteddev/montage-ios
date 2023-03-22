//
//  MontageSwitch.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import UIKit

/// ``Montage/Switch``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol MontageSwitchDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter switch: 터치가 발생한 객체
    func didValueChangedSwitch(_ switch: Montage.Switch)
}

public extension Montage {
    /// ON/OFF 상태를 표시하는 Control Element 입니다. `UISwitch`를 오버라이딩하여 디자인시스템에 맞도록 색상을 변경하고 이벤트를 추가하였습니다.
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
