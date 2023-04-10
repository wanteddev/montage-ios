//
//  RoundButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/05.
//

import UIKit

/// ``RoundButton``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol RoundButtonDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter checkbox: 터치가 발생한 객체
    func didTappedRoundButton(_ roundButton: RoundButton)
}

/// 외곽선 또는 배경으로 둘러 싸인 곡선 모서리 버튼입니다.
/// [Figma](https://www.figma.com/file/NzeCJaXMkqRBlRd9CZCx8j/0-Component?node-id=1174%3A12997&t=5otLCYvozBpnxZ7j-1) 에서 모양을 미리 확인할 수 있습니다.
public class RoundButton: UIView {
    /// 버튼의 외관을 결정하는 열거형입니다.
    public enum Varient {
        case primary, secondary, alternative, assistive
    }
    
    /// 버튼의 사이즈를 결정하는 열거형입니다.
    public enum Size {
        case large, medium, small
    }
    
    /// 버튼의 외관입니다.
    public var varient: Varient = .primary {
        didSet {
            updateViews()
        }
    }
    
    /// 버튼의 사이즈입니다.
    /// > Important: Varient이 Assistive일 경우 .large를 사용할 수 없습니다.
    public var size: Size = .large {
        didSet {
            setupUpdateableConstraints()
            updateViews()
        }
    }
    
    /// 사용자와의 인터렉션 상태를 표현합니다.
    public var state: Decorate.Interaction.State = .normal {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 좌측에 표현될 아이콘입니다.
    public var leftIcon: Icon? {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 우측에 표현될 아이콘입니다.
    public var rightIcon: Icon? {
        didSet {
            updateViews()
        }
    }
    
    /// 버튼에서 표현될 텍스트입니다.
    public var text: String = "" {
        didSet {
            updateViews()
        }
    }
    
    private lazy var stackView = UIStackView()
    
    private lazy var leftIconView = UIImageView()
    
    private lazy var textLabel = UILabel()
    
    private lazy var rightIconView = UIImageView()
    
    private lazy var interaction = Decorate.Interaction()
    
    private var tapRecognizer: UITapGestureRecognizer?
    
    private var longPressRecognizer: UILongPressGestureRecognizer?
    
    private var iconViewContraints: [NSLayoutConstraint] = []
    
    private var stackViewConstraints: [NSLayoutConstraint] = []
    
    private weak var delegate: RoundButtonDelegate?
    
    /// RoundButton 객체를 생성합니다.
    public init() {
        super.init(frame: .zero)
        
        setupViews()
        bindEvent()
    }
    
    override public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        bindEvent()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateViews()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayer()
    }
}

extension RoundButton {
    private func setupViews() {
        addSubview(stackView)
        addSubview(interaction)
        
        setupStackView()
        setupInteractionContraints()
        setupUpdateableConstraints()
        
        updateViews()
    }
    
    private func bindEvent() {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(tapGestureRecognizer)
        self.tapRecognizer = tapGestureRecognizer
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .spacing(.pt04)
        stackView.addArrangedSubview(leftIconView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(rightIconView)
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewConstraints()
        setupStackViewConstraints()
        updateConstraints()
        setupLayer()
    }
    
    private func setupInteractionContraints() {
        interaction.translatesAutoresizingMaskIntoConstraints = false
        
        interaction.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        interaction.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        interaction.topAnchor.constraint(equalTo: topAnchor).isActive = true
        interaction.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupIconViewConstraints() {
        NSLayoutConstraint.deactivate(iconViewContraints)
        
        leftIconView.translatesAutoresizingMaskIntoConstraints = false
        rightIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leftIconView.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            leftIconView.heightAnchor.constraint(equalToConstant: size.iconSize.height),
            rightIconView.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            rightIconView.heightAnchor.constraint(equalToConstant: size.iconSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        iconViewContraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = size.edgeInsets
        
        let constraints = [
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

extension RoundButton {
    private func updateViews() {
        updateColors()
        updateIconView()
        updateTextLabel()
    }
    
    private func updateColors() {
        backgroundColor = varient.backgroundColor
        layer.borderColor = varient.borderColor.cgColor
        layer.borderWidth = varient.borderWidth
        leftIconView.tintColor = .alias(varient.textColor)
        rightIconView.tintColor = .alias(varient.textColor)
    }
    
    private func updateIconView() {
        if let leftIcon {
            leftIconView.isHidden = false
            leftIconView.image = .montage(leftIcon)
        } else {
            leftIconView.isHidden = true
        }
        
        if let rightIcon {
            rightIconView.isHidden = false
            rightIconView.image = .montage(rightIcon)
        } else {
            rightIconView.isHidden = true
        }
    }
    
    private func updateTextLabel() {
        textLabel.attributedText = .montage(
            text,
            varient: size.typoVarient,
            weight: .bold,
            color: varient.textColor
        )
    }
}

extension RoundButton {
    @objc private func tapped() {
        delegate?.didTappedRoundButton(self)
    }
    
    @objc private func longPressed() {
        switch self.longPressRecognizer?.state {
        case .began:
            self.interaction.state = .pressed
        case .ended:
            self.interaction.state = .normal
        default:
            break
        }
    }
}

extension RoundButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension RoundButton.Varient {
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return .alias(.primaryNormal)
        case .secondary, .alternative, .assistive:
            return .alias(.backgroundNormal)
        }
    }
    
    var textColor: Color.Alias {
        switch self {
        case .primary:
            return .staticWhite
        case .secondary, .alternative:
            return .primaryNormal
        case .assistive:
            return .labelNormal
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary:
            return 0
        default:
            return 1
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .primary:
            return .alias(.primaryNormal)
        case .secondary, .assistive:
            return .alias(.lineNormal)
        case .alternative:
            return .alias(.primaryNormal)
        }
    }
}

extension RoundButton.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            return .init(width: 20, height: 20)
        case .medium:
            return .init(width: 18, height: 18)
        case .small:
            return .init(width: 16, height: 16)
        }
    }
    
    var typoVarient: Typography.Variant {
        switch self {
        case .large:
            return .body1
        case .medium:
            return .body2
        case .small:
            return .label1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return .init(top: 12, left: 28, bottom: 12, right: 28)
        case .medium:
            return .init(top: 9, left: 20, bottom: 9, right: 20)
        case .small:
            return .init(top: 7, left: 12, bottom: 7, right: 12)
        }
    }
}
