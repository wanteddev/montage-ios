//
//  Shadow.swift
//  Views
//
//  Created by 김삼열 on 8/21/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public enum Shadow {
    /// 그림자의 강도를 정의하는 열거형입니다.
    ///
    /// 각 레벨은 키 그림자와 앰비언트 그림자의 조합으로 구성되어 있으며,
    /// 레벨이 높을수록 더 강하고 넓은 그림자가 적용됩니다.
    public enum Level: CaseIterable {
        /// 그림자 없음
        case none
        /// 매우 작은 그림자
        case xsmall
        /// 작은 그림자
        case small
        /// 중간 크기 그림자
        case medium
        /// 큰 그림자
        case large
        /// 매우 큰 그림자
        case xlarge
    }

    /// 그림자를 구성하는 두 레이어(키/앰비언트).
    enum Layer {
        case key
        case ambient
    }

    // MARK: - 레벨/레이어별 메트릭 (View·ShapeStyle 양쪽에서 공유)

    static func colorOpacity(_ level: Level, _ layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 0.05
        case .small:
            return 0.03
        case .medium:
            return 0.035
        case .large:
            return 0.04
        case .xlarge:
            return layer == .ambient ? 0.05 : 0.06
        }
    }

    static func radius(_ level: Level, _ layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 0.5
        case .small:
            return layer == .ambient ? 1 : 2.5
        case .medium:
            return layer == .ambient ? 2 : 6
        case .large:
            return layer == .ambient ? 3 : 9
        case .xlarge:
            return layer == .ambient ? 5 : 14
        }
    }

    static func position(_ level: Level, _ layer: Layer) -> CGPoint {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return CGPoint(x: 0, y: layer == .ambient ? .zero : 1)
        case .small:
            return CGPoint(x: 0, y: layer == .ambient ? 2 : 4)
        case .medium:
            return CGPoint(x: 0, y: layer == .ambient ? 4 : 10)
        case .large:
            return CGPoint(x: 0, y: layer == .ambient ? 6 : 16)
        case .xlarge:
            return CGPoint(x: 0, y: layer == .ambient ? 10 : 24)
        }
    }

    static func color(_ level: Level, _ layer: Layer) -> SwiftUI.Color {
        SwiftUI.Color(red: 0.09, green: 0.09, blue: 0.09, opacity: colorOpacity(level, layer))
    }

    // MARK: - ViewModifier

    struct Modifier: ViewModifier {
        private let level: Level

        init(level: Level) {
            self.level = level
        }

        func body(content: Content) -> some View {
            content
                .shadow(
                    color: Shadow.color(level, .ambient),
                    radius: Shadow.radius(level, .ambient),
                    x: Shadow.position(level, .ambient).x,
                    y: Shadow.position(level, .ambient).y
                )
                .shadow(
                    color: Shadow.color(level, .key),
                    radius: Shadow.radius(level, .key),
                    x: Shadow.position(level, .key).x,
                    y: Shadow.position(level, .key).y
                )
        }
    }
}

// MARK: - ShapeStyle Extension (offscreen-free)

extension ShapeStyle {
    /// 디자인 시스템 그림자(앰비언트 + 키)를 **analytic drop 그림자**로 적용한 `ShapeStyle`을 반환합니다.
    ///
    /// `Shape`의 `fill`에 사용하면 그림자가 Shape 지오메트리로부터 직접 그려져
    /// **오프스크린 렌더링 패스가 발생하지 않습니다.** 그림자를 그릴 표면의 모양을 알 수 있는
    /// 경우(카드·버튼·둥근 컨테이너 등)에는 임의 콘텐츠에 적용하는 `View.shadow(_:)` 대신
    /// 이쪽을 사용해 GPU 합성 비용을 줄이세요.
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: 12)
    ///     .fill(SwiftUI.Color.semantic(.backgroundElevated).shadow(.medium))
    /// ```
    ///
    /// - Parameter level: 적용할 그림자 레벨
    /// - Returns: 그림자가 적용된 `ShapeStyle`
    public func shadow(_ level: Shadow.Level) -> some ShapeStyle {
        self
            .shadow(
                .drop(
                    color: Shadow.color(level, .ambient),
                    radius: Shadow.radius(level, .ambient),
                    x: Shadow.position(level, .ambient).x,
                    y: Shadow.position(level, .ambient).y
                )
            )
            .shadow(
                .drop(
                    color: Shadow.color(level, .key),
                    radius: Shadow.radius(level, .key),
                    x: Shadow.position(level, .key).x,
                    y: Shadow.position(level, .key).y
                )
            )
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 그림자를 적용합니다.
    ///
    /// 지정된 레벨의 그림자를 뷰에 적용하여 깊이감을 줍니다.
    /// 키 그림자와 앰비언트 그림자가 조합되어 자연스러운 그림자 효과를 만듭니다.
    ///
    /// - Important: 이 API는 **임의의 콘텐츠**에 그림자를 적용하므로, 시스템이 콘텐츠의 실루엣을
    ///   알기 위해 **오프스크린 렌더링 패스**를 발생시킵니다(특히 `clipShape`/머티리얼과 함께 쓰일 때).
    ///   그림자를 그릴 표면의 모양을 알 수 있다면 `Shape`의 `fill`에 적용하는
    ///   `ShapeStyle.shadow(_:)` 를 사용해 오프스크린을 피하세요.
    ///
    /// - Parameter level: 적용할 그림자 레벨
    /// - Returns: 그림자가 적용된 뷰
    ///
    /// ```swift
    /// // 권장: Shape fill에 analytic 그림자 (오프스크린 없음)
    /// RoundedRectangle(cornerRadius: 12)
    ///     .fill(SwiftUI.Color.semantic(.backgroundElevated).shadow(.medium))
    ///
    /// // 모양을 알 수 없는 임의 콘텐츠에만 사용 (오프스크린 비용 주의)
    /// someContent
    ///     .shadow(.small)
    /// ```
    public func shadow(_ level: Shadow.Level) -> some View {
        modifier(Shadow.Modifier(level: level))
    }
}
