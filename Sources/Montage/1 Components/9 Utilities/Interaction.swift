//
//  Interaction.swift
//
//
//  Created by Ahn Sang Hoon on 6/24/24.
//

import SwiftUI

/// 사용자 상호작용 상태를 시각적으로 표현하는 장식 컴포넌트입니다.
///
/// 이 컴포넌트는 버튼, 카드 등의 UI 요소에 호버, 포커스, 누름 등의 상호작용 상태를 시각적으로 표현할 때 사용합니다.
/// 상태와 변형에 따라 다양한 불투명도를 적용하여 사용자에게 시각적 피드백을 제공합니다.
///
/// ```swift
/// // 기본 상호작용 장식
/// Interaction()
///
/// // 눌림 상태의 강조된 상호작용 장식
/// Interaction(
///     state: .pressed,
///     variant: .strong,
///     color: .primaryNormal
/// )
/// ```
public struct Interaction: View {
    /// 상호작용의 상태를 정의합니다.
    public enum State {
        /// 기본 상태 (아무 상호작용 없음)
        case normal
        /// 호버 상태 (마우스 오버)
        case hovered
        /// 포커스 상태 (키보드 포커스)
        case focused
        /// 누름 상태 (클릭/터치)
        case pressed
    }

    /// 상호작용 효과의 강도를 정의합니다.
    public enum Variant {
        /// 기본 강도
        case normal
        /// 약한 강도
        case light
        /// 강한 강도
        case strong
    }

    private let state: State
    private let variant: Variant
    private let color: Color.Semantic

    /// 상호작용 장식 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - state: 상호작용 상태, 생략하면 기본값으로 `.normal` 적용
    ///   - variant: 상호작용 효과 강도, 생략하면 기본값으로 `.normal` 적용
    ///   - color: 적용할 색상, 생략하면 기본값으로 `.labelNormal` 적용
    /// - Returns: 구성된 상호작용 장식 인스턴스
    public init(
        state: State = .normal,
        variant: Variant = .normal,
        color: Color.Semantic = .labelNormal
    ) {
        self.state = state
        self.variant = variant
        self.color = color
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        Rectangle()
            .foregroundStyle(SwiftUI.Color.semantic(color))
            .opacity(state.alpha * variant.weight)
    }
}

extension Interaction.State {
    var alpha: CGFloat {
        switch self {
        case .normal:
            0
        case .hovered:
            0.05
        case .focused:
            0.08
        case .pressed:
            0.12
        }
    }
}

extension Interaction.Variant {
    var weight: CGFloat {
        switch self {
        case .normal:
            1
        case .light:
            0.75
        case .strong:
            1.5
        }
    }
}

struct Interaction_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Interaction()
            Interaction(
                state: .pressed
            )
        }
    }
}
