//
//  ActionChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// 액션을 설정하거나 실행(이동, 추가, 삭제)합니다.
    public class FilterUIView: UIView {
        /// 칩의 외관입니다.
        var variant: Filter.Variant = .solid {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 확장 상태입니다.
        var state: Filter.State = .normal {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 사이즈입니다.
        var size: Filter.Size = .normal {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 사용자와의 인터렉션 상태를 표현합니다.
        var interactionState: Decorate.Interaction.State = .normal {
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
        
        /// 칩의 선택 여부입니다.
        var active = false {
            didSet {
                updateViews()
            }
        }
        
        /// 칩 선택시 표시될 텍스트입니다.
        /// 값이 있는 경우에 표시되며 기본값은 칩의 텍스트가 표현됩니다.
        var activeLabel: String? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 활성화 여부입니다.
        var disable = false {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        var iconUIColor: UIColor? {
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

        var handler: (() -> Void)?
        
        private let contentsWrapperView = UIView()
        
        private lazy var stackView = UIStackView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var arrowIconView = UIImageView()
        
        private lazy var interaction = Decorate.InteractionUIView()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var contentsWrapperViewConstraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
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

extension Chip.FilterUIView {
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

extension Chip.FilterUIView {
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

extension Chip.FilterUIView {
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
            .semantic(.labelDisable)
        } else if active {
            variant.activeTextUIColor
        } else {
            if let fontUIColor {
                fontUIColor
            } else {
                .semantic(.labelNormal)
            }
        }
    }
    
    private func resolveCurrentLineColor() -> CGColor {
        guard variant == .outlined else { return UIColor.clear.cgColor }
        if active {
            return UIColor.semantic(.primaryNormal).withAlphaComponent(0.43).cgColor
        } else {
            return UIColor.semantic(.lineNeutral).cgColor
        }
    }
    
    private func resolveArrowIconTintColor() -> UIColor {
        if disable {
            .semantic(.labelDisable)
        } else if active {
            variant.activeArrowColor
        } else {
            if let iconUIColor {
                iconUIColor
            } else {
                .semantic(.labelNormal)
            }
        }
    }
    
    private func resolveInteractionColor() -> Color.Semantic {
        if active, variant == .outlined {
            .primaryNormal
        } else {
            .labelNormal
        }
    }
}

extension Chip.FilterUIView {
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
