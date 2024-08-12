//
//  ActionChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// 액션을 설정하거나 실행(이동, 추가, 삭제)합니다.
    public class Action: UIView {
        /// 칩의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case filled, outlined
        }
        
        /// 칩의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case normal, xsmall, small, large
        }
        
        /// 칩의 외관입니다.
        public var variant: Variant = .filled {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 사이즈입니다.
        public var size: Size = .normal {
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
        public var leftIcon: Icon? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var rightIcon: Icon? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 칩에서 표현될 텍스트입니다.
        public var text: String = "" {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 터치 활성화 여부입니다.
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }

        /// 칩의 선택 여부 입니다.
        public var active: Bool = false {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var iconUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var backgroundUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 텍스트 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var fontUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 선택 시 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var activeUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }

        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var leftIconView = UIImageView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var rightIconView = UIImageView()
        
        private lazy var interaction = Decorate.Interaction()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        public init() {
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        required init?(coder: NSCoder) {
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
        
        /// Element의 기본적인 사이즈를 정의합니다.
        override public var intrinsicContentSize: CGSize {
            let textSize = getAttributedText().size()
            let iconSize = size.iconSize
            let edgeInsets = size.edgeInsets
            let iconCount = [leftIcon, rightIcon].filter({ $0 != nil }).count
            let iconWidths = iconSize.width * CGFloat(iconCount)
            let spacings = size.gap * CGFloat(iconCount)
            
            return .init(
                width: iconWidths + spacings + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.Action {
    private func setupViews() {
        addSubview(stackView)
        addSubview(interaction)
        
        setupStackView()
        setupInteraction()
        setupUpdateableConstraints()
        
        updateViews()
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
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = size.gap
        stackView.addArrangedSubview(leftIconView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(rightIconView)
    }
    
    private func setupInteraction() {
        interaction.variant = .normal
        
        setupInteractionContraints()
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewConstraints()
        setupStackViewConstraints()
        stackView.spacing = size.gap
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
            stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: insets.left),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -insets.right),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: insets.top),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -insets.bottom),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        constraints.forEach({ $0.priority = .defaultLow })
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = size.cornerRadius
        layer.masksToBounds = true
    }
}

extension Chip.Action {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = resolveBackgroundColor()
        layer.borderColor = resolveCurrentLineColor()
        layer.borderWidth = variant.borderWidth
        leftIconView.tintColor = resolveCurrentIconColor()
        rightIconView.tintColor = resolveCurrentIconColor()
        interaction.color = resolveInteractionColor()
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
        textLabel.attributedText = getAttributedText()
    }
    
    private func getAttributedText() -> NSAttributedString {
        ._montage(
            text,
            variant: size.typoVariant,
            weight: .medium,
            color: currentTextUIColor()
        )
    }
}

extension Chip.Action {
    private func resolveBackgroundColor() -> UIColor {
        if disable {
            return variant.disableBackgroundColor
        } else if active {
            if let activeUIColor {
                return activeUIColor
            } else {
                return variant.activeBackgroundColor
            }
        } else {
            if let backgroundUIColor {
                return backgroundUIColor
            } else {
               return  variant.backgroundColor
            }
        }
    }
    
    private func currentTextUIColor() -> UIColor {
        if disable {
            return .alias(.labelDisable)
        } else if active {
            return variant.activeTextUIColor
        } else {
            if let fontUIColor {
                return fontUIColor
            } else {
                return .alias(.labelNormal)
            }
        }
    }
    
    private func resolveCurrentLineColor() -> CGColor {
        guard variant == .outlined else { return UIColor.clear.cgColor }
        if active {
            return UIColor.alias(.primaryNormal).withAlphaComponent(0.43).cgColor
        } else {
            return UIColor.alias(.lineNeutral).cgColor
        }
    }
    
    private func resolveCurrentIconColor() -> UIColor {
        if let iconUIColor {
            return iconUIColor
        } else {
            return .alias(.labelAlternative)
        }
    }
    
    private func resolveInteractionColor() -> Color.Alias {
        if active, variant == .outlined {
            return .primaryNormal
        } else {
            return .labelNormal
        }
    }
}

extension Chip.Action {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interaction.state = .pressed
        case .changed:
            // 스크롤 시 버튼이 눌리지 않도록 state를 normal로 변경
            // 3D touch 모델은 스크롤 하지 않아도 changed가 실행되서 적용하지 않음
            if traitCollection.forceTouchCapability != UIForceTouchCapability.available {
                interaction.state = .normal
            }
        case .ended:
            guard interaction.state == .pressed else { return }
            if let view = recognizer.view, view.bounds.contains(recognizer.location(in: recognizer.view)) {
                handler?()
            }
            interaction.state = .normal
        default:
            break
        }
    }
}

extension Chip.Action: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension Chip.Action.Variant {
    var backgroundColor: UIColor {
        switch self {
        case .filled:
            return .component(.fillAlternative)
        case .outlined:
            return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .filled:
            return 0
        case .outlined:
            return 1
        }
    }
    
    var disableBackgroundColor: UIColor {
        switch self {
        case .filled:
            return .alias(.interactionDisable)
        case .outlined:
            return .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .filled:
            return .alias(.inverseBackground)
        case .outlined:
            return .alias(.primaryNormal).withAlphaComponent(0.05)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .filled:
            return .alias(.inverseLabel)
        case .outlined:
            return .alias(.primaryNormal)
        }
    }
}

extension Chip.Action.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            return .init(width: 16, height: 16)
        case .normal:
            return .init(width: 14, height: 14)
        case .small:
            return .init(width: 14, height: 14)
        case .xsmall:
            return .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            return .body2
        case .normal:
            return .label1
        case .small:
            return .label1
        case .xsmall:
            return .caption1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return .init(top: 9, left: 12, bottom: 9, right: 12)
        case .normal:
            return .init(top: 7, left: 12, bottom: 7, right: 12)
        case .small:
            return .init(top: 6, left: 10, bottom: 6, right: 10)
        case .xsmall:
            return .init(top: 4, left: 6, bottom: 4, right: 6)
        }
    }
    
    var gap: CGFloat {
        switch self {
        case .large:
            return 6
        case .normal:
            return 4
        case .small:
            return 4
        case .xsmall:
            return 4
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            return 10.0
        case .normal:
            return 8.0
        case .small:
            return 8.0
        case .xsmall:
            return 6.0
        }
    }
}
