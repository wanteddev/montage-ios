//
//  OutlinedUIButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import UIKit

extension Button {
    /// 외곽선으로 둘러 싸인 곡선 모서리 버튼입니다.
    /// [Figma](https://www.figma.com/file/NzeCJaXMkqRBlRd9CZCx8j/0-Component?node-id=1174%3A12997&t=5otLCYvozBpnxZ7j-1) 에서 모양을 미리 확인할 수 있습니다.
    @available(*, deprecated, message: "Use `Montage.OutlinedButton` instead")
    public class OutlinedUIButton: UIView {
        /// 버튼의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case primary, secondary, assistive
        }
        
        /// 버튼의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case large, medium, small
        }
        
        /// 버튼 모서리의 곡률 스타일을 결정하는 열거형입니다.
        public enum CornerStyle {
            case legacy, `default`
        }
        
        /// 버튼의 외관입니다.
        public var variant: Variant = .primary {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 사이즈입니다.
        /// > Important: Variant이 Assistive일 경우 .large를 사용할 수 없습니다.
        /// > size 설정 시 constraint가 정상적으로 반영됩니다.
        public var size: Size = .large {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 버튼의 모서리 곡률을 결정하는 스타일입니다.
        public var cornerStyle: CornerStyle = .default {
            didSet {
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
        public var leadingIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var trailingIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// iconOnly인 경우 표현될 아이콘입니다.
        public var uniqueIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// uniqueIcon 노출 여부입니다.
        /// > text와 leadingIcon, trailingIcon은 표현되지 않습니다.
        /// > 설정 시 constraint가 업데이트 됩니다.
        public var iconOnly = false {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }

        /// 버튼에서 표현될 텍스트입니다.
        public var text = "" {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 활성화 여부입니다.
        public var disable = false {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var contentUIColor: UIColor? {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var backgroundUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 테두리색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var borderUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var leadingIconView = UIImageView()
        
        private lazy var textLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            return label
        }()
        
        private lazy var trailingIconView = UIImageView()
        
        private lazy var uniqueIconView = UIImageView()
        
        private lazy var interaction = Decorate.InteractionUIView()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        private var panRecognizer: UIPanGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        /// SolidButton 객체를 생성합니다.
        public init() {
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        public required init?(coder: NSCoder) {
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
            let iconSize = size.iconSize(iconOnly)
            let edgeInsets = size.edgeInsets(iconOnly)
            let iconCount = [leadingIcon, trailingIcon, uniqueIcon].filter { $0 != nil }.count
            let iconWidths = iconSize.width * CGFloat(iconCount)
            let spacings = iconOnly ? .zero : size.gap * CGFloat(iconCount)
            
            return .init(
                width: iconWidths + spacings + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Button.OutlinedUIButton {
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
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
        let panRecognizer = UIPanGestureRecognizer()
        panRecognizer.delegate = self
        panRecognizer.addTarget(self, action: #selector(panned))
        self.panRecognizer = panRecognizer
        addGestureRecognizer(panRecognizer)
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = size.gap
        stackView.addArrangedSubview(leadingIconView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(trailingIconView)
        stackView.addArrangedSubview(uniqueIconView)
    }
    
    private func setupInteraction() {
        interaction.variant = variant.interactionVariant
        
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
        
        leadingIconView.translatesAutoresizingMaskIntoConstraints = false
        trailingIconView.translatesAutoresizingMaskIntoConstraints = false
        uniqueIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let size = size.iconSize(iconOnly)
        
        let constraints = [
            leadingIconView.widthAnchor.constraint(equalToConstant: size.width),
            leadingIconView.heightAnchor.constraint(equalToConstant: size.height),
            trailingIconView.widthAnchor.constraint(equalToConstant: size.width),
            trailingIconView.heightAnchor.constraint(equalToConstant: size.height),
            uniqueIconView.widthAnchor.constraint(equalToConstant: size.width),
            uniqueIconView.heightAnchor.constraint(equalToConstant: size.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        iconViewContraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = size.edgeInsets(iconOnly)
        
        let constraints = [
            stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: insets.left),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -insets.right),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: insets.top),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -insets.bottom),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        constraints.forEach { $0.priority = .defaultLow }
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = cornerStyle == .legacy ? frame.height / 2 : size.cornerRadius
        layer.masksToBounds = true
    }
}

extension Button.OutlinedUIButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = {
            if let backgroundUIColor {
                backgroundUIColor
            } else {
                .clear
            }
        }()
        layer.borderColor = {
            if disable {
                UIColor.semantic(.lineNormal).cgColor
            } else {
                if let borderUIColor {
                    borderUIColor.cgColor
                } else {
                    variant.borderColor.cgColor
                }
            }
        }()
        layer.borderWidth = 1.0
        let contentColor: UIColor = {
            if disable {
                .semantic(.labelDisable)
            } else {
                if let contentUIColor {
                    contentUIColor
                } else {
                    .semantic(variant.textColor)
                }
            }
        }()
        leadingIconView.tintColor = contentColor
        trailingIconView.tintColor = contentColor
        uniqueIconView.tintColor = contentColor
        interaction.color = variant.interactionColor
        interaction.variant = variant.interactionVariant
    }
    
    private func updateIconView() {
        if iconOnly {
            if let uniqueIcon {
                leadingIconView.isHidden = true
                trailingIconView.isHidden = true
                
                uniqueIconView.isHidden = false
                uniqueIconView.image = .montage(uniqueIcon)
            }
        } else {
            if let leadingIcon {
                leadingIconView.isHidden = false
                leadingIconView.image = .montage(leadingIcon)
            } else {
                leadingIconView.isHidden = true
            }
            
            if let trailingIcon {
                trailingIconView.isHidden = false
                trailingIconView.image = .montage(trailingIcon)
            } else {
                trailingIconView.isHidden = true
            }
            
            uniqueIconView.isHidden = true
        }
    }
    
    private func updateTextLabel() {
        if iconOnly {
            textLabel.isHidden = true
        } else {
            textLabel.isHidden = false
            textLabel.attributedText = getAttributedText()
        }
    }
    
    private func getAttributedText() -> NSAttributedString {
        ._montage(
            text,
            variant: size.typoVariant,
            weight: variant.typoWeight,
            color: {
                if disable {
                    .semantic(.labelDisable)
                } else {
                    if let contentUIColor {
                        contentUIColor
                    } else {
                        variant.textColor.resolve(.current)
                    }
                }
            }()
        )
    }
}

extension Button.OutlinedUIButton {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interaction.state = .pressed
        case .changed:
            // 스크롤 시 버튼이 눌리지 않도록 state를 normal로 변경
            // 3D touch 모델은 스크롤 하지 않아도 changed가 실행되서 적용하지 않음
            if traitCollection.forceTouchCapability != UIForceTouchCapability.available
                && traitCollection.forceTouchCapability != UIForceTouchCapability.unavailable {
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
    
    @objc private func panned() {
        guard let recognizer = panRecognizer else { return }
        
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self).y
            let height = frame.height
            let location = recognizer.location(in: self).y
            
            if (translation >= 0 && height - location < translation)
                || (translation < 0 && location < -translation)
                || !frame.contains(recognizer.location(in: self)) {
                interaction.state = .normal
            }
        default: break
        }
    }
}

extension Button.OutlinedUIButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension Button.OutlinedUIButton.Variant {
    var textColor: Color.Semantic {
        switch self {
        case .primary, .secondary:
            .primaryNormal
        case .assistive:
            .labelNormal
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .primary, .secondary: .bold
        case .assistive: .medium
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .primary:
            .semantic(.primaryNormal)
        case .secondary:
            .semantic(.lineNeutral).withAlphaComponent(0.16)
        case .assistive:
            .semantic(.lineNeutral).withAlphaComponent(0.16)
        }
    }
    
    var interactionColor: Color.Semantic {
        switch self {
        case .primary:
            .primaryNormal
        case .secondary, .assistive:
            .labelNormal
        }
    }
    
    var interactionVariant: Decorate.Interaction.Variant {
        switch self {
        case .primary:
            .normal
        case .secondary, .assistive:
            .light
        }
    }
}

extension Button.OutlinedUIButton.Size {
    func iconSize(_ isIconOnly: Bool = false) -> CGSize {
        switch self {
        case .large:
            isIconOnly ? .init(width: 24, height: 24) : .init(width: 20, height: 20)
        case .medium:
            isIconOnly ? .init(width: 20, height: 20) : .init(width: 18, height: 18)
        case .small:
            isIconOnly ? .init(width: 18, height: 18) : .init(width: 16, height: 16)
        }
    }

    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            .body1
        case .medium:
            .body2
        case .small:
            .label2
        }
    }
    
    func edgeInsets(_ isIconOnly: Bool = false) -> UIEdgeInsets {
        switch self {
        case .large:
            isIconOnly ? .init(top: 12, left: 12, bottom: 12, right: 12) : .init(
                top: 12,
                left: 28,
                bottom: 12,
                right: 28
            )
        case .medium:
            isIconOnly ? .init(top: 10, left: 10, bottom: 10, right: 10) : .init(
                top: 9,
                left: 20,
                bottom: 9,
                right: 20
            )
        case .small:
            isIconOnly ? .init(top: 7, left: 7, bottom: 7, right: 7) : .init(
                top: 7,
                left: 14,
                bottom: 7,
                right: 14
            )
        }
    }
    
    var gap: CGFloat {
        switch self {
        case .large:
            6.0
        case .medium:
            5.0
        case .small:
            4.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            12.0
        case .medium:
            10.0
        case .small:
            8.0
        }
    }
}
