//
//  TextButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import UIKit

/// ``TextButton``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol TextButtonDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter checkbox: 터치가 발생한 객체
    func didTappedRoundButton(_ roundButton: Button.TextButton)
}


extension Button {
    /// 텍스트 및 아이콘으로 이루어진 버튼입니다.
    /// [Figma](https://www.figma.com/file/NzeCJaXMkqRBlRd9CZCx8j/0-Component?node-id=1174%3A12997&t=5otLCYvozBpnxZ7j-1) 에서 모양을 미리 확인할 수 있습니다.
    public class TextButton: UIView {
        
        /// 버튼의 외관을 결정하는 열거형입니다.
        public enum Varient {
            case primary
            case assistive
        }
        
        /// 버튼의 외관입니다.
        public var varient: Varient = .primary {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case medium, small
        }
        
        /// 버튼의 사이즈입니다.
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
        
        /// 버튼의 활성화 여부입니다.
        public var disable: Bool = false {
            didSet {
                updateViews()
            }
        }
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var leftIconView = UIImageView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var rightIconView = UIImageView()
        
        private lazy var interaction = Decorate.Interaction()
        
        private var tapRecognizer: UITapGestureRecognizer?
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        private weak var delegate: TextButtonDelegate?
        
        /// TextButton 객체를 생성합니다.
        public init() {
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        public required init?(coder: NSCoder) {
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
            
            return .init(
                width: iconSize.width * CGFloat(iconCount) + textSize.width + edgeInsets.horizontal,
                height: max(iconSize.height, textSize.height) + edgeInsets.vertical
            )
        }
    }
}

extension Button.TextButton {
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
        longPressRecognizer.addTarget(self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
        self.longPressRecognizer = longPressRecognizer
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .spacing(.pt04)
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
        layer.cornerRadius = varient.interactionRadius
        layer.masksToBounds = true
    }
}

extension Button.TextButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColor()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        interaction.color = varient.interactionColor
        leftIconView.tintColor = .alias(disable ? varient.inactiveColor : varient.activeColor)
        rightIconView.tintColor = .alias(disable ? varient.inactiveColor : varient.activeColor)
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
            color: disable ? varient.inactiveColor : varient.activeColor
        )
    }
}

extension Button.TextButton {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interaction.state = .pressed
        case .changed:
            interaction.state = .normal
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

extension Button.TextButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension Button.TextButton.Varient {
    var activeColor: Color.Alias {
        switch self {
        case .primary: return .primaryNormal
        case .assistive: return .labelAlternative
        }
    }
    
    var inactiveColor: Color.Alias {
        .labelDisable
    }
    
    var interactionColor: Color.Alias {
        switch self {
        case .primary: return .primaryNormal
        case .assistive: return .labelNormal
        }
    }
    
    var interactionRadius: CGFloat {
        5.0
    }
}

extension Button.TextButton.Size {
    var iconSize: CGSize {
        switch self {
        case .medium:
            return .init(width: 20, height: 20)
        case .small:
            return .init(width: 16, height: 16)
        }
    }
    
    var typoVarient: Typography.Variant {
        switch self {
        case .medium:
            return .body1
        case .small:
            return .label1
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .medium:
            return .init(top: 4, left: 7, bottom: 4, right: 7)
        case .small:
            return .init(top: 4, left: 6, bottom: 4, right: 6)
        }
    }
}
