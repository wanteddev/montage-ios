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
            case solid, outlined
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
        public var variant: Variant = .solid {
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
        public var text = "" {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 선택 여부입니다.
        public var active = false {
            didSet {
                updateViews()
            }
        }
        
        /// 칩 선택시 표시될 텍스트입니다.
        /// 값이 있는 경우에 표시되며 기본값은 칩의 텍스트가 표현됩니다.
        public var activeLabel: String? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 활성화 여부입니다.
        public var disable = false {
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
        
        private let contentsWrapperView = UIView()
        
        private lazy var stackView = UIStackView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var arrowIconView = UIImageView()
        
        private lazy var interaction = Decorate.Interaction()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var contentsWrapperViewConstraints: [NSLayoutConstraint] = []
        
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
        
        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            updateViews()
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            
            setupLayer()
        }
        
        /// Element의 기본적인 사이즈를 정의합니다.
        override public var intrinsicContentSize: CGSize {
            let textSize = getAttributedText().size()
            let iconSize = size.iconSize
            let edgeInsets = size.contentsEdgeInsets
            let spacings = size.contentsGap
            let paddings = size.contentsPadding * 2
            
            return .init(
                width: iconSize.width + spacings + textSize.width + edgeInsets.horizontal + paddings,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.Filter {
    private func setupViews() {
        addSubview(contentsWrapperView)
        addSubview(interaction)
        contentsWrapperView.addSubview(stackView)
        
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
        stackView.spacing = size.contentsGap
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(arrowIconView)
    }
    
    private func setupInteraction() {
        interaction.variant = .normal
        
        setupInteractionContraints()
    }
    
    private func setupUpdateableConstraints() {
        setupContentsWrapperViewConstraints()
        setupStackViewConstraints()
        setupIconViewConstraints()
        stackView.spacing = size.contentsGap
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
    
    private func setupContentsWrapperViewConstraints() {
        NSLayoutConstraint.deactivate(contentsWrapperViewConstraints)
        
        contentsWrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = size.contentsEdgeInsets
        
        let constraints = [
            contentsWrapperView.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            contentsWrapperView.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            contentsWrapperView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentsWrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        
        constraints.forEach { $0.priority = .defaultLow }
        NSLayoutConstraint.activate(constraints)
        contentsWrapperViewConstraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentsPadding = size.contentsPadding
        
        let constraints = [
            stackView.leftAnchor.constraint(
                equalTo: contentsWrapperView.leftAnchor,
                constant: contentsPadding
            ),
            stackView.rightAnchor.constraint(
                equalTo: contentsWrapperView.rightAnchor,
                constant: -contentsPadding
            ),
            stackView.topAnchor.constraint(equalTo: contentsWrapperView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentsWrapperView.bottomAnchor)
        ]
        
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
        if active, let activeLabel {
            ._montage(
                activeLabel,
                variant: size.typoVariant,
                weight: .medium,
                color: currentTextUIColor()
            )
        } else {
            ._montage(
                text,
                variant: size.typoVariant,
                weight: .medium,
                color: currentTextUIColor()
            )
        }
    }
}

extension Chip.Filter {
    private func resolveCurrnetBackgroundColor() -> UIColor {
        if disable {
            variant.disableBackgroundColor
        } else if active {
            variant.activeBackgroundColor
        } else {
            variant.backgroundColor
        }
    }

    private func currentTextUIColor() -> UIColor {
        if disable {
            .alias(.labelDisable)
        } else if active {
            variant.activeTextUIColor
        } else {
            if let fontUIColor {
                fontUIColor
            } else {
                .alias(.labelNormal)
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
            .alias(.labelDisable)
        } else if active {
            variant.activeArrowColor
        } else {
            if let iconUIColor {
                iconUIColor
            } else {
                .alias(.labelNormal)
            }
        }
    }
    
    private func resolveInteractionColor() -> Color.Alias {
        if active, variant == .outlined {
            .primaryNormal
        } else {
            .labelNormal
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
        case .solid:
            .component(.fillAlternative)
        case .outlined:
            .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .solid:
            .zero
        case .outlined:
            1
        }
    }
    
    var disableBackgroundColor: UIColor {
        switch self {
        case .solid:
            .alias(.interactionDisable)
        case .outlined:
            .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseBackground)
        case .outlined:
            .alias(.primaryNormal).withAlphaComponent(0.05)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseLabel)
        case .outlined:
            .alias(.primaryNormal)
        }
    }
    
    var activeArrowColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseLabel)
        case .outlined:
            .alias(.labelNormal)
        }
    }
}

extension Chip.Filter.State {
    var icon: Icon {
        switch self {
        case .normal:
            .caretDown
        case .expand:
            .caretUp
        }
    }
}

extension Chip.Filter.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            .init(width: 16, height: 16)
        case .normal:
            .init(width: 16, height: 16)
        case .small:
            .init(width: 16, height: 16)
        case .xsmall:
            .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            .body2
        case .normal:
            .body2
        case .small:
            .label1
        case .xsmall:
            .caption1
        }
    }
    
    var contentsEdgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            .init(top: 9, left: 12, bottom: 9, right: 10)
        case .normal:
            .init(top: 7, left: 11, bottom: 7, right: 9)
        case .small:
            .init(top: 6, left: 8, bottom: 6, right: 6)
        case .xsmall:
            .init(top: 4, left: 7, bottom: 4, right: 5)
        }
    }
    
    var contentsGap: CGFloat {
        switch self {
        case .large:
            2.0
        case .normal:
            2.0
        case .small:
            1.0
        case .xsmall:
            1.0
        }
    }
    
    var contentsPadding: CGFloat {
        switch self {
        case .normal: 2.0
        case .small: 2.0
        case .large: 2.0
        case .xsmall: 1.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            10.0
        case .normal:
            10.0
        case .small:
            8.0
        case .xsmall:
            6.0
        }
    }
}
