//
//  IconButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import UIKit

extension Button {
    /// 단일 아이콘을 배경 또는 외곽선으로 감싸는 버튼입니다.
    /// [Figma](https://www.figma.com/file/NzeCJaXMkqRBlRd9CZCx8j/0-Component?node-id=1174%3A12997&t=5otLCYvozBpnxZ7j-1) 에서 모양을 미리 확인할 수 있습니다.
    public class IconButton: UIView {
        /// 버튼의 외관을 결정하는 열거형입니다.
        public enum Varient {
            /// Outline 타입의 버튼 사이즈를 결정하는 열거형입니다.
            public enum OutlineSize {
                case normal, small
            }
            
            case normal, background, outlined(size: OutlineSize)
        }
        
        /// 버튼의 외관입니다.
        public var varient: Varient = .normal {
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
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        public var handler: (() -> Void)?
        
        private lazy var iconView = UIImageView()
        
        private lazy var interaction = Decorate.Interaction()
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var sizeContraints: [NSLayoutConstraint] = []
        
        private var insetConstraints: [NSLayoutConstraint] = []
        
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
            .init(
                width: varient.iconSize.width + varient.inset * 2,
                height: varient.iconSize.height + varient.inset * 2
            )
        }
    }
}

extension Button.IconButton {
    private func setupViews() {
        addSubview(iconView)
        addSubview(interaction)
        
        setupInteractionContraints()
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
    
    private func setupUpdateableConstraints() {
        setupIconViewSizeConstraints()
        setupIconViewInsetConstraints()
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
            iconView.widthAnchor.constraint(equalToConstant: varient.iconSize.width),
            iconView.heightAnchor.constraint(equalToConstant: varient.iconSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        sizeContraints = constraints
    }
    
    private func setupIconViewInsetConstraints() {
        NSLayoutConstraint.deactivate(insetConstraints)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: varient.inset),
            iconView.rightAnchor.constraint(equalTo: rightAnchor, constant: -varient.inset),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: varient.inset),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -varient.inset)
        ]
        
        NSLayoutConstraint.activate(constraints)
        insetConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

extension Button.IconButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        
        setupIconViewSizeConstraints()
        setupIconViewInsetConstraints()
        updateConstraints()
    }
    
    private func updateColors() {
        backgroundColor = disable ? varient.inactiveBackgroundColor : varient.activeBackgroundColor
        layer.borderColor = varient.borderColor.cgColor
        layer.borderWidth = varient.borderWidth
        iconView.tintColor = .alias(disable ? varient.inactiveColor : varient.activeColor)
        interaction.color = varient.interactionColor
    }
    
    private func updateIconView() {
        iconView.image = .montage(icon)
    }
}

extension Button.IconButton {
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

extension Button.IconButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension Button.IconButton.Varient {
    var activeBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background:
            return .component(.fillNormal)
        }
    }
    
    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background:
            return .component(.fillAlternative)
        }
    }
    
    var activeColor: Color.Alias {
        switch self {
        case .normal, .outlined:
            return .labelNormal
        case .background:
            return .labelAlternative
        }
    }
    
    var inactiveColor: Color.Alias {
        switch self {
        case .normal, .outlined:
            return .labelDisable
        case .background:
            return .labelAlternative
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined:
            return 1
        default:
            return 0
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .outlined:
            return .alias(.lineNormal)
        default:
            return .clear
        }
    }
    
    var interactionColor: Color.Alias {
        return .labelNormal
    }
    
    var iconSize: CGSize {
        switch self {
        case .normal:
            return .init(width: 24, height: 24)
        case .background:
            return .init(width: 20, height: 20)
        case .outlined(let size):
            return size == .normal ? .init(width: 20, height: 20) : .init(width: 18, height: 18)
        }
    }
    
    var inset: CGFloat {
        switch self {
        case .normal:
            return 8.0
        case .background:
            return 6.0
        case .outlined(let size):
            return size == .normal ? 10.0 : 7.0
        }
    }
}
