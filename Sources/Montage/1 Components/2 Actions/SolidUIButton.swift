//
//  SolidUIButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/05.
//

import UIKit

extension Button {
    /// 배경으로 둘러 싸인 곡선 모서리 버튼입니다.
    ///
    /// 단색 배경과 내부 컨텐츠로 구성된 둥근 모서리 버튼을 제공합니다.
    /// 텍스트, 아이콘 또는 둘의 조합을 표시할 수 있으며, 다양한 상호작용 상태에 대응합니다.
    ///
    /// ```swift
    /// let button = Button.SolidUIButton()
    /// button.text = "확인"
    /// button.variant = .primary
    /// button.size = .medium
    /// button.handler = { print("버튼이 탭되었습니다.") }
    /// ```
    @available(*, deprecated, message: "`Montage.Button()`를 사용하세요.")
    public class SolidUIButton: UIView {
        /// 버튼의 외관을 결정하는 열거형입니다.
        public enum Variant {
            /// 기본 강조 스타일 - 주요 액션에 사용
            case primary
            /// 보조 스타일 - 덜 중요한 액션에 사용
            case assistive
        }
        
        /// 버튼의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            /// 큰 크기
            case large
            /// 중간 크기
            case medium
            /// 작은 크기
            case small
        }
        
        /// 버튼 모서리의 곡률 스타일을 결정하는 열거형입니다.
        public enum CornerStyle {
            /// 높이의 절반을 반지름으로 하는 원형 모서리
            case legacy
            /// 버튼 크기에 따른 고정된 모서리 곡률
            case `default`
        }
        
        /// 버튼의 외관입니다.
        ///
        /// 기본값은 `.primary`입니다.
        public var variant: Variant = .primary {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 사이즈입니다.
        ///
        /// 기본값은 `.large`입니다.
        /// > Important: Variant이 Assistive일 경우 .large를 사용할 수 없습니다.
        /// > 설정 시 constraint가 업데이트 됩니다.
        public var size: Size = .large {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 버튼의 모서리 곡률을 결정하는 스타일입니다.
        ///
        /// 기본값은 `.default`입니다.
        public var cornerStyle: CornerStyle = .default {
            didSet {
                updateViews()
            }
        }
        
        /// 사용자와의 인터렉션 상태를 표현합니다.
        ///
        /// 버튼의 현재 상호작용 상태를 나타냅니다.
        /// 기본값은 `.normal`입니다.
        public var state: Interaction.State = .normal {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        ///
        /// 텍스트가 있는 경우, 텍스트 앞에 나타납니다.
        public var leadingIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        ///
        /// 텍스트가 있는 경우, 텍스트 뒤에 나타납니다.
        public var trailingIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼에서 표현될 텍스트입니다.
        ///
        /// 버튼에 표시될 문자열을 설정합니다.
        public var text = "" {
            didSet {
                updateViews()
            }
        }
        
        /// iconOnly인 경우 표현될 아이콘입니다.
        ///
        /// `iconOnly`가 `true`일 경우에만 표시됩니다.
        public var uniqueIcon: Icon? {
            didSet {
                updateViews()
            }
        }
        
        /// uniqueIcon 노출 여부입니다.
        ///
        /// `true`로 설정 시 `text`와 `leadingIcon`, `trailingIcon`은 표현되지 않고
        /// `uniqueIcon`만 표시됩니다.
        /// 설정 시 constraint가 업데이트 됩니다.
        public var iconOnly = false {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 버튼의 활성화 여부입니다.
        ///
        /// `true`로 설정 시 버튼이 비활성화되고 시각적으로 비활성 상태로 표시됩니다.
        /// 기본값은 `false`입니다.
        public var disable = false {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
        ///
        /// `nil`이 아닌 경우, 지정된 색상으로 텍스트와 아이콘이 표시됩니다.
        public var contentUIColor: UIColor? {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        ///
        /// `nil`이 아닌 경우, 지정된 색상으로 버튼 배경이 표시됩니다.
        public var backgroundUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        ///
        /// 버튼이 탭될 때 호출될 클로저입니다.
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
        
        private lazy var interaction = InteractionUIView()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        private var panRecognizer: UIPanGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        /// SolidUIButton 객체를 생성합니다.
        ///
        /// 기본 설정으로 버튼을 초기화합니다.
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
        ///
        /// 버튼의 내부 콘텐츠와 패딩에 따라 적절한 크기를 계산합니다.
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

extension Button.SolidUIButton {
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
        
        let iconSize = size.iconSize(iconOnly)

        let constraints = [
            leadingIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
            leadingIconView.heightAnchor.constraint(equalToConstant: iconSize.height),
            trailingIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
            trailingIconView.heightAnchor.constraint(equalToConstant: iconSize.height),
            uniqueIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
            uniqueIconView.heightAnchor.constraint(equalToConstant: iconSize.height)
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

extension Button.SolidUIButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = {
            if disable {
                .semantic(.interactionDisable)
            } else {
                if let backgroundUIColor {
                    backgroundUIColor
                } else {
                    variant.backgroundColor
                }
            }
        }()
        let contentColor: UIColor = {
            if disable {
                .semantic(.labelAssistive)
            } else {
                if let contentUIColor {
                    contentUIColor
                } else {
                    variant.textColor
                }
            }
        }()
        leadingIconView.tintColor = contentColor
        trailingIconView.tintColor = contentColor
        uniqueIconView.tintColor = contentColor
        interaction.color = variant.interactionColor
    }
    
    private func updateIconView() {
        if iconOnly {
            if let uniqueIcon {
                leadingIconView.isHidden = true
                trailingIconView.isHidden = true
                
                uniqueIconView.isHidden = false
                uniqueIconView.image = .icon(uniqueIcon)
            }
        } else {
            if let leadingIcon {
                leadingIconView.isHidden = false
                leadingIconView.image = .icon(leadingIcon)
            } else {
                leadingIconView.isHidden = true
            }
            
            if let trailingIcon {
                trailingIconView.isHidden = false
                trailingIconView.image = .icon(trailingIcon)
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
                    .semantic(.labelAssistive)
                } else {
                    if let contentUIColor {
                        contentUIColor
                    } else {
                        variant.textColor
                    }
                }
            }()
        )
    }
}

extension Button.SolidUIButton {
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

extension Button.SolidUIButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension Button.SolidUIButton.Variant {
    var textColor: UIColor {
        switch self {
        case .primary:
            .semantic(.staticWhite)
        case .assistive:
            .semantic(.labelNeutral).withAlphaComponent(0.88)
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .primary: .bold
        case .assistive: .medium
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            .semantic(.primaryNormal)
        case .assistive:
            .semantic(.fillNormal).withAlphaComponent(0.08)
        }
    }
    
    var interactionColor: Color.Semantic {
        .labelNormal
    }

    var interactionVariant: Interaction.Variant {
        switch self {
        case .primary:
            .strong
        case .assistive:
            .normal
        }
    }
}

extension Button.SolidUIButton.Size {
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
