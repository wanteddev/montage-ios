//
//  NestedCheck.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import UIKit

public protocol MontageCheckDelegate: AnyObject {
    func didTappedCheck(_ check: Montage.NestedCheck)
}

public extension Montage {
    class NestedCheck: UIView, MontageInput {
        private enum Const {
            static let wrapperBoxSize: CGSize = .init(width: 24, height: 24)
        }
        
        public var state: MontageInputState = .unchecked {
            didSet {
                if state == .partial {
                    #warning("Can't use .partial type on NestedCheck element. Must use .checked type.")
                    state = .checked
                }
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
        
        private var tapRecognizer = UITapGestureRecognizer()
        
        public weak var delegate: MontageCheckDelegate?
        
        override public init(frame: CGRect) {
            super.init(frame: frame)
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
        
        override public var intrinsicContentSize: CGSize {
            Const.wrapperBoxSize
        }
    }
}

extension Montage.NestedCheck {
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
        tapRecognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    private func updateViews() {
        switch state {
        case .unchecked:
            imageView.tintColor = .alias(.labelAssistive)
        case .checked, .partial:
            imageView.tintColor = .alias(.primaryNormal)
        }
    }
    
    @objc private func tapped() {
        delegate?.didTappedCheck(self)
    }
}
