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
/// 모든 variant의 컨테이너(터치 영역 포함)는 24~64pt 사이에서 커스텀 사이즈로 지정할 수 있습니다.
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
        self.extraPadding = .zero
        self.iconColor = nil
        self.backgroundColor = nil
        self.borderColor = nil
        self.handler = handler
    }

    // MARK: - Modifiers

    private var disable: Bool
    private var showPushBadge: Bool
    private var extraPadding: CGFloat
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
        copy.extraPadding = {
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
        if case .outlined = variant, let borderColor {
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

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        let m = variant.metrics
        let containerSize = m.container + 2 * extraPadding
        let totalPadding = m.padding + extraPadding

        Image.icon(icon)
            .resizable()
            .frame(width: m.icon, height: m.icon)
            .foregroundStyle(_iconColor)
            .if(showPushBadge) {
                $0.pushBadge()
            } else: {
                $0
            }
            .padding(totalPadding)
            .background {
                Interaction(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(RoundedRectangle(cornerRadius: m.radius))
            }
            .background {
                backgroundLayer(metrics: m)
            }
            .frame(width: containerSize, height: containerSize)
            .allowsHitTesting(disable == false)
            .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(icon.rawValue) \(String(localized: "아이콘", bundle: .module))")
            .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private func backgroundLayer(metrics m: IconButton.Variant.Metrics) -> some View {
        let shape = RoundedRectangle(cornerRadius: m.radius)
        switch variant {
        case .normal:
            EmptyView()
        case .background(_, let alternative):
            ZStack {
                shape.fill(_backgroundColor)
                if alternative == false {
                    shape.fill(.regularMaterial)
                }
            }
        case .outlined:
            ZStack {
                shape.fill(_backgroundColor)
                shape.stroke(_strokeColor, lineWidth: 1)
            }
        case .solid:
            shape.fill(_backgroundColor)
        }
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

        /// 배경형 아이콘 버튼 - 반투명 배경을 가진 원형 아이콘
        /// - Parameters:
        ///   - size: 컨테이너 한 변의 크기(포인트). 생략하면 기본값 `32`(컨테이너 32 / 아이콘 20).
        ///     `[24, 64]` 범위로 클램프되며, `32`가 아닌 값은 커스텀 사이즈 규칙으로 계산된다.
        ///   - isAlternative: 대체 스타일 사용 여부, 생략하면 기본값으로 `false` 적용
        case background(size: Int = 32, isAlternative: Bool = false)

        /// 외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘
        /// - Parameter size: 아이콘 크기 (`Size`)
        case outlined(size: Size)

        /// 솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘
        /// - Parameter size: 아이콘 크기 (`Size`)
        case solid(size: Size)
    }

    /// Normal variant의 아이콘 사이즈를 결정하는 열거형입니다.
    public enum NormalSize {
        /// 작은 크기 (컨테이너 24pt / 아이콘 16pt / radius 8)
        case small
        /// 중간 크기 (컨테이너 28pt / 아이콘 18pt / radius 8)
        case medium
        /// 큰 크기 (컨테이너 32pt / 아이콘 20pt / radius 10)
        case large
        /// 가장 큰 크기 (컨테이너 36pt / 아이콘 24pt / radius 10)
        case xlarge
        /// 사용자 지정 크기. 컨테이너는 `[24, 64]` 범위로 클램프된다.
        /// - Parameter size: 컨테이너 한 변의 크기(포인트)
        case custom(size: Int)
    }

    /// 버튼 사이즈를 결정하는 열거형입니다.
    public enum Size {
        /// 작은 크기 (컨테이너 32pt / 아이콘 16pt / 원형)
        case small
        /// 중간 크기 (컨테이너 40pt / 아이콘 18pt / 원형)
        case medium
        /// 사용자 지정 크기. 컨테이너는 `[24, 64]` 범위로 클램프된다.
        /// - Parameter size: 컨테이너 한 변의 크기(포인트)
        case custom(size: Int)
    }
}

extension IconButton.Variant {
    /// 아이콘 버튼의 레이아웃 메트릭(컨테이너/패딩/라운드 반경/아이콘 크기).
    struct Metrics {
        var container: CGFloat
        var padding: CGFloat
        var radius: CGFloat
        var icon: CGFloat
    }

    var metrics: Metrics {
        switch self {
        case .normal(let size):
            switch size {
            case .small:  return Self.makeMetrics(container: .dimension24, icon: .dimension16, radius: .radius8)
            case .medium: return Self.makeMetrics(container: .dimension28, icon: .dimension18, radius: .radius8)
            case .large:  return Self.makeMetrics(container: .dimension32, icon: .dimension20, radius: .radius10)
            case .xlarge: return Self.makeMetrics(container: .dimension36, icon: .dimension24, radius: .radius10)
            case .custom(let n):
                let container = Self.clampedContainer(n)
                let icon = Self.nearestToken(container * (2.0 / 3.0), in: Self.dimensionTokens, tieBreak: .down)
                let radius = Self.nearestToken(container * 0.3, in: Self.radiusTokens, tieBreak: .down)
                return Self.makeMetrics(container: container, icon: icon, radius: radius)
            }
        case .background(let size, _):
            if CGFloat(size) == .dimension32 {
                return Self.makeMetrics(container: .dimension32, icon: .dimension20, radius: .primitiveInfinity)
            }
            let container = Self.clampedContainer(size)
            let icon = Self.nearestToken(container * (2.0 / 3.0), in: Self.dimensionTokens, tieBreak: .down)
            return Self.makeMetrics(container: container, icon: icon, radius: .primitiveInfinity)
        case .outlined(let size), .solid(let size):
            switch size {
            case .small:  return Self.makeMetrics(container: .dimension32, icon: .dimension16, radius: .primitiveInfinity)
            case .medium: return Self.makeMetrics(container: .dimension40, icon: .dimension18, radius: .primitiveInfinity)
            case .custom(let n):
                let container = Self.clampedContainer(n)
                let icon = Self.nearestToken(container * 0.47, in: Self.dimensionTokens, tieBreak: .down)
                return Self.makeMetrics(container: container, icon: icon, radius: .primitiveInfinity)
            }
        }
    }

    private static let dimensionTokens: [CGFloat] = [
        .dimension12, .dimension14, .dimension16, .dimension18, .dimension20,
        .dimension24, .dimension28, .dimension32, .dimension36, .dimension40,
        .dimension48, .dimension56, .dimension64
    ]

    private static let radiusTokens: [CGFloat] = [
        .radius0, .radius4, .radius8, .radius10, .radius12, .radius14,
        .radius16, .radius20, .radius24
    ]

    /// 컨테이너 한 변의 크기는 `[24, 64]`로 클램프된다.
    private static func clampedContainer(_ n: Int) -> CGFloat {
        min(64, max(24, CGFloat(n)))
    }

    /// 컨테이너/아이콘 크기로부터 패딩을 도출해 Metrics 를 구성한다. 아이콘은 컨테이너 중앙에 배치된다.
    private static func makeMetrics(container: CGFloat, icon: CGFloat, radius: CGFloat) -> Metrics {
        Metrics(
            container: container,
            padding: (container - icon) / 2,
            radius: radius,
            icon: icon
        )
    }

    private enum TieBreak {
        case up
        case down
    }

    private static func nearestToken(
        _ value: CGFloat,
        in tokens: [CGFloat],
        tieBreak: TieBreak
    ) -> CGFloat {
        guard var best = tokens.first else { return 0 }
        var bestDist = abs(value - best)
        for token in tokens.dropFirst() {
            let d = abs(value - token)
            if d < bestDist {
                best = token
                bestDist = d
            } else if d == bestDist {
                switch tieBreak {
                case .up:   if token > best { best = token }
                case .down: if token < best { best = token }
                }
            }
        }
        return best
    }

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
            .semantic(.labelDisable)
        case .background:
            .atomic(.coolNeutral50).withAlphaComponent(0.22)
        }
    }

    var borderColor: UIColor {
        switch self {
        case .outlined: .semantic(.lineNeutral).withAlphaComponent(0.16)
        default: .clear
        }
    }

    var interactionColor: Color.Semantic {
        .labelNormal
    }

    var interactionVariant: Interaction.Variant {
        switch self {
        case .normal, .outlined: .light
        case .background(_, let isAlternative): isAlternative ? .normal : .light
        case .solid: .strong
        }
    }
}
