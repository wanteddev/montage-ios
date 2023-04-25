//
//  MultiSelectChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/20.
//

import UIKit

extension Chip {
    final public class MultiSelect: UIView {
        private enum Const {
            static var iconSpacing: CGFloat = .spacing(.pt04)
        }
        
        /// 칩의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case medium, large
        }
        
        /// 칩의 사이즈입니다.
        public var size: Size = .medium {
            didSet {
                setupUpdateableConstraints()
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
        
        /// 사용자와의 인터렉션 상태를 표현합니다.
        public var state: Decorate.Interaction.State = .normal {
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
        
        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var iconView = UIImageView()
        
        private lazy var textLabel = UILabel()
        
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
            
            return .init(
                width: iconSize.width + Const.iconSpacing + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.MultiSelect {
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
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Const.iconSpacing
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)
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
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            iconView.widthAnchor.constraint(equalToConstant: size.iconSize.width),
            iconView.heightAnchor.constraint(equalToConstant: size.iconSize.height)
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
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

extension Chip.MultiSelect {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = .clear
        layer.borderColor = resolveCurrentLineColor()
        layer.borderWidth = 1
        iconView.tintColor = .alias(resolveCurrentTextColor())
    }
    
    private func updateIconView() {
        iconView.image = .montage(.checkThick)
    }
    
    private func updateTextLabel() {
        textLabel.attributedText = getAttributedText()
    }
    
    private func getAttributedText() -> NSAttributedString {
        .montage(text, varient: size.typoVarient, weight: .bold, color: resolveCurrentTextColor())
    }
}

extension Chip.MultiSelect {
    private func resolveCurrentTextColor() -> Color.Alias {
        if disable {
            return .labelDisable
        } else if active {
            return .primaryNormal
        } else {
            return .labelAlternative
        }
    }
    
    private func resolveCurrentLineColor() -> CGColor {
        if disable {
            return UIColor.alias(.lineAlternative).cgColor
        } else if active {
            return UIColor.alias(.primaryNormal).cgColor
        } else {
            return UIColor.alias(.lineNormal).cgColor
        }
    }
}

extension Chip.MultiSelect {
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

extension Chip.MultiSelect.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            return .init(width: 16, height: 16)
        case .medium:
            return .init(width: 14, height: 14)
        }
    }
    
    var typoVarient: Typography.Variant {
        switch self {
        case .large:
            return .body2
        case .medium:
            return .label1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return .init(top: 9, left: 16, bottom: 9, right: 16)
        case .medium:
            return .init(top: 6, left: 12, bottom: 6, right: 12)
        }
    }
}

