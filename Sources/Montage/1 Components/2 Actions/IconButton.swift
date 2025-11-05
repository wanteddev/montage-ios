//
//  IconButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

/// 다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.
///
/// 아이콘만 표시하는 간결한 버튼으로, 여러 변형과 스타일을 지원합니다:
/// - 기본형(normal): 배경 없이 아이콘만 표시
/// - 배경형(background): 반투명 배경을 가진 아이콘
/// - 외곽선형(outlined): 테두리로 둘러싸인 아이콘
/// - 솔리드형(solid): 배경색이 채워진 아이콘
///
/// ```swift
/// IconButton(
///     variant: .default,
///     icon: .arrowLeft,
///     handler: { print("뒤로 가기 버튼 탭됨") }
/// )
/// ```
public struct IconButton: View {
    @State private var isPressed = false
    
    private let variant: IconButton.Variant
    private let icon: Icon
    private let handler: (() -> Void)?
    
    /// 아이콘 버튼을 생성합니다.
    ///
    /// - Parameters:
    ///   - variant: 버튼의 외관 스타일, 기본값은 `.normal(size: 24)`
    ///   - icon: 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 아이콘 버튼 뷰
    public init(
        variant: IconButton.Variant = .normal(size: 24),
        icon: Icon,
        handler: (() -> Void)? = nil
    ) {
        self.variant = variant
        self.icon = icon
        self.disable = false
        self.showPushBadge = false
        self.padding = {
            switch variant {
            case .normal, .background: .zero
            case .outlined, .solid: .zero
            }
        }()
        self.iconColor = nil
        self.backgroundColor = nil
        self.borderColor = nil
        self.handler = handler
    }
    
    // MARK: - Modifiers
    
    private var disable: Bool
    private var showPushBadge: Bool
    private var padding: CGFloat
    private var iconColor: SwiftUI.Color?
    private var backgroundColor: SwiftUI.Color?
    private var borderColor: SwiftUI.Color?
    
    /// 버튼의 비활성화 여부를 설정합니다.
    /// - Parameter value: 비활성화 여부, true이면 버튼이 비활성화됩니다.
    /// - Returns: 수정된 IconButton 인스턴스
    public func disable(_ value: Bool = true) -> Self {
        var copy = self
        copy.disable = value
        return copy
    }
    
    /// 푸시 뱃지 표시 여부를 설정합니다.
    /// > normal variant에서만 사용 가능합니다.
    /// - Parameter value: 푸시 뱃지 표시 여부
    /// - Returns: 수정된 IconButton 인스턴스
    public func showPushBadge(_ value: Bool = true) -> Self {
        var copy = self
        copy.showPushBadge = {
            guard case .normal(_) = self.variant else { return false }
            return value
        }()
        return copy
    }
    
    /// 버튼의 패딩을 설정합니다.
    /// > outlined, soild variant에서만 사용 가능합니다.
    /// - Parameter value: 패딩 값
    /// - Returns: 수정된 IconButton 인스턴스
    public func padding(_ value: CGFloat) -> Self {
        var copy = self
        copy.padding = {
            switch self.variant {
            case .normal, .background: .zero
            case .outlined, .solid: value
            }
        }()
        return copy
    }
    
    /// 아이콘 색상을 설정합니다.
    /// - Parameter color: 설정할 색상
    /// - Returns: 수정된 IconButton 인스턴스
    public func iconColor(_ color: SwiftUI.Color) -> Self {
        var copy = self
        copy.iconColor = color
        return copy
    }
    
    /// 배경 색상을 설정합니다.
    /// > outlined, soild variant에서만 사용 가능합니다.
    /// - Parameter color: 설정할 색상
    /// - Returns: 수정된 IconButton 인스턴스
    public func backgroundColor(_ color: SwiftUI.Color) -> Self {
        var copy = self
        copy.backgroundColor = {
            switch self.variant {
            case .normal, .background: nil
            case .outlined, .solid: color
            }
        }()
        return copy
    }
    
    /// 테두리 색상을 설정합니다.
    /// > outlined 에서만 사용 가능합니다.
    /// - Parameter color: 설정할 색상
    /// - Returns: 수정된 IconButton 인스턴스
    public func borderColor(_ color: SwiftUI.Color) -> Self {
        var copy = self
        copy.borderColor = {
            guard case .outlined(_) = self.variant else { return nil }
            return color
        }()
        return copy
    }
    
    // MARK: Private Computed Property
    
    private var _iconColor: SwiftUI.Color {
        if disable {
            SwiftUI.Color(uiColor: variant.inactiveColor)
        } else {
            if let iconColor {
                iconColor
            } else {
                SwiftUI.Color(uiColor: variant.activeColor)
            }
        }
    }
    
    private var _strokeColor: SwiftUI.Color {
        if case .outlined(_) = variant, let borderColor {
            borderColor
        } else {
            SwiftUI.Color(uiColor: variant.borderColor)
        }
    }
    
    private var _backgroundColor: SwiftUI.Color {
        if disable {
            SwiftUI.Color(uiColor: variant.inactiveBackgroundColor)
        } else {
            if let backgroundColor {
                backgroundColor
            } else {
                SwiftUI.Color(uiColor: variant.activeBackgroundColor)
            }
        }
    }
    
    private var interactionOffset: CGFloat {
        variant.interactionOffset + padding
    }
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        Image.icon(icon)
            .resizable()
            .if(variant.isBackground) {
                $0.padding(2)
            } else: {
                $0
            }
            .frame(
                width: variant.iconSize.width,
                height: variant.iconSize.height
            )
            .foregroundStyle(_iconColor)
            .if(showPushBadge) {
                $0.pushBadge()
            }
            .background {
                Interaction(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(Circle())
                .padding(.vertical, -interactionOffset)
                .padding(.horizontal, -interactionOffset)
            }
            .padding(.all, variant.backgroundOffset + padding)
            .background(
                ZStack {
                    Circle()
                        .fill(_backgroundColor)
                    if case let .background(_, alternative) = variant, alternative == false {
                        Circle()
                            .fill(.regularMaterial)
                    }
                    Circle()
                        .stroke(_strokeColor, lineWidth: variant.borderWidth)
                }
            )
            .frame(
                width: variant.iconSize.width + variant.backgroundOffset + padding,
                height: variant.iconSize.height + variant.backgroundOffset + padding
            )
            .allowsHitTesting(disable == false)
            .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
    }
}

extension IconButton {
    /// 버튼의 외관을 결정하는 열거형입니다.
    ///
    /// 아이콘 버튼의 다양한 스타일과 크기를 정의합니다.
    public enum Variant {
        /// 기본형 아이콘 버튼 - 배경 없이 아이콘만 표시
        /// - Parameter size: 아이콘 크기 (픽셀)
        case normal(size: Int)
        
        /// 배경형 아이콘 버튼 - 반투명 배경을 가진 아이콘
        /// - Parameters:
        ///   - size: 아이콘 크기 (픽셀)
        ///   - isAlternative: 대체 스타일 사용 여부, 기본값은 `false`
        case background(size: Int, isAlternative: Bool = false)
        
        /// 외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘
        /// - Parameter size: 아이콘 크기 (Size 열거형)
        case outlined(size: Size)
        
        /// 솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘
        /// - Parameter size: 아이콘 크기 (Size 열거형)
        case solid(size: Size)
        
        fileprivate var isBackground: Bool {
            switch self {
            case .background: true
            default: false
            }
        }
    }
    
    /// 버튼 사이즈를 결정하는 열거형입니다.
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 사용자 지정 크기
        /// - Parameter size: 아이콘 크기 (픽셀)
        case custom(size: Int)
    }
}

extension IconButton.Variant {
    var activeBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
                .clear
        case .background(_, let isAlternative):
            if isAlternative {
                .atomic(.coolNeutral30).withAlphaComponent(0.61)
            } else {
                // material이 적용되어 있기 때문에 값에 무관
                .clear
            }
        case .solid:
                .semantic(.primaryNormal)
        }
    }
    
    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
                .clear
        case .background:
                .semantic(.fillAlternative).withAlphaComponent(0.05)
        case .solid:
                .semantic(.fillNormal).withAlphaComponent(0.08)
        }
    }
    
    var activeColor: UIColor {
        switch self {
        case .normal, .outlined: .semantic(.labelNormal)
        case .background(_, let isAlternative):
            if isAlternative {
                .semantic(.staticWhite).withAlphaComponent(0.88)
            } else {
                .atomic(.coolNeutral50).withAlphaComponent(0.74)
            }
        case .solid: .semantic(.staticWhite)
        }
    }
    
    var inactiveColor: UIColor {
        switch self {
        case .normal, .outlined, .solid:
                .semantic(.labelDisable).withAlphaComponent(0.16)
        case .background:
                .atomic(.coolNeutral50).withAlphaComponent(0.22)
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
        case .outlined: .semantic(.lineNeutral)
        default: .clear
        }
    }
    
    var interactionColor: Color.Semantic {
        .labelNormal
    }
    
    var interactionVariant: Interaction.Variant {
        switch self {
        case .normal, .outlined: .light
        case .background(_, let isAlternative):
            isAlternative ? .normal : .light
        case .solid: .strong
        }
    }
    
    var backgroundOffset: CGFloat {
        switch self {
        case .normal: .zero
        case .background(_, _): 6
        case let .outlined(size), let .solid(size):
            switch size {
            case .small: 7
            case .medium: 10
            case .custom(_): 6
            }
        }
    }
    
    var interactionOffset: CGFloat {
        switch self {
        case .normal: 8
        case .background(_, _), .outlined(_), .solid(_): backgroundOffset
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .normal(let size): .init(width: size, height: size)
        case .background(let size, _): .init(width: size, height: size)
        case .outlined(let variant), .solid(let variant):
            switch variant {
            case .small:
                    .init(width: 18, height: 18)
            case .medium:
                    .init(width: 20, height: 20)
            case .custom(let size):
                    .init(width: size, height: size)
            }
        }
    }
}
