//
//  ActionChip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import UIKit

extension Chip {
    /// 액션을 설정하거나 실행(이동, 추가, 삭제)합니다.
    public class Action: UIView {
        private enum Const {
            static var iconSpacing: CGFloat = .spacing(.pt04)
        }
        
        /// 칩의 외관을 결정하는 열거형입니다.
        public enum Varient {
            case filled, outlined
        }
        
        /// 칩의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case small, medium, large
        }
        
        /// 칩의 외관입니다.
        public var varient: Varient = .filled {
            didSet {
                updateViews()
            }
        }
        
        /// 칩의 사이즈입니다.
        public var size: Size = .medium {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        /// 사용자와의 인터렉션 상태를 표현합니다.
        public var state: Decorate.Interaction.State = .normal {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        public var leftIcon: Icon? = nil {
            didSet {
                updateViews()
            }
        }
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var rightIcon: Icon? = nil {
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
        
        /// 칩의 활성화 여부입니다.
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var leftIconView = UIImageView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var rightIconView = UIImageView()
        
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
            let iconCount = [leftIcon, rightIcon].filter({ $0 != nil }).count
            let iconWidths = iconSize.width * CGFloat(iconCount)
            let spacings = Const.iconSpacing * CGFloat(iconCount)
            
            return .init(
                width: iconWidths + spacings + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Chip.Action {
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
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Const.iconSpacing
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
    
    private func setupInteractionContraints() {
        interaction.translatesAutoresizingMaskIntoConstraints = false
        
        interaction.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        interaction.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        interaction.topAnchor.constraint(equalTo: topAnchor).isActive = true
        interaction.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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

extension Chip.Action {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColors()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColors() {
        backgroundColor = varient.backgroundColor
        layer.borderColor = varient.borderColor.cgColor
        layer.borderWidth = varient.borderWidth
        leftIconView.tintColor = .alias(disable ? varient.inactiveTextColor : varient.activeTextColor)
        rightIconView.tintColor = .alias(disable ? varient.inactiveTextColor : varient.activeTextColor)
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
        .montage(
            text,
            varient: size.typoVarient,
            weight: .bold,
            color: disable ? varient.inactiveTextColor : varient.activeTextColor
        )
    }
}

extension Chip.Action {
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

extension Chip.Action: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension Chip.Action.Varient {
    var backgroundColor: UIColor {
        switch self {
        case .filled:
            return .component(.fillAlternative)
        case .outlined:
            return .alias(.backgroundNormal)
        }
    }
    
    var activeTextColor: Color.Alias {
        .labelNormal
    }
    
    var inactiveTextColor: Color.Alias {
        .labelAlternative
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .filled:
            return 0
        case .outlined:
            return 1
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .filled:
            return .clear
        case .outlined:
            return .alias(.lineNormal)
        }
    }
}

extension Chip.Action.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            return .init(width: 16, height: 16)
        case .medium:
            return .init(width: 14, height: 14)
        case .small:
            return .init(width: 12, height: 12)
        }
    }
    
    var typoVarient: Typography.Variant {
        switch self {
        case .large:
            return .body2
        case .medium:
            return .label1
        case .small:
            return .caption1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return .init(top: 9, left: 16, bottom: 9, right: 16)
        case .medium:
            return .init(top: 6, left: 12, bottom: 6, right: 12)
        case .small:
            return .init(top: 4, left: 8, bottom: 4, right: 8)
        }
    }
}
