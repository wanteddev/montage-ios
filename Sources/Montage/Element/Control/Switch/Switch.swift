//
//  MontageSwitch.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import UIKit

/// ``Montage/Switch``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol SwitchControlDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter switch: 터치가 발생한 객체
    func didValueChangedSwitch(_ switch: Control.Switch)
}

extension Control {
    /// ON/OFF 상태를 표시하는 Control Element 입니다. `UISwitch`를 오버라이딩하여 디자인시스템에 맞도록 색상을 변경하고 이벤트를 추가하였습니다.
    public final class Switch: UISwitch {
        public weak var delegate: SwitchControlDelegate?
        
        public enum Size {
            case normal, small
        }
        
        public var disable: Bool = false {
            didSet {
                self.isEnabled = false == disable
            }
        }
        
        public override var isEnabled: Bool {
            didSet {
                print("didSet \(isEnabled)")
            }
        }
        
        private let size: Size
        public init(size: Size = .normal) {
            self.size = size
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Element의 기본적인 사이즈를 정의합니다.
        override public var intrinsicContentSize: CGSize {
            containerSize
        }
    }
}

extension Control.Switch {
    private func setupViews() {
        tintColor = .component(.fillNormal)
        onTintColor = .alias(.primaryNormal)
        
        transform = CGAffineTransform(scaleX: containerSize.width / bounds.width, y: containerSize.height / bounds.height)
        widthAnchor.constraint(equalToConstant: containerSize.width).isActive = true
        heightAnchor.constraint(equalToConstant: containerSize.height).isActive = true
    }
    
    private func bindEvent() {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        delegate?.didValueChangedSwitch(self)
    }
}

extension Control.Switch {
    var containerSize: CGSize {
        switch size {
        case .normal:
            return .init(width: 52, height: 32)
        case .small:
            return .init(width: 39, height: 24)
        }
    }
}
