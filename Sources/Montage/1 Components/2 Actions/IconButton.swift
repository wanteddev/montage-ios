//
//  IconButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

/// 다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.
///
/// 아이콘만 표시하는 간결한 버튼으로, 네 가지 variant를 지원합니다:
/// - 기본형(normal): 배경 없이 아이콘만 표시
/// - 배경형(background): 반투명·블러 배경 위 floating 액션
/// - 외곽선형(outlined): 테두리만 가진 보조 액션
/// - 솔리드형(solid): 채워진 배경의 강조 액션
///
/// **Size 모델**
/// - `normal` / `background`: _아이콘 크기_를 지정합니다. 컨테이너는
///   `nearestDimensionToken(icon × 1.5)` 으로 자동 산출되며, `normal`은
///   WCAG 2.2 SC 2.5.8 Target Size를 위해 박스 최소 24×24가 보장됩니다.
///   `normal`의 corner radius는 `nearestRadiusToken(box × 0.3, tie→down)`.
/// - `outlined` / `solid`: _컨테이너 크기_를 지정합니다. 아이콘은 `box − 12`
///   로 자동 산출되며 박스 최소 24×24가 보장됩니다.
///
/// hit area는 항상 컨테이너와 동일합니다(이전의 확장된 hit area 정책 제거).
///
/// ```swift
/// IconButton(
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
    ///   - variant: 버튼의 외관 스타일, 생략하면 기본값으로 `.normal(size: .xlarge)` 적용
    ///   - icon: 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 아이콘 버튼 뷰
    public init(
        variant: IconButton.Variant = .normal(size: .xlarge),
        icon: Icon,
        handler: (() -> Void)? = nil
    ) {
        self.variant = variant
        self.icon = icon
        self.disable = false
        self.showPushBadge = false
        self.padding = .zero
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
            guard case .normal = self.variant else { return false }
            return value
        }()
        return copy
    }

    /// 버튼의 추가 패딩을 설정합니다(컨테이너 외곽을 그만큼 확장).
    /// > outlined, solid variant에서만 사용 가능합니다.
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
    /// > outlined, solid variant에서만 사용 가능합니다.
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
            guard case .outlined = self.variant else { return nil }
            return color
        }()
        return copy
    }

    // MARK: - Resolved values

    private var resolvedIconSize: CGFloat { variant.iconSize }

    private var resolvedContainerSize: CGFloat {
        variant.containerSize + padding * 2
    }

    private var resolvedCornerRadius: CGFloat {
        switch variant {
        case .normal:
            return variant.cornerRadius
        case .background, .outlined, .solid:
            return resolvedContainerSize / 2
        }
    }

    private var _iconColor: SwiftUI.Color {
        if disable {
            return SwiftUI.Color(uiColor: variant.inactiveColor)
        }
        if let iconColor {
            return iconColor
        }
        return SwiftUI.Color(uiColor: variant.activeColor)
    }

    private var _strokeColor: SwiftUI.Color {
        if case .outlined = variant, let borderColor {
            return borderColor
        }
        return SwiftUI.Color(uiColor: variant.borderColor)
    }

    private var _backgroundColor: SwiftUI.Color {
        if disable {
            return SwiftUI.Color(uiColor: variant.inactiveBackgroundColor)
        }
        if let backgroundColor {
            return backgroundColor
        }
        return SwiftUI.Color(uiColor: variant.activeBackgroundColor)
    }

    private var showsRegularMaterial: Bool {
        guard case let .background(_, isAlternative) = variant else { return false }
        return !isAlternative && !disable
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack {
            if showsRegularMaterial {
                RoundedRectangle(cornerRadius: resolvedCornerRadius)
                    .fill(.regularMaterial)
            }
            RoundedRectangle(cornerRadius: resolvedCornerRadius)
                .fill(_backgroundColor)
            if variant.borderWidth > 0 {
                RoundedRectangle(cornerRadius: resolvedCornerRadius)
                    .strokeBorder(_strokeColor, lineWidth: variant.borderWidth)
            }
            Image.icon(icon)
                .resizable()
                .frame(width: resolvedIconSize, height: resolvedIconSize)
                .foregroundStyle(_iconColor)
                .if(showPushBadge) {
                    $0.pushBadge()
                } else: {
                    $0
                }
            Interaction(
                state: isPressed ? .pressed : .normal,
                variant: variant.interactionVariant,
                color: variant.interactionColor
            )
            .clipShape(RoundedRectangle(cornerRadius: resolvedCornerRadius))
        }
        .frame(width: resolvedContainerSize, height: resolvedContainerSize)
        .contentShape(RoundedRectangle(cornerRadius: resolvedCornerRadius))
        .allowsHitTesting(disable == false)
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(icon.rawValue) \(String(localized: "아이콘", bundle: .module))")
        .accessibilityAddTraits(.isButton)
    }
}

extension IconButton {
    /// 버튼의 외관을 결정하는 열거형입니다.
    ///
    /// 아이콘 버튼의 다양한 스타일과 크기를 정의합니다.
    public enum Variant {
        /// 기본형 아이콘 버튼 - 배경 없이 아이콘만 표시
        /// - Parameter size: 아이콘 크기 (`NormalSize`)
        case normal(size: NormalSize)

        /// 배경형 아이콘 버튼 - 반투명·블러 배경을 가진 floating 액션
        /// - Parameters:
        ///   - size: 아이콘 크기 (포인트). 생략하면 `20`이 적용됩니다.
        ///   - isAlternative: 다크 배경 위에서 사용하는 대체 스타일 여부, 생략하면 `false`
        case background(size: Int = 20, isAlternative: Bool = false)

        /// 외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘
        /// - Parameter size: 컨테이너 크기 (`Size`). 아이콘은 `box − 12`로 자동 산출됩니다.
        case outlined(size: Size)

        /// 솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘
        /// - Parameter size: 컨테이너 크기 (`Size`). 아이콘은 `box − 12`로 자동 산출됩니다.
        case solid(size: Size)
    }

    /// `normal` variant의 아이콘 사이즈를 결정하는 열거형입니다.
    public enum NormalSize {
        /// 작은 크기 (16pt)
        case small
        /// 중간 크기 (18pt)
        case medium
        /// 큰 크기 (20pt)
        case large
        /// 가장 큰 크기 (24pt)
        case xlarge
        /// 사용자 지정 크기
        /// - Parameter size: 아이콘 크기 (포인트)
        case custom(size: Int)

        fileprivate var points: Int {
            switch self {
            case .small: 16
            case .medium: 18
            case .large: 20
            case .xlarge: 24
            case .custom(let size): size
            }
        }
    }

    /// `outlined`·`solid` variant의 컨테이너 사이즈를 결정하는 열거형입니다.
    public enum Size {
        /// 작은 크기 (32×32, 아이콘 16pt)
        case small
        /// 중간 크기 (40×40, 아이콘 18pt)
        case medium
        /// 사용자 지정 크기
        /// - Parameter size: 컨테이너 크기 (포인트). `box < 24`이면 24로 clamp됩니다.
        case custom(size: Int)
    }
}

extension IconButton.Variant {
    /// 컨테이너 한 변의 크기(아이콘이 차지하는 영역 + 자동 패딩).
    var containerSize: CGFloat {
        switch self {
        case .normal(let size):
            let raw = CGFloat(size.points) * 1.5
            return max(.dimension24, IconButton.nearestDimensionToken(raw))
        case .background(let size, _):
            let raw = CGFloat(size) * 1.5
            return IconButton.nearestDimensionToken(raw)
        case .outlined(let s), .solid(let s):
            switch s {
            case .small: return .dimension32
            case .medium: return .dimension40
            case .custom(let n): return max(.dimension24, CGFloat(n))
            }
        }
    }

    /// 아이콘이 차지하는 한 변의 크기.
    var iconSize: CGFloat {
        switch self {
        case .normal(let size):
            return CGFloat(size.points)
        case .background(let size, _):
            return CGFloat(size)
        case .outlined(let s), .solid(let s):
            switch s {
            case .small: return .dimension16
            case .medium: return .dimension18
            case .custom(let n):
                // box = max(24, n). icon = max(0, box − 12).
                let box = max(.dimension24, CGFloat(n))
                return max(0, box - 12)
            }
        }
    }

    /// `normal` variant에서만 사용되는 corner radius.
    /// `nearestRadiusToken(container × 0.3, tie→down)` 으로 산출.
    var cornerRadius: CGFloat {
        guard case .normal = self else { return 0 }
        return IconButton.nearestRadiusToken(containerSize * 0.3)
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

    var activeBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background(_, let isAlternative):
            if isAlternative {
                return .atomic(.coolNeutral30).withAlphaComponent(0.61)
            } else {
                // regularMaterial 위에 그리므로 값에 무관
                return .clear
            }
        case .solid:
            return .semantic(.primaryNormal)
        }
    }

    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal:
            return .clear
        case .background:
            return .semantic(.fillAlternative)
        case .outlined:
            return .semantic(.backgroundNormal)
        case .solid:
            return .semantic(.fillNormal)
        }
    }

    var activeColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .semantic(.labelNormal)
        case .background(_, let isAlternative):
            if isAlternative {
                return .semantic(.staticWhite).withAlphaComponent(0.88)
            } else {
                return .atomic(.coolNeutral50).withAlphaComponent(0.61)
            }
        case .solid:
            return .semantic(.staticWhite)
        }
    }

    var inactiveColor: UIColor {
        switch self {
        case .normal, .outlined, .solid:
            return .semantic(.labelDisable)
        case .background:
            return .atomic(.coolNeutral50).withAlphaComponent(0.22)
        }
    }

    var interactionColor: Color.Semantic {
        .labelNormal
    }

    var interactionVariant: Interaction.Variant {
        switch self {
        case .normal, .outlined:
            return .light
        case .background(_, let isAlternative):
            return isAlternative ? .normal : .light
        case .solid:
            return .strong
        }
    }
}

private extension IconButton {
    /// dimension 토큰 배열에서 `raw`에 가장 가까운 값을 반환합니다. 동률이면 위로 올림.
    static func nearestDimensionToken(_ raw: CGFloat) -> CGFloat {
        let tokens: [CGFloat] = [
            .dimension14, .dimension16, .dimension18, .dimension20,
            .dimension24, .dimension28, .dimension32, .dimension36,
            .dimension40, .dimension48, .dimension56, .dimension64
        ]
        return nearestToken(raw, in: tokens, tieGoesUp: true)
    }

    /// radius 토큰 배열에서 `raw`에 가장 가까운 값을 반환합니다. 동률이면 아래로 내림.
    static func nearestRadiusToken(_ raw: CGFloat) -> CGFloat {
        let tokens: [CGFloat] = [
            .radius0, .radius4, .radius8, .radius10, .radius12,
            .radius14, .radius16, .radius20, .radius24
        ]
        return nearestToken(raw, in: tokens, tieGoesUp: false)
    }

    static func nearestToken(_ raw: CGFloat, in tokens: [CGFloat], tieGoesUp: Bool) -> CGFloat {
        guard var best = tokens.first else { return raw }
        var bestDiff = abs(raw - best)
        for token in tokens.dropFirst() {
            let diff = abs(raw - token)
            if diff < bestDiff {
                best = token
                bestDiff = diff
            } else if diff == bestDiff {
                best = tieGoesUp ? max(best, token) : min(best, token)
            }
        }
        return best
    }
}
