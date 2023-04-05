//
//  Radio.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import UIKit

/// ``Montage/Radio``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol RadioControlDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter radio: 터치가 발생한 객체
    func didTappedRadio(_ radio: Radio)
}

/// 원형 안의 점 모양을 표시하는 Control Element 입니다. ``MontageInputState``의 일부만을 표현할 수 있습니다.
public final class Radio: UIView, MontageInput {
    private enum Const {
        static let wrapperBoxSize: CGSize = .init(width: 24, height: 24)
        static let boxInset: CGFloat = .spacing(.pt02)
    }
    
    /// Control Element의 모양을 표현하기 위한 상태값입니다.
    /// `.partial` 상태는 지원하지 않으며, 해당 상태로 설정할 경우 자동으로 `.checked` 상태로 변경후 설정됩니다.
    public var state: MontageInputState = .unchecked {
        didSet {
            if state == .partial {
                #warning("Can't use .partial type on Radio element. Must use .checked type.")
                state = .checked
            }
            updateViews()
        }
    }
    
    private lazy var boxView = UIView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.tintColor = .alias(.staticWhite)
        return view
    }()
    
    private var tapRecognizer: UITapGestureRecognizer?
    
    private weak var delegate: RadioControlDelegate?
    
    /// Radio 객체를 생성합니다.
    /// - Parameter delegate: Radio 버튼을 Element 단독으로 사용할 경우 이벤트를 받을 delegate 객체입니다.
    public init(delegate: RadioControlDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        
        setupViews()
        bindEvent()
    }
    
    override public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
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

extension Radio {
    private func setupViews() {
        addSubview(boxView)
        boxView.addSubview(imageView)
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor
            .constraint(equalToConstant: Const.wrapperBoxSize.width).isActive = true
        heightAnchor
            .constraint(equalToConstant: Const.wrapperBoxSize.height).isActive = true
        
        boxView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: Const.boxInset).isActive = true
        boxView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -Const.boxInset).isActive = true
        boxView.topAnchor
            .constraint(equalTo: topAnchor, constant: Const.boxInset).isActive = true
        boxView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -Const.boxInset).isActive = true
        
        imageView.leadingAnchor
            .constraint(equalTo: boxView.leadingAnchor, constant: Const.boxInset).isActive = true
        imageView.trailingAnchor
            .constraint(equalTo: boxView.trailingAnchor, constant: -Const.boxInset).isActive = true
        imageView.topAnchor
            .constraint(equalTo: boxView.topAnchor, constant: Const.boxInset).isActive = true
        imageView.bottomAnchor
            .constraint(equalTo: boxView.bottomAnchor, constant: -Const.boxInset).isActive = true
        
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
        boxView.layer.cornerRadius = (Const.wrapperBoxSize.width - (Const.boxInset * 2)) / 2
        boxView.layer.borderWidth = 1.5
        
        switch state {
        case .unchecked:
            boxView.layer.backgroundColor = nil
            boxView.layer.borderColor = UIColor.alias(.lineNormal).cgColor
            imageView.image = nil
        case .checked, .partial:
            boxView.layer.backgroundColor = UIColor.alias(.primaryNormal).cgColor
            boxView.layer.borderColor = UIColor.alias(.primaryNormal).cgColor
            imageView.image = .montage(.dot)
        }
    }
    
    @objc private func tapped() {
        delegate?.didTappedRadio(self)
    }
}
