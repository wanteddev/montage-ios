//
//  ContentBadgeUIView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import UIKit

/// 컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다.
///
/// 이 컴포넌트는 다양한 스타일과 크기를 지원하며, 텍스트와 함께 아이콘을 표시할 수 있습니다.
///
/// `ContentBadgeUIView`는 카테고리나 상태를 시각적으로 표현하기 위한 UI 컴포넌트입니다.
/// Solid 또는 Outline 스타일로 표현할 수 있으며, 다양한 크기와 색상을 지원합니다.
///
/// - Warning: 이 클래스는 더 이상 사용되지 않으며, 대신 `Montage.ContentBadge`를 사용하세요.
///
/// ```swift
/// // 기본 사용법
/// let badge = ContentBadgeUIView()
/// badge.text = "카테고리"
/// badge.variant = .solid
/// badge.size = .small
/// badge.colorStyle = .neutral()
/// 
/// // 아이콘 추가
/// badge.leadingIcon = UIImage(named: "icon-category")
/// 
/// // 커스텀 색상 적용
/// badge.colorStyle = .accent(.blue, nil)
/// ```
@available(*, deprecated, message: "`Montage.ContentBadge`를 사용하세요.")
public final class ContentBadgeUIView: UIView {
    private enum Const {
        static var defaultActiveColor: Color.Semantic = .primaryNormal
        static var defaultInactiveColor: Color.Semantic = .labelDisable
        static var defaultInteractionColor: Color.Semantic = .primaryNormal
    }
    
    /// 뱃지의 외관 스타일입니다.
    ///
    /// - `.solid`: 배경색이 채워진 스타일
    /// - `.outline`: 테두리만 있는 스타일
    public var variant: ContentBadge.Variant = .solid {
        didSet {
            updateViews()
        }
    }
    
    /// 뱃지의 크기입니다.
    ///
    /// - `.xsmall`: 가장 작은 크기 (12pt 아이콘)
    /// - `.small`: 작은 크기 (14pt 아이콘)
    /// - `.medium`: 중간 크기 (14pt 아이콘)
    public var size: ContentBadge.Size = .small {
        didSet {
            setupUpdateableConstraints()
            updateViews()
        }
    }
    
    /// 뱃지에 적용될 색상 스타일입니다.
    ///
    /// - `.neutral()`: 기본 중립 색상
    /// - `.accent(contentColor, enclosureColor)`: 커스텀 강조 색상
    public var colorStyle: ContentBadge.ColorStyle = .neutral() {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 좌측에 표시될 아이콘입니다.
    ///
    /// 아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.
    public var leadingIcon: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    /// 텍스트의 우측에 표시될 아이콘입니다.
    ///
    /// 아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.
    public var trailingIcon: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    /// 뱃지에 표시될 텍스트입니다.
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
    
    /// 기본 초기화 메서드입니다.
    ///
    /// 이 메서드는 프레임을 `.zero`로 초기화하고 기본 UI 요소를 설정합니다.
    public init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    /// Interface Builder와 함께 사용할 때 호출되는 초기화 메서드입니다.
    ///
    /// - Parameter coder: 디코더 객체
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    /// 트레이트 컬렉션이 변경될 때 호출되는 메서드입니다.
    ///
    /// 다크 모드와 라이트 모드 전환 시 UI를 업데이트합니다.
    ///
    /// - Parameter previousTraitCollection: 이전 트레이트 컬렉션
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateViews()
    }
    
    /// 하위 뷰의 레이아웃이 변경될 때 호출되는 메서드입니다.
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayer()
    }
    
    /// 뱃지의 기본 크기를 계산하여 반환합니다.
    ///
    /// 이 메서드는 텍스트 크기, 아이콘 크기, 여백을 고려하여 최적의 크기를 계산합니다.
    ///
    /// - Returns: 계산된 뱃지의 크기
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
            .init(width: 14, height: 14)
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
            8.0
        case .small:
            8.0
        case .medium:
            10.0
        }
    }
    
    var spacing: CGFloat {
        switch size {
        case .xsmall:
            2
        case .small:
            4
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
