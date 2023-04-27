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
        }
        
        public enum Varient: Equatable {
            case dot, new, number(Int)
        }
        
        public var varient: Varient = .dot {
            didSet {
                setupUpdateableConstraints()
                updateViews()
            }
        }
        
        private lazy var stackView = UIStackView()
        private lazy var textLabel = UILabel()
        
        private var stackViewConstraints: [NSLayoutConstraint] = []
        
        /// Push 뱃지 객체를 생성합니다.
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
            guard let text = getAttributedText() else { return Const.defaultDotSize }
            
            let textSize = text.size()
            let edgeInsets = varient.edgeInsets
            
            return .init(
                width: textSize.width + edgeInsets.horizontal,
                height: textSize.height + edgeInsets.vertical
            )
        }
    }
}

extension Badge.Push {
    private func setupViews() {
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
        setupStackViewConstraints()
        updateConstraints()
        setupLayer()
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackViewConstraints)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = varient.edgeInsets
        
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
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

extension Badge.Push {
    private func updateViews() {
        updateColor()
        updateTextLabel()
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        backgroundColor = .alias(.primaryNormal)
    }
    
    private func updateTextLabel() {
        textLabel.isHidden = varient == .dot
        textLabel.attributedText = getAttributedText()
    }
}

extension Badge.Push {
    private func getAttributedText() -> NSAttributedString? {
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9.0, weight: .bold),
            .foregroundColor: UIColor.alias(.staticWhite),
            .kern: 0.28,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.lineHeightMultiple = 1.07
                return style
            }()
        ]
        
        switch varient {
        case .dot:
            return nil
        case .new:
            return .init(string: "N", attributes: attribute)
        case .number(let number):
            return .init(string: "\(number)", attributes: attribute)
        }
    }
}

extension Badge.Push.Varient {
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .dot:
            return .init(top: 2, left: 2, bottom: 2, right: 2)
        case .number:
            return .init(top: 2, left: 5.5, bottom: 2, right: 5.5)
        case .new:
            return .init(top: 2, left: 4.5, bottom: 2, right: 4.5)
        }
    }
}
