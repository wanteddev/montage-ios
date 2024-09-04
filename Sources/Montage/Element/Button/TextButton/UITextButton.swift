//
//  UITextButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import UIKit

/// ``TextButton``의 터치 이벤트를 받을 수 있는 Delegate입니다.
public protocol TextButtonDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter checkbox: 터치가 발생한 객체
    func didTappedRoundButton(_ roundButton: Button.UITextButton)
}

extension Button {
    /// 텍스트 및 아이콘으로 이루어진 버튼입니다.
    /// [Figma](https://www.figma.com/file/NzeCJaXMkqRBlRd9CZCx8j/0-Component?node-id=1174%3A12997&t=5otLCYvozBpnxZ7j-1) 에서 모양을 미리 확인할 수 있습니다.
    public class UITextButton: UIView {
        /// 버튼의 외관입니다.
        public var variant: TextButton.Variant = .primary {
            didSet {
                updateViews()
            }
        }

        /// 버튼의 사이즈입니다.
        public var size: TextButton.Size = .medium {
            didSet {
                setupUpdateableConstraints()
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
        
        /// 커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        public var contentUIColor: UIColor? {
            didSet {
                updateViews()
            }
        }
        
        /// 커스텀 가능한 텍스트 사이즈입니다.
        /// montage의 모든 Typography.Variant를 사용할 수 있습니다.
        public var fontSize: Typography.Variant? {
            didSet {
                updateTextLabel()
            }
        }
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        public var handler: (() -> Void)?
        
        private lazy var stackView = UIStackView()
        
        private lazy var leftIconView = UIImageView()
        
        private lazy var textLabel = UILabel()
        
        private lazy var rightIconView = UIImageView()
        
        private lazy var interaction = Decorate.Interaction()
        private lazy var interactionLayer = interaction.layer
        
        private var longPressRecognizer: UILongPressGestureRecognizer?
        
        private var iconViewContraints: [NSLayoutConstraint] = []
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        private weak var delegate: TextButtonDelegate?
        
        /// TextButton 객체를 생성합니다.
        public init(text: String) {
            self.text = text
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
            let iconCount = [leftIcon, rightIcon].filter({ $0 != nil }).count
            
            let size = CGSize(
                width: iconSize.width * CGFloat(iconCount) + textSize.width,
                height: max(iconSize.height, textSize.height)
            )

            updateInteractionlayer(size)

            return size
        }
        
        /// Element의 터치 가능 영역을 조절합니다.
        public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let biggerFrame = bounds.insetBy(dx: -12, dy: -12)
            return biggerFrame.contains(point)
        }
    }
}

extension Button.UITextButton {
    private func setupViews() {
        addSubview(stackView)
        layer.addSublayer(interactionLayer)
        
        setupInteraction()
        setupStackView()
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
        interaction.layer.cornerRadius = variant.interactionRadius
        updateInteractionlayer(frame.size)
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
        
        let constraints = [
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        constraints.forEach({ $0.priority = .defaultLow })
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        layer.cornerRadius = variant.interactionRadius
    }
}

extension Button.UITextButton {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        updateColor()
        updateIconView()
        updateTextLabel()
        
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        let contentColor: UIColor = {
            if disable {
                variant.inactiveUIColor
            } else {
                if let contentUIColor {
                    contentUIColor
                } else {
                    variant.activeUIColor
                }
            }
        }()
        leftIconView.tintColor = contentColor
        rightIconView.tintColor = contentColor
        interaction.variant = variant.interactionVariant
        interaction.color = variant.interactionColor
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
    
    private func updateInteractionlayer(_ size: CGSize) {
        interactionLayer.frame = CGRect(
            origin: .init(
                x: -variant.interactionHorizontalOffset,
                y: -variant.interactionVerticalOffset
            ),
            size: .init(
                width: size.width + variant.interactionHorizontalOffset * 2,
                height: size.height + variant.interactionVerticalOffset * 2
            )
        )
    }
    
    private func getAttributedText() -> NSAttributedString {
        ._montage(
            text,
            variant: {
                if let fontSize {
                    fontSize
                } else {
                    size.typoVariant
                }
            }(),
            weight: .bold,
            color: {
                if disable {
                    variant.inactiveUIColor
                } else {
                    if let contentUIColor {
                        contentUIColor
                    } else {
                        variant.activeUIColor
                    }
                }
            }()
        )
    }
}

extension Button.UITextButton {
    @objc private func longPressed() {
        guard let recognizer = longPressRecognizer else { return }
        
        switch recognizer.state {
        case .began:
            interactionLayer.opacity = .opacity(.p022)
        case .changed:
            // 스크롤 시 버튼이 눌리지 않도록 state를 normal로 변경
            // 3D touch 모델은 스크롤 하지 않아도 changed가 실행되서 적용하지 않음
            if traitCollection.forceTouchCapability != UIForceTouchCapability.available
                && traitCollection.forceTouchCapability != UIForceTouchCapability.unavailable {
                interactionLayer.opacity = .opacity(.p100)
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
}

extension Button.UITextButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
