//
//  Checkbox.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import UIKit

public protocol MontageCheckboxDelegate: AnyObject {
    func didTappedCheckbox(_ checkbox: Montage.Checkbox)
}

public extension Montage {
    class Checkbox: UIView, MontageInput {
        private enum Const {
            static let wrapperBoxSize: CGSize = .init(width: 24, height: 24)
        }
        
        private lazy var boxView = UIView()
        
        private lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.isUserInteractionEnabled = false
            view.tintColor = .alias(.staticWhite)
            return view
        }()
        
        public var state: MontageInputState = .unchecked {
            didSet {
                updateViews()
            }
        }
        
        public var canMultipleSelect: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        private var tapRecognizer = UITapGestureRecognizer()
        
        public weak var delegate: MontageCheckboxDelegate?
        
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
    }
}

extension Montage.Checkbox {
    private func setupViews() {
        addSubview(boxView)
        boxView.addSubview(imageView)
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: Const.wrapperBoxSize.width).isActive = true
        heightAnchor.constraint(equalToConstant: Const.wrapperBoxSize.height).isActive = true
        
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 1).isActive = true
        imageView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -1).isActive = true
        imageView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 1).isActive = true
        imageView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -1).isActive = true
        
        updateViews()
    }
    
    private func bindEvent() {
        tapRecognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    private func updateViews() {
        boxView.layer.cornerRadius = 3.0
        boxView.layer.borderWidth = 1.5
        
        switch state {
        case .unchecked:
            boxView.layer.backgroundColor = nil
            boxView.layer.borderColor = UIColor.alias(.lineNormal).cgColor
            imageView.image = nil
        case .checked:
            boxView.layer.backgroundColor = UIColor.alias(.primaryNormal).cgColor
            boxView.layer.borderColor = UIColor.alias(.primaryNormal).cgColor
            imageView.image = .montage(.checkThick)
        case .partial:
            boxView.layer.backgroundColor = UIColor.alias(.primaryNormal).cgColor
            boxView.layer.borderColor = UIColor.alias(.primaryNormal).cgColor
            imageView.image = .montage(.lineHorizontalThick)
        }
    }
    
    @objc private func tapped() {
        delegate?.didTappedCheckbox(self)
    }
}
