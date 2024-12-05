//
//  Check.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import UIKit

/// ``Montage/Check``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol CheckControlDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter check: 터치가 발생한 객체
    func didTappedCheck(_ check: Control.Check)
}

extension Control {
    /// 체크 이미지를 표현하는 Control Element 입니다. ``MontageControl``의 일부만을 표현할 수 있습니다.
    public final class Check: UIView, MontageControl {
        private let boxView = UIView()
        
        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.isUserInteractionEnabled = false
            view.tintColor = .alias(.labelAssistive)
            view.image = .montage(.checkThick)
            return view
        }()
        
        /// Control Element의 모양을 표현하기 위한 상태값입니다.
        /// `.indeterminate` 상태는 지원하지 않으며, 해당 상태로 설정할 경우 자동으로 `.checked` 상태로 변경후 설정됩니다.
        public var state: MontageControlState = .unchecked {
            didSet {
                if state == .indeterminate {
                    #warning("Can't use .indeterminate type on NestedCheck element. Must use .checked type.")
                    state = .checked
                }
                updateViews()
            }
        }
        
        public var disable = false {
            didSet {
                updateViews()
            }
        }
        
        public let size: MontageControlSize
        private let interactionView = Decorate.Interaction()
                
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        public weak var delegate: CheckControlDelegate?
        
        public init(size: MontageControlSize = .normal) {
            self.size = size
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateViews()
            }
        }
        
        /// Element의 기본적인 사이즈를 정의합니다.
        override public var intrinsicContentSize: CGSize {
            containerSize
        }
    }
}

extension Control.Check {
    private func setupViews() {
        addSubview(boxView)
        addSubview(interactionView)
        
        boxView.addSubview(imageView)
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        interactionView.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: containerSize.width).isActive = true
        heightAnchor.constraint(equalToConstant: containerSize.height).isActive = true
        
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: boxInsets.left).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -boxInsets.right).isActive = true
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: boxInsets.top).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -boxInsets.bottom).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: imageInsets.left)
            .isActive = true
        imageView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -imageInsets.right)
            .isActive = true
        imageView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: imageInsets.top).isActive = true
        imageView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -imageInsets.bottom)
            .isActive = true
        
        interactionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        interactionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        interactionView.widthAnchor.constraint(equalToConstant: interactionSize.width).isActive = true
        interactionView.heightAnchor.constraint(equalToConstant: interactionSize.height).isActive = true
        
        updateViews()
    }
    
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        boxView.layer.opacity = .opacity(disable ? .p043 : .p100)
        
        switch state {
        case .unchecked:
            imageView.tintColor = .alias(.labelAssistive)
        case .checked, .indeterminate:
            imageView.tintColor = .alias(.primaryNormal)
        }
        
        interactionView.variant = .normal
        interactionView.layer.cornerRadius = interactionSize.width / 2
    }
    
    private func bindEvent() {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
    }
    
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interactionView.state = .pressed
        case .changed:
            // 스크롤 시 버튼이 눌리지 않도록 state를 normal로 변경
            // 3D touch 모델은 스크롤 하지 않아도 changed가 실행되서 적용하지 않음
            if traitCollection.forceTouchCapability != UIForceTouchCapability.available {
                interactionView.state = .normal
            }
        case .ended:
            guard interactionView.state == .pressed else { return }
            interactionView.state = .normal
            state = switch state {
            case .checked: .unchecked
            case .indeterminate, .unchecked: .checked
            }
            delegate?.didTappedCheck(self)
        default:
            break
        }
    }
}

extension Control.Check {
    var containerSize: CGSize {
        switch size {
        case .normal:
            .init(width: 24, height: 24)
        case .small:
            .init(width: 20, height: 20)
        }
    }
    
    var boxInsets: UIEdgeInsets {
        .zero
    }
    
    var imageInsets: UIEdgeInsets {
        .zero
    }
    
    var cornerRadius: CGFloat {
        .zero
    }
    
    var interactionSize: CGSize {
        switch size {
        case .normal:
            .init(width: 32, height: 32)
        case .small:
            .init(width: 28, height: 28)
        }
    }
}

extension Control.Check: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
