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
///
/// // 비활성화
/// IconButton(icon: .bell)
///     .disabled(true)
///
/// // 인터랙션 레이어 대신 아이콘 색으로 press 피드백
/// IconButton(icon: .search)
///     .interactionEffect(.tint)
/// ```
///
/// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
/// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
public struct IconButton: View {
    @Environment(\.isEnabled) private var isEnabled
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
        self.interactionEffect = .normal
        self.showPushBadge = false
        self.extraPadding = .zero
        self.iconColor = nil
        self.backgroundColor = nil
        self.borderColor = nil
        self.customInteractionColor = nil
        self.handler = handler
    }

    // MARK: - Modifiers

    private var interactionEffect: IconButton.InteractionEffect
    private var showPushBadge: Bool
    private var extraPadding: CGFloat
    private var iconColor: SwiftUI.Color?
    private var backgroundColor: SwiftUI.Color?
    private var borderColor: SwiftUI.Color?
    private var customInteractionColor: Color.Semantic?

    /// press 피드백을 어떤 방식으로 줄지 설정합니다(기본값: `.normal`).
    ///
    /// 세 값 모두 터치 영역은 같습니다. 레이어는 시각만 감추고 히트 영역은 그대로 유지합니다.
    /// 피드백 색상은 `.normal`·`.tint` 모두 `interactionColor(_:)`로 바꿀 수 있습니다.
    ///
    /// > `.tint`는 `normal` variant에서만 동작합니다. 다른 variant에 넘기면 `.normal`로 처리됩니다.
    /// - Parameter effect: 인터랙션 피드백 방식
    /// - Returns: 수정된 IconButton 인스턴스
    public func interactionEffect(_ effect: IconButton.InteractionEffect) -> Self {
        var copy = self
        copy.interactionEffect = {
            guard case .tint = effect else { return effect }
            guard case .normal = self.variant else { return .normal }
            return .tint
        }()
        return copy
    }

    /// press 피드백에 사용할 색상을 설정합니다.
    ///
    /// `interactionEffect(_:)` 값에 따라 적용 대상이 다릅니다.
    /// - `.normal`: 아이콘 뒤 인터랙션 레이어에 적용됩니다. 지정하지 않으면 `.foregroundNeutralPrimary`
    /// - `.tint`: 아이콘 색에 적용됩니다. 지정하지 않으면 `.foregroundNeutralQuaternary`
    /// - `.none`: 피드백이 없어 적용되지 않습니다
    /// - Parameter color: 인터랙션 색상(semantic 토큰)
    /// - Returns: 수정된 IconButton 인스턴스
    public func interactionColor(_ color: Color.Semantic) -> Self {
        var copy = self
        copy.customInteractionColor = color
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

    private var isDisabled: Bool { isEnabled == false }

    /// 아이콘 색으로 press 피드백을 주는 중인지 여부.
    private var isTinted: Bool {
        guard case .tint = interactionEffect else { return false }
        return isPressed && !isDisabled
    }

    /// 인터랙션 레이어의 상태. `.tint`·`.none`에서는 항상 `.normal`이라 레이어가 보이지 않지만,
    /// 레이어 자체는 터치 영역을 잡아주므로 걷어내지 않는다.
    private var interactionState: Interaction.State {
        guard case .normal = interactionEffect else { return .normal }
        return (isPressed && !isDisabled) ? .pressed : .normal
    }

    private var _iconColor: SwiftUI.Color {
        if isDisabled {
            SwiftUI.Color(uiColor: variant.disabledIconColor)
        } else if isTinted {
            // iconColor(_:)로 지정한 색이 아니라 인터랙션 색을 쓴다.
            SwiftUI.Color.semantic(customInteractionColor ?? .foregroundNeutralQuaternary)
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
        if isDisabled {
            SwiftUI.Color(uiColor: variant.disabledBackgroundColor)
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
                    state: interactionState,
                    variant: variant.interactionVariant,
                    color: customInteractionColor ?? variant.interactionColor
                )
                .clipShape(RoundedRectangle(cornerRadius: m.radius))
            }
            .background {
                backgroundLayer(metrics: m)
            }
            .frame(width: containerSize, height: containerSize)
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
            if alternative {
                shape.fill(_backgroundColor)
            } else {
                MaterialBackground(in: shape, tint: _backgroundColor)
            }
        case .outlined:
            ZStack {
                shape.fill(_backgroundColor)
                shape.stroke(_strokeColor, lineWidth: 1)
            }
        case .solid:
            MaterialBackground(in: shape, tint: _backgroundColor)
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

    /// press 피드백 방식을 결정하는 열거형입니다.
    ///
    /// 어떤 값을 쓰든 터치 영역은 같습니다. 피드백의 시각 표현만 달라집니다.
    public enum InteractionEffect {
        /// 아이콘 뒤에 인터랙션 레이어를 깝니다. 기본값이며 3.x까지의 동작입니다.
        case normal
        /// 레이어 대신 아이콘 색을 `foregroundNeutralQuaternary`로 바꿉니다.
        /// 레이어 형태가 어색한 자리(TopNavigation 등)에 씁니다.
        /// > `normal` variant에서만 동작합니다.
        /// > press 색은 `interactionColor(_:)`로 바꾸며, `iconColor(_:)`로 지정한 색은 press 상태에 영향을 주지 않습니다.
        case tint
        /// 피드백이 없습니다. 탭 핸들러는 그대로 동작합니다.
        case none
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
                let icon = Self.nearestToken(container * (2.0 / 3.0), in: Dimension.allValues, tieBreak: .down)
                let radius = Self.nearestToken(container * 0.3, in: Radius.allValues, tieBreak: .down)
                return Self.makeMetrics(container: container, icon: icon, radius: radius)
            }
        case .background(let size, _):
            if CGFloat(size) == .dimension32 {
                return Self.makeMetrics(container: .dimension32, icon: .dimension20, radius: .primitiveInfinity)
            }
            let container = Self.clampedContainer(size)
            let icon = Self.nearestToken(container * (2.0 / 3.0), in: Dimension.allValues, tieBreak: .down)
            return Self.makeMetrics(container: container, icon: icon, radius: .primitiveInfinity)
        case .outlined(let size), .solid(let size):
            switch size {
            case .small:  return Self.makeMetrics(container: .dimension32, icon: .dimension16, radius: .primitiveInfinity)
            case .medium: return Self.makeMetrics(container: .dimension40, icon: .dimension18, radius: .primitiveInfinity)
            case .custom(let n):
                let container = Self.clampedContainer(n)
                let icon = Self.nearestToken(container * 0.47, in: Dimension.allValues, tieBreak: .down)
                return Self.makeMetrics(container: container, icon: icon, radius: .primitiveInfinity)
            }
        }
    }

    /// 컨테이너 한 변의 크기는 `[24, dimension 최대 토큰]`으로 클램프된다.
    /// 상한은 디자인 시스템 토큰에서 동적으로 도출되어, 토큰이 변경되면 자동으로 따라간다.
    private static func clampedContainer(_ n: Int) -> CGFloat {
        min(Dimension.max, max(24, CGFloat(n)))
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
                .atomic(.coolNeutral30).withAlphaComponent(.opacity61)
            } else {
                // material이 적용되어 있기 때문에 값에 무관
                .clear
            }
        case .solid:
            .semantic(.surfaceBrandPrimary)
        }
    }

    var disabledBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            .clear
        case .background:
            .semantic(.surfaceNeutralTertiary).withAlphaComponent(.opacity5)
        case .solid:
            .semantic(.surfaceNeutralSecondary)
        }
    }

    var activeColor: UIColor {
        switch self {
        case .normal, .outlined: .semantic(.foregroundNeutralPrimary)
        case .background(_, let isAlternative):
            if isAlternative {
                .semantic(.staticWhite).withAlphaComponent(.opacity88)
            } else {
                .atomic(.coolNeutral50).withAlphaComponent(.opacity74)
            }
        case .solid: .semantic(.staticWhite)
        }
    }

    var disabledIconColor: UIColor {
        switch self {
        case .normal, .outlined, .solid:
            .semantic(.foregroundDisablePrimary)
        case .background:
            .atomic(.coolNeutral50).withAlphaComponent(.opacity22)
        }
    }

    var borderColor: UIColor {
        switch self {
        case .outlined: .semantic(.lineNeutralSecondary).withAlphaComponent(.opacity16)
        default: .clear
        }
    }

    var interactionColor: Color.Semantic {
        .foregroundNeutralPrimary
    }

    var interactionVariant: Interaction.Variant {
        switch self {
        case .normal, .outlined: .light
        case .background(_, let isAlternative): isAlternative ? .normal : .light
        case .solid: .strong
        }
    }
}
