//
//  IconButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import UIKit

extension Button {
    /// 단일 아이콘을 배경 또는 외곽선으로 감싸는 버튼입니다.
    /// [Figma](https://www.figma.com/design/7RHtWV3Pw6I98UEDjbx5V1/0-Component?node-id=14854-45453) 에서 모양을 미리 확인할 수 있습니다.
    public class IconButton: UIView {
        /// 버튼의 외관을 결정하는 열거형입니다.
        public enum Variant {
            /// 버튼 사이즈를 결정하는 열거형입니다.
            public enum Size {
                case normal
                case small
                case custom(size: Int)
            }
            
            case normal(size: Int)
            case background(size: Int, isAlternative: Bool = false)
            case outlined(size: Size)
            case solid(size: Size)
            
            /// normal(size: 24)의 기본 variant입니다.
            public static let `default` = Self.normal(size: 24)
        }
        
        /// 버튼의 외관입니다.
        public var variant: Variant = .default {
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
        
        /// 버튼에 표시될 아이콘입니다.
        public var icon: Icon {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 활성화 여부입니다.
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }

        /// 버튼 우측 상단의 푸시 뱃지 노출 여부입니다.
        /// > normal variant에서만 사용 가능합니다.
        public var showPushBadge: Bool = false {
            didSet {
                guard case .normal(_) = variant else { return }
                updateViews()
            }
        }
        
        /// 커스텀 가능한 패딩 입니다.
        /// > 설정 시 constraint가 업데이트 됩니다.
        /// > outlined, soild variant에서만 사용 가능합니다.
        public var padding: CGFloat = .zero {
            didSet {
                switch variant {
                case .outlined, .solid:
                    setupUpdateableConstraints()
                    updateViews()
                case .normal, .background:
                    return
                }
            }
        }
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var iconColorResolver: ColorResolvable? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        /// > outlined, soild variant에서만 사용 가능합니다.
        public var backgroundColorResolver: ColorResolvable? {
            didSet {
                switch variant {
                case .outlined, .solid:
                    updateColors()
                case .normal, .background:
                    return
                }
            }
        }
        
        /// 커스텀 가능한 테두리색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        /// > outlined 에서만 사용 가능합니다.
        public var borderColorResolver: ColorResolvable? {
            didSet {
                switch variant {
                case .outlined:
                    updateColors()
                default:
                    return
                }
            }
        }
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        public var handler: (() -> Void)?
        
        private lazy var iconView = UIImageView()
        
        private lazy var pushBadge = Badge.Push()
        
        private lazy var interaction = Decorate.Interaction()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var sizeContraints: [NSLayoutConstraint] = []
        
        private var insetConstraints: [NSLayoutConstraint] = []
        
        private var pushBadgeConstraints: [NSLayoutConstraint] = []
        
        private var visualEffectView: UIVisualEffectView?
        
        /// IconButton 객체를 생성합니다.
        public init(icon: Icon = .dot) {
            self.icon = icon
            
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        public required init?(coder: NSCoder) {
            self.icon = .dot
            
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
            size
        }
    }
}

extension Button.IconButton {
    private func setupViews() {
        addSubview(iconView)
        addSubview(pushBadge)
        addSubview(interaction)
        
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
    }
    
    private func setupInteraction() {
        interaction.variant = variant.interactionVariant
        
        setupInteractionContraints()
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewSizeConstraints()
        setupIconViewInsetConstraints()
        setupPushBadgeConstraints()
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
    
    private func setupIconViewSizeConstraints() {
        NSLayoutConstraint.deactivate(sizeContraints)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            iconView.widthAnchor.constraint(equalToConstant: variant.iconSize.width),
            iconView.heightAnchor.constraint(equalToConstant: variant.iconSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        sizeContraints = constraints
    }
    
    private func setupIconViewInsetConstraints() {
        NSLayoutConstraint.deactivate(insetConstraints)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constant: CGFloat = {
            switch variant {
            case .normal, .background:
                variant.inset
            case .outlined, .solid:
                if padding != .zero {
                    padding
                } else {
                    variant.inset
                }
            }
        }()
        
        let constraints = [
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: constant),
            iconView.rightAnchor.constraint(equalTo: rightAnchor, constant: -constant),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant)
        ]
        
        NSLayoutConstraint.activate(constraints)
        insetConstraints = constraints
    }
    
    private func setupPushBadgeConstraints() {
        NSLayoutConstraint.deactivate(pushBadgeConstraints)
        
        pushBadge.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            pushBadge.topAnchor.constraint(equalTo: iconView.topAnchor, constant: -6),
            pushBadge.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6)
        ]
        
        NSLayoutConstraint.activate(constraints)
        pushBadgeConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

extension Button.IconButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateBlur()
        updateColors()
        updateIconView()
        updatePushBadgeView()
        
        setupIconViewSizeConstraints()
        setupIconViewInsetConstraints()
        setupPushBadgeConstraints()
        updateConstraints()
    }
    
    private func updateBlur() {
        if case let .background(_, isAlternative) = variant, isAlternative == false, disable == false {
            if visualEffectView == nil {
                let blurEffect = UIBlurEffect(style: .systemMaterial)
                let initializedVisualEffectView = UIVisualEffectView(effect: blurEffect)
                initializedVisualEffectView.frame = .init(
                    origin: .zero,
                    size: size
                )
                visualEffectView = initializedVisualEffectView
            }
            guard let visualEffectView else { return }
            addSubview(visualEffectView)
            sendSubviewToBack(visualEffectView)
        } else {
            visualEffectView?.removeFromSuperview()
        }
    }
    
    private func updateColors() {
        backgroundColor = {
            if disable {
                variant.inactiveBackgroundColor
            } else {
                switch variant {
                case .normal, .background:
                    variant.activeBackgroundColor
                case .outlined, .solid:
                    if let backgroundColorResolver {
                        backgroundColorResolver.resolve(.current)
                    } else {
                        variant.activeBackgroundColor
                    }
                }
            }
        }()
        layer.borderColor = {
            if case .outlined(_) = variant, let borderColorResolver {
                borderColorResolver.resolve(.current).cgColor
            } else {
                variant.borderColor.cgColor
            }
        }()
        layer.borderWidth = variant.borderWidth
        iconView.tintColor = {
            if disable {
                variant.inactiveColor
            } else {
                if let iconColorResolver {
                    iconColorResolver.resolve(.current)
                } else {
                    variant.activeColor
                }
            }
        }()
        interaction.color = variant.interactionColor
        interaction.variant = variant.interactionVariant
    }
    
    private func updateIconView() {
        iconView.image = .montage(icon)
    }
    
    private func updatePushBadgeView() {
        guard case .normal(_) = variant else { return }
        pushBadge.isHidden = !showPushBadge
    }
}

extension Button.IconButton {
    private var size: CGSize {
        switch variant {
        case .normal, .background:
            .init(
                width: variant.iconSize.width + variant.inset * 2,
                height: variant.iconSize.height + variant.inset * 2
            )
        case .outlined, .solid:
            if padding != .zero {
                .init(
                    width: variant.iconSize.width + padding * 2,
                    height: variant.iconSize.height + padding * 2
                )
            } else {
                .init(
                    width: variant.iconSize.width + variant.inset * 2,
                    height: variant.iconSize.height + variant.inset * 2
                )
            }
        }
    }
}

extension Button.IconButton {
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
}

extension Button.IconButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension Button.IconButton.Variant {
    var activeBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background(_, let isAlternative):
            if isAlternative {
                return .atomic(.globalCoolNeutral30).withAlphaComponent(0.61)
            } else {
                // material이 적용되어 있기 때문에 값에 무관
                return .clear
            }
        case .solid:
            return .alias(.primaryNormal)
        }
    }
    
    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background:
            return .component(.fillAlternative).withAlphaComponent(0.05)
        case .solid:
            return .component(.fillNormal).withAlphaComponent(0.08)
        }
    }
    
    var activeColor: UIColor {
        switch self {
        case .normal, .outlined: .alias(.labelNormal)
        case .background(_, let isAlternative):
            if isAlternative {
                .alias(.staticWhite).withAlphaComponent(0.88)
            } else {
                .atomic(.globalCoolNeutral50).withAlphaComponent(0.74)
            }
        case .solid: .alias(.staticWhite)
        }
    }
    
    var inactiveColor: UIColor {
        switch self {
        case .normal, .outlined, .solid:
            return .alias(.labelDisable).withAlphaComponent(0.16)
        case .background:
            return .atomic(.globalCoolNeutral50).withAlphaComponent(0.22)
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined: 1
        default: .zero
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .outlined: .alias(.lineNeutral)
        default: .clear
        }
    }
    
    var interactionColor: Color.Alias {
        .labelNormal
    }
    
    var interactionVariant: Decorate.Interaction.Variant {
        switch self {
        case .normal, .outlined: .light
        case .background(_, let isAlternative):
            isAlternative ? .normal : .light
        case .solid: .strong
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .normal(let size): .init(width: size, height: size)
        case .background(let size, _): .init(width: size, height: size)
        case .outlined(let variant), .solid(let variant):
            switch variant {
            case .normal:
                .init(width: 20, height: 20)
            case .small:
                .init(width: 18, height: 18)
            case .custom(let size):
                .init(width: size, height: size)
            }
        }
    }
    
    var inset: CGFloat {
        switch self {
        case .normal: 8.0
        case .background: 6.0
        case .outlined(let variant), .solid(let variant):
            switch variant {
            case .normal: 10.0
            case .small: 7.0
            case .custom: 6.0
            }
        }
    }
}
