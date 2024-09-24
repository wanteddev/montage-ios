//
//  ContentBadge.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import UIKit

extension Badge {
    /// 컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다
    public class Content: UIView {
        private enum Const {
            static var defaultActiveColor: Color.Alias = .primaryNormal
            static var defaultInactiveColor: Color.Alias = .labelDisable
            static var defaultInteractionColor: Color.Alias = .primaryNormal
        }
        
        /// 뱃지의 외관을 결정하는 열거형 타입입니다.
        public enum Variant {
            case solid, outlined
        }
        
        /// 뱃지의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case normal, medium, large
        }
        
        /// 뱃지의 색상을 결정하는 열거형입니다.
        public enum ColorStyle: Equatable {
            case neutral, accent(_ content: Color.Accent, background: Color.Accent? = nil)
        }
        
        /// 뱃지의 외관입니다.
        public var variant: Variant = .solid {
            didSet {
                updateViews()
            }
        }
        
        /// 뱃지의 사이즈입니다.
        public var size: Size = .medium {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 뱃지에 사용될 색상 스타일입니다.
        public var colorStyle: ColorStyle = .neutral {
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
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        private weak var delegate: TextButtonDelegate?
        
        /// 객체를 생성합니다.
        public init() {
            super.init(frame: .zero)
            
            setupViews()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            setupViews()
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
            
            return .init(
                width: iconSize.width * CGFloat(iconCount) + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Badge.Content {
    private func setupViews() {
        addSubview(stackView)
        
        setupStackView()
        setupUpdateableConstraints()
        
        updateViews()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = size.spacing
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = size.cornerRadius
        layer.masksToBounds = true
    }
}

extension Badge.Content {
    private func updateViews() {
        updateColor()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        backgroundColor = variant == .solid ? enclosureColor : .alias(.backgroundNormal)
        layer.borderWidth = variant == .solid ? 0 : 1
        layer.borderColor = variant == .solid ? nil : enclosureColor.cgColor
        leftIconView.tintColor = .alias(colorStyle.contentColor)
        rightIconView.tintColor = .alias(colorStyle.contentColor)
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
        .montage(text, variant: size.typoVariant, weight: .bold, color: colorStyle.contentColor)
    }
}

extension Badge.Content {
    private var enclosureColor: UIColor {
        switch colorStyle {
        case .neutral:
            return variant == .solid ? .component(.fillNormal) : .alias(.lineNormal)
        case let .accent(contentColor, enclosureColor):
            let opacity: CGFloat = variant == .solid ? .opacity(.p008) : .opacity(.p043)
            return (enclosureColor ?? contentColor).resolveAsUIColor().withAlphaComponent(opacity)
        }
    }
}

extension Badge.Content.Size {
    var iconSize: CGSize {
        switch self {
        case .normal:
            return .init(width: 12, height: 12)
        case .medium:
            return .init(width: 14, height: 14)
        case .large:
            return .init(width: 16, height: 16)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .normal:
            return .caption2
        case .medium:
            return .caption1
        case .large:
            return .label2
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .normal:
            return .init(top: 3, left: 6, bottom: 3, right: 6)
        case .medium:
            return .init(top: 4, left: 6, bottom: 4, right: 6)
        case .large:
            return .init(top: 5, left: 8, bottom: 5, right: 8)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .normal:
            return 6.0
        case .medium:
            return 6.0
        case .large:
            return 8.0
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .normal:
            2
        case .medium:
            3
        case .large:
            4
        }
    }
}

extension Badge.Content.ColorStyle {
    var contentColor: Color.Alias {
        switch self {
        case .neutral:
            return .labelAlternative
        case let .accent(contentColor, _):
            return contentColor.resolveAsAlias()
        }
    }
}
