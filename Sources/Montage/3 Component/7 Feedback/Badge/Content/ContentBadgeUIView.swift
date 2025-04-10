//
//  ContentBadgeUIView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import UIKit

/// 컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다
@available(*, deprecated, message: "Use ContentBadge instead")
public class ContentBadgeUIView: UIView {
    private enum Const {
        static var defaultActiveColor: Color.Semantic = .primaryNormal
        static var defaultInactiveColor: Color.Semantic = .labelDisable
        static var defaultInteractionColor: Color.Semantic = .primaryNormal
    }
    
    /// 뱃지의 외관입니다.
    public var variant: ContentBadge.Variant = .solid {
        didSet {
            updateViews()
        }
    }
    
    /// 뱃지의 사이즈입니다.
    public var size: ContentBadge.Size = .small {
        didSet {
            setupUpdateableConstraints()
            updateViews()
        }
    }
    
    /// 뱃지에 사용될 색상 스타일입니다.
    public var colorStyle: ContentBadge.ColorStyle = .neutral() {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 좌측에 표현될 아이콘입니다.
    public var leadingIcon: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 우측에 표현될 아이콘입니다.
    public var trailingIcon: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    /// 버튼에서 표현될 텍스트입니다.
    public var text = "" {
        didSet {
            updateViews()
        }
    }
    
    private lazy var stackView = UIStackView()
    
    private lazy var leadingIconView = UIImageView()
    
    private lazy var textLabel = UILabel()
    
    private lazy var trailingIconView = UIImageView()
    
    private var iconViewContraints: [NSLayoutConstraint] = []
    
    private var stackViewConstraints: [NSLayoutConstraint] = []
    
    /// 객체를 생성합니다.
    public init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
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
        let iconSize = iconSize
        let edgeInsets = edgeInsets
        let iconCount = [leadingIcon, trailingIcon].filter { $0 != nil }.count
        
        return .init(
            width: iconSize.width * CGFloat(iconCount) + spacing * CGFloat(iconCount) + textSize
                .width + edgeInsets.horizontal,
            height: max(iconSize.height, textSize.height) + edgeInsets.vertical
        )
    }
}

extension ContentBadgeUIView {
    private func setupViews() {
        addSubview(stackView)
        
        setupStackView()
        setupUpdateableConstraints()
        
        updateViews()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = spacing
        stackView.addArrangedSubview(leadingIconView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(trailingIconView)
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewConstraints()
        setupStackViewConstraints()
        updateConstraints()
        setupLayer()
    }
    
    private func setupIconViewConstraints() {
        NSLayoutConstraint.deactivate(iconViewContraints)
        
        leadingIconView.translatesAutoresizingMaskIntoConstraints = false
        trailingIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
            leadingIconView.heightAnchor.constraint(equalToConstant: iconSize.height),
            trailingIconView.widthAnchor.constraint(equalToConstant: iconSize.width),
            trailingIconView.heightAnchor.constraint(equalToConstant: iconSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        iconViewContraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = edgeInsets
        
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
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

extension ContentBadgeUIView {
    private func updateViews() {
        updateColor()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        backgroundColor = variant == .solid ? enclosureColor : .semantic(.backgroundNormal)
        layer.borderWidth = variant == .solid ? 0 : 1
        layer.borderColor = variant == .solid ? nil : enclosureColor.cgColor
        leadingIconView.tintColor = contentColor
        trailingIconView.tintColor = contentColor
    }
    
    private func updateIconView() {
        if let leadingIcon {
            leadingIconView.isHidden = false
            leadingIconView.image = leadingIcon.withRenderingMode(.alwaysTemplate)
        } else {
            leadingIconView.isHidden = true
        }
        
        if let trailingIcon {
            trailingIconView.isHidden = false
            trailingIconView.image = trailingIcon.withRenderingMode(.alwaysTemplate)
        } else {
            trailingIconView.isHidden = true
        }
    }
    
    private func updateTextLabel() {
        textLabel.attributedText = getAttributedText()
    }
    
    private func getAttributedText() -> NSAttributedString {
        ._montage(text, variant: typoVariant, weight: .medium, color: contentColor)
    }
}

extension ContentBadgeUIView {
    private var enclosureColor: UIColor {
        switch colorStyle {
        case .neutral:
            return variant == .solid ? .semantic(.fillNormal) : .semantic(.lineNormal)
        case let .accent(contentColor, enclosureColor):
            let opacity: CGFloat = variant == .solid ? .opacity(.p008) : .opacity(.p043)
            return (enclosureColor ?? contentColor).uiColor.withAlphaComponent(opacity)
        }
    }
    
    var iconSize: CGSize {
        switch size {
        case .xsmall:
            .init(width: 12, height: 12)
        case .small:
            .init(width: 14, height: 14)
        case .medium:
            .init(width: 16, height: 16)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .xsmall:
            .caption2
        case .small:
            .caption1
        case .medium:
            .label2
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch size {
        case .xsmall:
            .init(top: 3, left: 6, bottom: 3, right: 6)
        case .small:
            .init(top: 4, left: 6, bottom: 4, right: 6)
        case .medium:
            .init(top: 5, left: 8, bottom: 5, right: 8)
        }
    }

    var cornerRadius: CGFloat {
        switch size {
        case .xsmall:
            6.0
        case .small:
            6.0
        case .medium:
            8.0
        }
    }
    
    var spacing: CGFloat {
        switch size {
        case .xsmall:
            2
        case .small:
            3
        case .medium:
            4
        }
    }
    
    var contentColor: UIColor {
        switch colorStyle {
        case .neutral:
            .semantic(.labelAlternative)
        case let .accent(contentColor, _):
            contentColor.uiColor
        }
    }
}
