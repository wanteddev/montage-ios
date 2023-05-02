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
            static var defaultInteractionRadius: CGFloat = 4.0
        }
        
        /// 뱃지의 외관을 결정하는 열거형 타입입니다.
        public enum Varient {
            case filled, outlined
        }
        
        /// 뱃지의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case xsmall, small
        }
        
        /// 뱃지의 색상을 결정하는 열거형입니다.
        public enum ColorStyle: Equatable {
            case neutral, accent(Color.Accent)
        }
        
        /// 뱃지의 외관입니다.
        public var varient: Varient = .filled {
            didSet {
                updateViews()
            }
        }
        
        /// 뱃지의 사이즈입니다.
        public var size: Size = .small {
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
        
        /// TextButton 객체를 생성합니다.
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
        stackView.spacing = .spacing(.pt02)
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
        layer.cornerRadius = Const.defaultInteractionRadius
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
        backgroundColor = varient == .filled ? resolveCurrentEncloseColor() : .alias(.backgroundNormal)
        layer.borderWidth = varient == .filled ? 0 : 1
        layer.borderColor = varient == .filled ? nil : resolveCurrentEncloseColor().cgColor
        leftIconView.tintColor = .alias(colorStyle.mainColor)
        rightIconView.tintColor = .alias(colorStyle.mainColor)
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
        .montage(text, varient: size.typoVarient, weight: .bold, color: colorStyle.mainColor)
    }
}

extension Badge.Content {
    private func resolveCurrentEncloseColor() -> UIColor {
        switch colorStyle {
        case .neutral:
            return varient == .filled ? .component(.fillNormal) : .alias(.lineNormal)
        case .accent(let colorStyle):
            let opacity: CGFloat = varient == .filled ? .opacity(.p010) : .opacity(.p060)
            return colorStyle.resolveAsUIColor().withAlphaComponent(opacity)
        }
    }
}

extension Badge.Content.Size {
    var iconSize: CGSize {
        switch self {
        case .xsmall:
            return .init(width: 12, height: 12)
        case .small:
            return .init(width: 16, height: 16)
        }
    }
    
    var typoVarient: Typography.Variant {
        switch self {
        case .xsmall:
            return .caption2
        case .small:
            return .caption1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .xsmall:
            return .init(top: 3, left: 4, bottom: 3, right: 4)
        case .small:
            return .init(top: 4, left: 8, bottom: 4, right: 8)
        }
    }
}

extension Badge.Content.ColorStyle {
    var mainColor: Color.Alias {
        switch self {
        case .neutral:
            return .labelAlternative
        case .accent(let color):
            return color.resolveAsAlias()
        }
    }
}
