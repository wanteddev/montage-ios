//
//  InputLabel.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/07.
//

import UIKit

/// Input 요소들의 이벤트를 받을 수 있는 Delegate 프로토콜입니다.
public protocol InputDelegate: AnyObject {
    /// 터치가 발생하였을 때 호출되는 메소드입니다.
    /// - Parameter input: 터치가 발생한 객체
    func inputDidSelected(_ input: InputLabel)
}

/// Control Element와 텍스트 라벨을 함께 담고 있는 컴포넌트입니다.
public class InputLabel: UIView {
    private var elementView: MontageControl
    
    private var textWrapperView = UIView()
    
    private var textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    /// Input 요소의 외관을 결정짓는 State 입니다.
    public var state: MontageControlState {
        get { elementView.state }
        set { elementView.state = newValue }
    }
    
    public var bold: Bool = false {
        didSet {
            updateViews()
        }
    }
    
    public var disable: Bool = false {
        didSet {
            updateViews()
        }
    }
    
    /// Input 요소를 설명하는 텍스트입니다.
    public var text: String? {
        didSet {
            updateViews()
        }
    }
    
    /// Input 요소에서 발생하는 이벤트를 수신하는 delegate 객체입니다.
    public weak var delegate: InputDelegate? {
        didSet {
            bindEvent()
        }
    }
    
    private var tapRecognizer: UITapGestureRecognizer?
    
    public init(with input: MontageControl) {
        self.elementView = input
        super.init(frame: .zero)
        
        setupViews()
        bindEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Element의 기본적인 사이즈를 정의합니다.
    override public var intrinsicContentSize: CGSize {
        .init(width: elementView.intrinsicContentSize.width + elementSpacing + textLabel.intrinsicContentSize.width, height: elementView.intrinsicContentSize.height)
    }
}

extension InputLabel {
    private func setupViews() {
        let lineHeight = Typography.getLineHeight(variant: textVariant)
        let textTopInset = (lineHeight - elementView.intrinsicContentSize.height) / 2
        
        addSubview(elementView)
        addSubview(textLabel)
        
        elementView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        elementView.leftAnchor
            .constraint(equalTo: leftAnchor).isActive = true
        elementView.topAnchor
            .constraint(equalTo: topAnchor, constant: textTopInset).isActive = true
        
        textLabel.topAnchor
            .constraint(equalTo: topAnchor).isActive = true
        textLabel.leftAnchor
            .constraint(equalTo: elementView.rightAnchor, constant: elementSpacing).isActive = true
        textLabel.rightAnchor
            .constraint(equalTo: rightAnchor).isActive = true
        textLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor).isActive = true
        
        elementView.isUserInteractionEnabled = false
    }
    
    var elementSpacing: CGFloat {
        if elementView is Control.Check {
            .spacing(.pt04)
        } else {
            .spacing(.pt08)
        }
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

extension InputLabel {
    private func updateViews() {
        isUserInteractionEnabled = false == disable
        
        elementView.disable = disable
        textLabel.attributedText = .montage(
            text ?? "",
            variant: textVariant,
            weight: bold ? .bold : .regular,
            alias: disable ? .labelDisable : .labelNormal
        )
    }
}

extension InputLabel {
    var textVariant: Typography.Variant {
        switch elementView.size {
        case .normal:
            return .body2
        case .small:
            return .label1
        }
    }
}

/// 디자인시스템의 Input 요소들이 공통으로 가질 수 있는 프로퍼티를 정의한 프로토콜입니다.
public protocol MontageControl: UIView {
    var state: MontageControlState { get set }
    var size: MontageControlSize { get }
    var disable: Bool { get set }
    var intrinsicContentSize: CGSize { get }
}

/// Input 요소들에서 사용할 수 있는 State를 정의합니다.
public enum MontageControlState {
    case unchecked
    case checked
    case indeterminate
}

public enum MontageControlSize {
    case normal
    case small
}
