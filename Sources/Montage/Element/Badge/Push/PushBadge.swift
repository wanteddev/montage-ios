//
//  PushBadge.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/26.
//

import UIKit
import Pretendard

extension Badge {
    /// 특정 요소에 대한 알림을 표시할 수 있는 뱃지입니다
    public class Push: UIView {
        private enum Const {
            static let defaultDotSize: CGSize = .init(width: 4, height: 4)
            static let defaultNumberLimit: Int = 1000
        }
        
        public enum Variant: Equatable {
            case dot, new, number(Int)
        }
        
        /// 뱃지의 외관 값을 가져오거나 설정합니다.
        public var variant: Variant = .dot {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        private lazy var backgroundColorView = UIView()
        private lazy var stackView = UIStackView()
        private lazy var textLabel = UILabel()
        
        private var backgroundViewConstraints: [NSLayoutConstraint] = []
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
            guard let text = getAttributedText() else { 
                return .init(
                    width: Const.defaultDotSize.width + variant.edgeInsets.horizontal,
                    height: Const.defaultDotSize.height + variant.edgeInsets.vertical
                )
            }
            
            let textSize = text.size()
            let edgeInsets = variant.edgeInsets
            
            let width = textSize.width + edgeInsets.horizontal
            let height = textSize.height + edgeInsets.vertical

            return .init(
                width:  width < 20 ? 20 : width,
                height: height < 20 ? 20 : height
            )
        }
    }
}

extension Badge.Push {
    private func setupViews() {
        addSubview(backgroundColorView)
        addSubview(stackView)
        
        setupStackView()
        setupUpdateableConstraints()
        
        updateViews()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(textLabel)
    }
    
    private func setupUpdateableConstraints() {
        setupBackgroundColorViewConstraints()
        setupStackViewConstraints()
        updateConstraints()
        setupLayer()
    }
    
    private func setupBackgroundColorViewConstraints() {
        NSLayoutConstraint.deactivate(backgroundViewConstraints)
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = variant == .dot ? variant.edgeInsets : .zero
        
        let constraints = [
            backgroundColorView.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            backgroundColorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            backgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
        ]
        
        NSLayoutConstraint.activate(constraints)
        backgroundViewConstraints = constraints
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint]
        let insets = variant.edgeInsets
        
        switch variant {
        case .dot, .new:
            constraints = [
                stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        case .number:
            constraints = [
                stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: insets.left),
                stackView.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: -insets.right),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
        stackViewConstraints = constraints
    }
    
    private func setupLayer() {
        backgroundColorView.layer.cornerRadius = backgroundColorView.frame.height / 2
        backgroundColorView.layer.masksToBounds = true
    }
}

extension Badge.Push {
    private func updateViews() {
        updateColor()
        updateTextLabel()
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        backgroundColorView.backgroundColor = .alias(.primaryNormal)
    }
    
    private func updateTextLabel() {
        textLabel.isHidden = variant == .dot
        textLabel.attributedText = getAttributedText()
    }
}

extension Badge.Push {
    private func getText() -> String? {
        switch variant {
        case .dot: return nil
        case .new: return "N"
        case .number(let number):
            return number >= Const.defaultNumberLimit ? "999+" : "\(number)"
        }
    }
    
    private func getAttributedText() -> NSAttributedString? {
        guard let text = getText() else { return nil }
    
        let font = UIFont.montage(variant: .caption2, weight: .bold)
        let lineHeight = Typography.getLineHeight(variant: .caption2)
        
        let baselineOffset: CGFloat
        if #available(iOS 16.4, *) {
            baselineOffset = (lineHeight - font.lineHeight) / 2
        } else {
            baselineOffset = (lineHeight - font.lineHeight) / 2 / 2
        }
        
        let foregroundColor = UIColor.alias(.staticWhite)
        let tracking = Typography.getTracking(variant: .caption2)
        
        return .init(string: text, attributes: [
            .font: font,
            .tracking: tracking,
            .baselineOffset: baselineOffset,
            .foregroundColor: foregroundColor,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.minimumLineHeight = lineHeight
                style.lineBreakStrategy = .hangulWordPriority
                return style
            }()
        ])
    }
}

extension Badge.Push.Variant {
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .dot:
            return .init(top: 8, left: 8, bottom: 8, right: 8)
        case .number:
            return .init(top: 3, left: 6, bottom: 3, right: 6)
        case .new:
            return .init(top: 3, left: 6, bottom: 3, right: 6)
        }
    }
    
    /// PushBadge/Dot을 위치시킬 때 필요한 Offset입니다.
    /// > edgeInsets + (size / 2)
    var dotOffset: CGFloat {
        edgeInsets.insets.leading + (Badge.Push.Const.defaultDotSize.width / 2)
    }
}
