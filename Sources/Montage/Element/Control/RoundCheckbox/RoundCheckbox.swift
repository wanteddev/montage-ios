//
//  RoundCheckbox.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/09/07.
//

import UIKit

/// ``Montage/RoundCheckbox``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol RoundCheckboxControlDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter checkbox: 터치가 발생한 객체
    func didTappedCheckbox(_ checkbox: Control.RoundCheckbox)
}

extension Control {
    /// 원형으로 둘러진 체크 모양을 표현하는 Control Element입니다. ``MontageControl``의 모든 상태를 표현할 수 있습니다.
    public class RoundCheckbox: UIView, MontageControl {
        private enum Const {
            static let wrapperBoxSize: CGSize = .init(width: 24, height: 24)
        }
        
        /// 체크박스의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case normal, small
        }
        
        private lazy var boxView = UIView()
        
        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.isUserInteractionEnabled = false
            view.tintColor = .alias(.staticWhite)
            return view
        }()
        
        /// Control Element의 모양을 표현하기 위한 상태값입니다.
        public var state: MontageControlState = .unchecked {
            didSet {
                updateViews()
            }
        }
        
        public var size: Size = .normal {
            didSet {
                updateViews()
            }
        }
        
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        private var containerConstraints: [NSLayoutConstraint] = []
        
        private var boxViewConstraints: [NSLayoutConstraint] = []
        
        private var tapRecognizer: UITapGestureRecognizer?
        
        private weak var delegate: RoundCheckboxControlDelegate?
        
        /// Checkbox 객체를 생성합니다.
        /// - Parameter delegate: Checkbox 버튼을 Element 단독으로 사용할 경우 이벤트를 받을 delegate 객체입니다.
        public init(delegate: RoundCheckboxControlDelegate? = nil) {
            super.init(frame: .zero)
            self.delegate = delegate
            
            setupViews()
            bindEvent()
        }
        
        override public required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupViews()
            bindEvent()
        }
        
        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateViews()
            }
        }
        
        /// Element의 기본적인 사이즈를 정의합니다.
        override public var intrinsicContentSize: CGSize {
            Const.wrapperBoxSize
        }
    }
}

extension Control.RoundCheckbox {
    private func setupViews() {
        addSubview(boxView)
        boxView.addSubview(imageView)
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupContainerConstraints()
        setupBoxViewConstraints()
        
        imageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 2).isActive = true
        imageView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -2).isActive = true
        imageView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 2).isActive = true
        imageView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -2).isActive = true
        
        updateViews()
    }
    
    private func setupUpdateableConstraints() {
        setupContainerConstraints()
        setupBoxViewConstraints()
        updateConstraints()
    }
    
    private func setupContainerConstraints() {
        NSLayoutConstraint.deactivate(containerConstraints)
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.containerSize.width),
            heightAnchor.constraint(equalToConstant: size.containerSize.height)
        ]
        
        containerConstraints = constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupBoxViewConstraints() {
        NSLayoutConstraint.deactivate(boxViewConstraints)
        
        let constraints = [
            boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: size.boxInsets.left),
            boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -size.boxInsets.right),
            boxView.topAnchor.constraint(equalTo: topAnchor, constant: size.boxInsets.top),
            boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -size.boxInsets.bottom)
        ]
        
        boxViewConstraints = constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bindEvent() {
        guard delegate != nil else { return }
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(recognizer)
        tapRecognizer = recognizer
    }
    
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        boxView.layer.cornerRadius = size.cornerRadius
        boxView.layer.borderWidth = 1.5
        boxView.layer.backgroundColor = resolveCurrentBackgroundColor()
        boxView.layer.borderColor = resolveCurrentBorderColor()
        imageView.image = resolveCurrentImage()
    }
    
    @objc private func tapped() {
        delegate?.didTappedCheckbox(self)
    }
}

extension Control.RoundCheckbox {
    private func resolveCurrentBackgroundColor() -> CGColor? {
        let opacity: CGFloat = .opacity(disable ? .p043 : .p100)
        
        switch state {
        case .unchecked:
            return nil
        case .checked, .partial:
            return UIColor.alias(.primaryNormal).withAlphaComponent(opacity).cgColor
        }
    }
    
    private func resolveCurrentBorderColor() -> CGColor {
        let opacity: CGFloat = .opacity(disable ? .p043 : .p100)
        
        switch state {
        case .unchecked:
            return UIColor.alias(.lineNormal).withAlphaComponent(opacity).cgColor
        case .checked, .partial:
            return UIColor.alias(.primaryNormal).withAlphaComponent(opacity).cgColor
        }
    }
    
    private func resolveCurrentImage() -> UIImage? {
        switch state {
        case .unchecked:
            return nil
        case .checked:
            return .montage(.checkThick)
        case .partial:
            return .montage(.lineHorizontalThick)
        }
    }
}

extension Control.RoundCheckbox.Size {
    var containerSize: CGSize {
        switch self {
        case .normal:
            return .init(width: 24, height: 24)
        case .small:
            return .init(width: 20, height: 20)
        }
    }
    
    var boxInsets: UIEdgeInsets {
        switch self {
        case .normal:
            return .init(top: 2, left: 2, bottom: 2, right: 2)
        case .small:
            return .init(top: 1, left: 1, bottom: 1, right: 1)
        }
    }
    
    var cornerRadius: CGFloat {
        (containerSize.width - boxInsets.horizontal) / 2
    }
}
