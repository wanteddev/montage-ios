//
//  ActionUIView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// 액션을 설정하거나 실행(이동, 추가, 삭제)합니다.
    public class ActionUIView: UIView {
        /// 칩의 외관입니다.
        var variant: Action.Variant = .solid {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 사이즈입니다.
        var size: Action.Size = .normal {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 사용자와의 인터렉션 상태를 표현합니다.
        var state: Decorate.Interaction.State = .normal {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 좌측에 표시될 이미지입니다.
        var leadingImage: UIImage? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 우측에 표시될 이미지입니다.
        var trailingImage: UIImage? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 칩에서 표현될 텍스트입니다.
        var text = "" {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 터치 활성화 여부입니다.
        var disable = false {
            didSet {
                updateViews()
            }
        }

        /// 칩의 선택 여부 입니다.
        var active = false {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        var imageColor: UIColor? {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        var backgroundUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 텍스트 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        var fontUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 선택 시 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        var activeUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }

        var handler: (() -> Void)?
        
        private let stackView = UIStackView()
        
        private let leadingImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        private let textLabel = UILabel()
        
        private let textLabelWrapperView = UIView()
        
        private let trailingImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        private let interaction = Decorate.InteractionUIView()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        private var textLabelWrapperViewConstraints: [NSLayoutConstraint] = []
        
        init() {
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
            let imageSize = size.imageSize
            let edgeInsets = size.contentsEdgeInsets
            let imageCount = [leadingImage, trailingImage].compactMap { $0 }.count
            let imageWidths = imageSize.width * CGFloat(imageCount)
            let spacings = size.contentsGap * CGFloat(imageCount)
            let textLabelPaddings = size.textLabelPadding * 2
            
            return .init(
                width: imageWidths + spacings + textSize.width + edgeInsets.horizontal + textLabelPaddings,
                height: max(imageSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.ActionUIView {
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
        stackView.spacing = size.contentsGap
        stackView.addArrangedSubview(leadingImageView)
        stackView.addArrangedSubview(textLabelWrapperView)
        stackView.addArrangedSubview(trailingImageView)
        
        textLabelWrapperView.addSubview(textLabel)
    }
    
    private func setupInteraction() {
        setupInteractionContraints()
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewConstraints()
        setupStackViewConstraints()
        setupTextLabelConstraints()
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
        
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingImageView.widthAnchor.constraint(equalToConstant: size.imageSize.width),
            leadingImageView.heightAnchor.constraint(equalToConstant: size.imageSize.height),
            trailingImageView.widthAnchor.constraint(equalToConstant: size.imageSize.width),
            trailingImageView.heightAnchor.constraint(equalToConstant: size.imageSize.height)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
        iconViewContraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = size.contentsEdgeInsets
        
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
    
    private func setupTextLabelConstraints() {
        NSLayoutConstraint.deactivate(textLabelWrapperViewConstraints)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding = size.textLabelPadding
        
        let constraints = [
            textLabel.leftAnchor.constraint(equalTo: textLabelWrapperView.leftAnchor, constant: padding),
            textLabel.rightAnchor.constraint(equalTo: textLabelWrapperView.rightAnchor, constant: -padding),
            textLabel.topAnchor.constraint(equalTo: textLabelWrapperView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: textLabelWrapperView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        textLabelWrapperViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = size.cornerRadius
        layer.masksToBounds = true
    }
}

extension Chip.ActionUIView {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateImageViews()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = resolveBackgroundColor()
        layer.borderColor = resolveCurrentLineColor()
        layer.borderWidth = variant.borderWidth
        leadingImageView.tintColor = resolveCurrentImageColor()
        trailingImageView.tintColor = resolveCurrentImageColor()
        interaction.variant = resolveInteractionVariant()
        interaction.color = resolveInteractionColor()
        updateTextLabel()
    }
    
    private func updateImageViews() {
        if let leadingImage {
            leadingImageView.isHidden = false
            leadingImageView.image = imageColor == nil
            ? leadingImage : leadingImage.withRenderingMode(.alwaysTemplate)
        } else {
            leadingImageView.isHidden = true
        }
        
        if let trailingImage {
            trailingImageView.isHidden = false
            trailingImageView.image = imageColor == nil ? trailingImage : trailingImage
                .withRenderingMode(.alwaysTemplate)
        } else {
            trailingImageView.isHidden = true
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

extension Chip.ActionUIView {
    private func resolveBackgroundColor() -> UIColor {
        if disable {
            variant.disableBackgroundColor
        } else if active {
            if let activeUIColor {
                activeUIColor
            } else {
                variant.activeBackgroundColor
            }
        } else {
            if let backgroundUIColor {
                backgroundUIColor
            } else {
                variant.backgroundColor
            }
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
    
    private func resolveCurrentImageColor() -> UIColor {
        if let imageColor {
            imageColor
        } else {
            .alias(.labelAlternative)
        }
    }
    
    private func resolveInteractionColor() -> Color.Alias {
        if active {
            if variant == .outlined {
                .primaryNormal
            } else {
                .inverseLabel
            }
        } else {
            .labelNormal
        }
    }
    
    private func resolveInteractionVariant() -> Decorate.Interaction.Variant {
        active ? .normal : .light
    }
}

extension Chip.ActionUIView {
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

extension Chip.ActionUIView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension Chip.Action.Variant {
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
            0
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
}

extension Chip.Action.Size {
    var imageSize: CGSize {
        switch self {
        case .large:
            .init(width: 16, height: 16)
        case .normal:
            .init(width: 14, height: 14)
        case .small:
            .init(width: 14, height: 14)
        case .xsmall:
            .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            .body2
        case .normal:
            .label1
        case .small:
            .label1
        case .xsmall:
            .caption1
        }
    }
    
    var contentsEdgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            .init(top: 9, left: 12, bottom: 9, right: 12)
        case .normal:
            .init(top: 7, left: 11, bottom: 7, right: 11)
        case .small:
            .init(top: 6, left: 8, bottom: 6, right: 8)
        case .xsmall:
            .init(top: 4, left: 7, bottom: 4, right: 7)
        }
    }
    
    var contentsGap: CGFloat {
        switch self {
        case .large:
            3
        case .normal:
            3
        case .small:
            2
        case .xsmall:
            2
        }
    }
    
    var textLabelPadding: CGFloat {
        switch self {
        case .large: 2.0
        case .normal: 2.0
        case .small: 2.0
        case .xsmall: 1.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            10.0
        case .normal:
            8.0
        case .small:
            8.0
        case .xsmall:
            6.0
        }
    }
}
