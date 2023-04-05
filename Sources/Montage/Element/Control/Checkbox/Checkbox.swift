//
//  Checkbox.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import UIKit

/// ``Montage/Checkbox``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol CheckboxControlDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter checkbox: 터치가 발생한 객체
    func didTappedCheckbox(_ checkbox: Checkbox)
}

/// 박스로 둘러진 체크 모양을 표현하는 Control Element입니다. ``MontageInputState``의 모든 상태를 표현할 수 있습니다.
public class Checkbox: UIView, MontageInput {
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
    
    /// Control Element의 모양을 표현하기 위한 상태값입니다.
    public var state: MontageInputState = .unchecked {
        didSet {
            updateViews()
        }
    }
    
    private var tapRecognizer: UITapGestureRecognizer?
    
    private weak var delegate: CheckboxControlDelegate?
    
    /// Checkbox 객체를 생성합니다.
    /// - Parameter delegate: Checkbox 버튼을 Element 단독으로 사용할 경우 이벤트를 받을 delegate 객체입니다.
    public init(delegate: CheckboxControlDelegate? = nil) {
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

extension Checkbox {
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
        guard delegate != nil else { return }
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(recognizer)
        tapRecognizer = recognizer
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
