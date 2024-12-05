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
    public class UIIconButton: UIView {
        /// 버튼의 외관입니다.
        public var variant: Button.IconButton.Variant = .default {
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
        public var disable = false {
            didSet {
                updateViews()
            }
        }

        /// 버튼 우측 상단의 푸시 뱃지 노출 여부입니다.
        /// > normal variant에서만 사용 가능합니다.
        public var showPushBadge = false {
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
        public var iconUIColor: UIColor? {
            didSet {
                updateColors()
            }
        }
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        /// > outlined, soild variant에서만 사용 가능합니다.
        public var backgroundUIColor: UIColor? {
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
        public var borderUIColor: UIColor? {
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
        private lazy var interactionLayer = interaction.layer
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        private var panRecognizer: UIPanGestureRecognizer?
        
        private var sizeContraints: [NSLayoutConstraint] = []
        
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
            icon = .dot
            
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
            updateInteractionlayer(size)
            return size
        }
        
        /// Element의 터치 가능 영역을 조절합니다.
        override public func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
            let biggerFrame = bounds.insetBy(dx: -12, dy: -12)
            return biggerFrame.contains(point)
        }
    }
}

extension Button.UIIconButton {
    private func setupViews() {
        addSubview(iconView)
        addSubview(pushBadge)
        layer.addSublayer(interactionLayer)
        
        setupInteaction()
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
    
    private func setupInteaction() {
        interactionLayer.cornerRadius = frame.height / 2
        updateInteractionlayer(frame.size)
    }
    
    private func setupUpdateableConstraints() {
        setupIconViewSizeConstraints()
        setupPushBadgeConstraints()
        updateConstraints()
        setupLayer()
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

extension Button.UIIconButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateBlur()
        updateColors()
        updateIconView()
        updatePushBadgeView()
        
        setupIconViewSizeConstraints()
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
                visualEffectView?.isUserInteractionEnabled = false
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
                    if let backgroundUIColor {
                        backgroundUIColor
                    } else {
                        variant.activeBackgroundColor
                    }
                }
            }
        }()
        layer.borderColor = {
            if case .outlined(_) = variant, let borderUIColor {
                borderUIColor.cgColor
            } else {
                variant.borderColor.cgColor
            }
        }()
        layer.borderWidth = variant.borderWidth
        iconView.tintColor = {
            if disable {
                variant.inactiveColor
            } else {
                if let iconUIColor {
                    iconUIColor
                } else {
                    variant.activeColor
                }
            }
        }()
        interaction.variant = variant.interactionVariant
        interaction.color = variant.interactionColor
    }
    
    private func updateIconView() {
        iconView.image = .montage(icon)
    }
    
    private func updatePushBadgeView() {
        guard case .normal(_) = variant else { return }
        pushBadge.isHidden = !showPushBadge
    }
    
    private func updateInteractionlayer(_ size: CGSize) {
        interactionLayer.frame = CGRect(
            origin: .init(
                x: -interactionOffset,
                y: -interactionOffset
            ),
            size: .init(
                width: size.width + interactionOffset * 2,
                height: size.height + interactionOffset * 2
            )
        )
    }
}

extension Button.UIIconButton {
    private var size: CGSize {
        switch variant {
        case .normal, .background:
            .init(
                width: variant.iconSize.width,
                height: variant.iconSize.height
            )
        case .outlined, .solid:
            if padding != .zero {
                .init(
                    width: variant.iconSize.width + padding,
                    height: variant.iconSize.height + padding
                )
            } else {
                .init(
                    width: variant.iconSize.width,
                    height: variant.iconSize.height
                )
            }
        }
    }
    
    private var interactionOffset: CGFloat {
        variant.interactionOffset + padding
    }
}

extension Button.UIIconButton {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interaction.layer.opacity = .opacity(.p022)
        case .changed:
            // 스크롤 시 버튼이 눌리지 않도록 state를 normal로 변경
            // 3D touch 모델은 스크롤 하지 않아도 changed가 실행되서 적용하지 않음
            if traitCollection.forceTouchCapability != UIForceTouchCapability.available
                && traitCollection.forceTouchCapability != UIForceTouchCapability.unavailable {
                interaction.layer.opacity = .opacity(.p100)
            }
        case .ended:
            if let view = recognizer.view, view.bounds.contains(recognizer.location(in: recognizer.view)) {
                handler?()
            }
            interactionLayer.opacity = .opacity(.p000)
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

extension Button.UIIconButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
