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
    public class Check: UIView, MontageControl {
        private enum Const {
            static let wrapperBoxSize: CGSize = .init(width: 24, height: 24)
        }
        
        /// Control Element의 모양을 표현하기 위한 상태값입니다.
        /// `.partial` 상태는 지원하지 않으며, 해당 상태로 설정할 경우 자동으로 `.checked` 상태로 변경후 설정됩니다.
        public var state: MontageControlState = .unchecked {
            didSet {
                if state == .partial {
                    #warning("Can't use .partial type on NestedCheck element. Must use .checked type.")
                    state = .checked
                }
                updateViews()
            }
        }
        
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.isUserInteractionEnabled = false
            view.tintColor = .alias(.labelAssistive)
            view.image = .montage(.checkThick)
            return view
        }()
        
        private var tapRecognizer: UITapGestureRecognizer?
        
        private weak var delegate: CheckControlDelegate?
        
        /// Check 객체를 생성합니다.
        /// - Parameter delegate: Check 버튼을 Element 단독으로 사용할 경우 이벤트를 받을 delegate 객체입니다.
        public init(delegate: CheckControlDelegate? = nil) {
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

extension Control.Check {
    private func setupViews() {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: Const.wrapperBoxSize.width).isActive = true
        heightAnchor.constraint(equalToConstant: Const.wrapperBoxSize.height).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        updateViews()
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
        
        switch state {
        case .unchecked:
            imageView.tintColor = .alias(.labelAssistive)
        case .checked, .partial:
            imageView.tintColor = .alias(.primaryNormal)
        }
        
        if disable {
            imageView.tintColor = imageView.tintColor.withAlphaComponent(.opacity(.p060))
        }
    }
    
    @objc private func tapped() {
        delegate?.didTappedCheck(self)
    }
}
