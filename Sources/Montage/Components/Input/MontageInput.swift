//
//  MontageInputLabel.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/07.
//

import UIKit

extension Montage {
    /// Input 요소들의 필수 요건을 정의한 프로토콜입니다.
    public class InputLabel: UIView {
        private enum Const {
            static let inputSize: CGSize = .init(width: 24, height: 24)
        }
        
        private var elementView: MontageInput
        
        private var textWrapperView = UIView()
        
        private var textLabel: UILabel = {
            let view = UILabel()
            view.numberOfLines = 0
            return view
        }()
        
        /// Input 요소의 외관을 결정짓는 State 입니다.
        public var state: MontageInputState {
            get { elementView.state }
            set { elementView.state = newValue }
        }
        
        /// Input 요소를 설명하는 텍스트입니다.
        public var text: String? {
            get { textLabel.attributedText?.string }
            set { textLabel.attributedText = .montage(newValue ?? "") }
        }
        
        /// Input 요소에서 발생하는 이벤트를 수신하는 delegate 객체입니다.
        public weak var delegate: MontageInputDelegate? {
            didSet {
                bindEvent()
            }
        }
        
        private var tapRecognizer: UITapGestureRecognizer?
        
        public init(with input: MontageInput) {
            self.elementView = input
            super.init(frame: .zero)
            
            setupViews()
            bindEvent()
        }
        
        required init?(coder: NSCoder) {
            self.elementView = Radio()
            super.init(coder: coder)
            
            setupViews()
            bindEvent()
        }
    }
}

extension Montage.InputLabel {
    private func setupViews() {
        let lineHeight = NSAttributedString.montage("").size().height
        let textTopInset = (Const.inputSize.height - lineHeight) / 2
        
        addSubview(elementView)
        addSubview(textLabel)
        
        elementView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        elementView.leftAnchor
            .constraint(equalTo: leftAnchor).isActive = true
        elementView.centerYAnchor
            .constraint(equalTo: textLabel.firstBaselineAnchor, constant: -textTopInset).isActive = true
        
        textLabel.topAnchor
            .constraint(equalTo: topAnchor).isActive = true
        textLabel.leftAnchor
            .constraint(equalTo: elementView.rightAnchor, constant: .spacing(.pt08)).isActive = true
        textLabel.rightAnchor
            .constraint(equalTo: rightAnchor).isActive = true
        textLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor).isActive = true
        
        elementView.isUserInteractionEnabled = false
    }
    
    private func bindEvent() {
        guard delegate != nil else { return }
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(recognizer)
        tapRecognizer = recognizer
    }
    
    @objc private func tapped() {
        delegate?.inputDidSelected(self)
    }
}

public protocol MontageInput: UIView {
    var state: MontageInputState { get set }
}

/// Input 요소들에서 사용할 수 있는 State를 정의합니다.
public enum MontageInputState {
    case unchecked
    case checked
    case partial
}

/// Input 요소들의 이벤트를 받을 수 있는 Delegate 프로토콜입니다.
public protocol MontageInputDelegate: AnyObject {
    func inputDidSelected(_ input: Montage.InputLabel)
}
