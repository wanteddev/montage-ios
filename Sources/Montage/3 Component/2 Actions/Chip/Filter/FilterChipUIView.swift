//
//  ActionChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// **`Deprecated`**
    ///
    /// 필터 칩의 UI 구현을 위한 내부 뷰 클래스입니다.
    ///
    /// `FilterUIView`는 `Chip.Filter`의 실제 UI 구현체로, UIKit 기반으로 구현되어 있습니다.
    /// SwiftUI에서 `UIViewRepresentable`을 통해 사용되며, 다양한 상태와 스타일을 표현할 수 있습니다.
    ///
    /// 이 클래스는 다음과 같은 주요 기능을 제공합니다:
    /// - 다양한 외관 스타일 지원 (solid, outlined)
    /// - 크기 조정 (xsmall, small, medium, large)
    /// - 확장 상태 표시 (normal, expand)
    /// - 활성/비활성 상태 표시
    /// - 사용자 상호작용 효과
    ///
    /// - Warning: 이 클래스는 더 이상 사용되지 않으며 향후 릴리스에서 제거될 예정입니다.
    ///   SwiftUI에서 `Chip.Filter`를 직접 사용하세요.
    ///
    /// - Note: 이 클래스는 `Chip.Filter`의 내부 구현체이므로 직접 사용보다는
    ///   SwiftUI에서 `Chip.Filter`를 통해 사용하는 것이 권장됩니다.
    @available(*, deprecated, message: "This class is deprecated and will be removed in a future release. Use Chip.Filter directly in SwiftUI instead.")
    public class FilterUIView: UIView {
        /// 칩의 외관입니다.
        public var variant: Filter.Variant = .solid {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 확장 상태입니다.
        public var state: Filter.State = .normal {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 사이즈입니다.
        public var size: Filter.Size = .medium {
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

        /// 칩이 탭되었을 때 실행될 핸들러입니다.
        ///
        /// 사용자가 칩을 탭하면 이 클로저가 호출됩니다.
        public var handler: (() -> Void)?
        
        private let contentsWrapperView = UIView()
        
        private lazy var stackView = UIStackView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var arrowIconView = UIImageView()
        
        private lazy var interaction = Decorate.InteractionUIView()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var contentsWrapperViewConstraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        /// 기본 이니셜라이저입니다.
        ///
        /// 필터 칩 뷰를 초기화하고 기본 설정을 적용합니다.
        public init() {
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        /// 스토리보드에서 사용하기 위한 이니셜라이저입니다.
        ///
        /// - Parameter coder: 디코더 객체
        required public init?(coder: NSCoder) {
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
        
        /// 필터 칩의 기본 내용 크기를 계산합니다.
        ///
        /// 텍스트 크기, 아이콘 크기, 여백 등을 고려하여 칩의 적절한 크기를 계산합니다.
        ///
        /// - Returns: 계산된 콘텐츠 크기
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
