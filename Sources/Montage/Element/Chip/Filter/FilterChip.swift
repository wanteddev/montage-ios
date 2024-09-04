//
//  ActionChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// 액션을 설정하거나 실행(이동, 추가, 삭제)합니다.
    public class Filter: UIView {
        /// 칩의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case filled, outlined
        }
        
        /// 칩의 확장 상태를 나타내는 열거형입니다.
        public enum State {
            case normal
            case expand
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
        
        /// 칩의 확장 상태입니다.
        public var state: State = .normal {
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
        public var interactionState: Decorate.Interaction.State = .normal {
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
        
        /// 칩의 선택 여부입니다.
        public var active: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 활성화 여부입니다.
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var iconUIColor: UIColor? {
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

        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var arrowIconView = UIImageView()
        
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
            let spacings = size.gap
            
            return .init(
                width: iconSize.width + spacings + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.Filter {
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
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = size.gap
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(arrowIconView)
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
        
        arrowIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            arrowIconView.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            arrowIconView.heightAnchor.constraint(equalToConstant: size.iconSize.height)
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

extension Chip.Filter {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = resolveCurrnetBackgroundColor()
        layer.borderColor = resolveCurrentLineColor()
        layer.borderWidth = variant.borderWidth
        arrowIconView.tintColor = resolveArrowIconTintColor()
        interaction.color = resolveInteractionColor()
        updateTextLabel()
    }
    
    private func updateIconView() {
        arrowIconView.isHidden = false
        arrowIconView.image = .montage(state.icon)
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

extension Chip.Filter {
    private func resolveCurrnetBackgroundColor() -> UIColor {
        if disable {
            return variant.disableBackgroundColor
        } else if active {
            return variant.activeBackgroundColor
        } else {
            return variant.backgroundColor
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
    
    private func resolveArrowIconTintColor() -> UIColor {
        if disable {
            return .alias(.labelDisable)
        } else if active {
            return variant.activeArrowColor
        } else {
            if let iconUIColor {
                return iconUIColor
            } else {
                return .alias(.labelNormal)
            }
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

extension Chip.Filter {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interaction.state = .pressed
        case .ended:
            if let view = recognizer.view, view.bounds.contains(recognizer.location(in: recognizer.view)) {
                handler?()
            }
            interaction.state = .normal
        default:
            break
        }
    }
}

extension Chip.Filter.Variant {
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
            return .zero
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
    
    var activeArrowColor: UIColor {
        switch self {
        case .filled:
            return .alias(.inverseLabel)
        case .outlined:
            return .alias(.labelNormal)
        }
    }
}

extension Chip.Filter.State {
    var icon: Icon {
        switch self {
        case .normal:
            return .caretDown
        case .expand:
            return .caretUp
        }
    }
}

extension Chip.Filter.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            return .init(width: 16, height: 16)
        case .normal:
            return .init(width: 16, height: 16)
        case .small:
            return .init(width: 16, height: 16)
        case .xsmall:
            return .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            return .body2
        case .normal:
            return .body2
        case .small:
            return .label1
        case .xsmall:
            return .caption1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return .init(top: 9, left: 12, bottom: 9, right: 8)
        case .normal:
            return .init(top: 7, left: 12, bottom: 7, right: 8)
        case .small:
            return .init(top: 6, left: 10, bottom: 6, right: 8)
        case .xsmall:
            return .init(top: 4, left: 8, bottom: 4, right: 6)
        }
    }
    
    var gap: CGFloat {
        switch self {
        case .large:
            return 5.0
        case .normal:
            return 5.0
        case .small:
            return 4.0
        case .xsmall:
            return 2.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            return 10.0
        case .normal:
            return 10.0
        case .small:
            return 8.0
        case .xsmall:
            return 6.0
        }
    }
}

