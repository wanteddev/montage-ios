//
//  Skeleton.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

/// 콘텐츠 로딩 중 표시되는 스켈레톤 UI 컴포넌트입니다.
///
/// 데이터 로딩 중에 UI의 구조를 미리 보여주는 스켈레톤 뷰를 제공합니다.
/// 텍스트, 사각형, 원형 등 다양한 형태의 스켈레톤 로딩 플레이스홀더를 지원합니다.
///
/// 텍스트 스켈레톤은 `Typography.Variant`의 `lineHeight`를 기반으로
/// 줄 수를 자동 계산하고, 첫 줄은 100%, 나머지는 가변 길이로 표시합니다.
///
/// ```swift
/// // 자동 텍스트 스켈레톤 (variant 기반 자동 계산)
/// Text("콘텐츠")
///     .skeleton(isPresented: isLoading, kind: .text(variant: .body1))
///
/// // 이미지를 위한 원형 스켈레톤 사용
/// Image(systemName: "person.circle")
///     .skeleton(isPresented: isLoading, kind: .circle)
///
/// // 커스텀 스켈레톤 뷰 사용
/// contentView
///     .skeleton(isPresented: isLoading) {
///         Skeleton.SkeletonView(.rectangle(cornerRadius: 8))
///             .color(.semantic(.fillNormal))
///             .opacity(0.7)
///     }
/// ```
public enum Skeleton {
    // MARK: - Types
    
    /// 스켈레톤 요소의 정렬 방식을 지정하는 열거형입니다.
    ///
    /// 텍스트 스켈레톤에서 각 라인의 정렬 방식을 지정할 때 사용됩니다.
    ///
    /// ```swift
    /// Skeleton.Kind.text(alignment: .center, lineNumber: 2)
    /// ```
    public enum Align {
        /// 좌측 정렬
        case leading
        /// 중앙 정렬
        case center
        /// 우측 정렬
        case trailing
        
        /// 수평 정렬 속성을 반환합니다.
        ///
        /// - Returns: 열거형 값에 해당하는 SwiftUI HorizontalAlignment 값
        var horizontalAlignment: HorizontalAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
        
        /// 정렬 속성을 반환합니다.
        ///
        /// - Returns: 열거형 값에 해당하는 SwiftUI Alignment 값
        var alignment: Alignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
    }
    
    /// 스켈레톤 요소의 길이 비율을 지정하는 열거형입니다.
    ///
    /// 텍스트 스켈레톤에서 각 라인의 길이를 상대적으로 지정하는 데 사용됩니다.
    ///
    /// ```swift
    /// Skeleton.Kind.text(lengths: [._100, ._75, ._50], lineNumber: 3)
    /// ```
    public enum Length: CGFloat {
        /// 100% 길이 (전체 너비)
        case _100 = 1
        /// 75% 길이
        case _75 = 0.75
        /// 50% 길이
        case _50 = 0.5
        /// 25% 길이
        case _25 = 0.25
    }
    
    /// 스켈레톤 요소의 종류를 지정하는 구조체입니다.
    ///
    /// 다양한 콘텐츠 유형에 맞게 적절한 스켈레톤 형태를 선택할 수 있습니다.
    /// 텍스트 스켈레톤은 `Typography.Variant`의 `lineHeight`를 기반으로
    /// 줄 수와 길이를 자동 계산합니다.
    ///
    /// ```swift
    /// // 자동 텍스트 스켈레톤 (variant 기반 자동 계산)
    /// Skeleton.Kind.text(variant: .body1)
    ///
    /// // 둥근 모서리 사각형 스켈레톤
    /// Skeleton.Kind.rectangle(cornerRadius: 8)
    ///
    /// // 원형 스켈레톤 (프로필 이미지 등에 적합)
    /// Skeleton.Kind.circle
    /// ```
    public struct Kind {
        enum Category {
            case text, rectangle, circle
        }

        let category: Category
        let alignment: Align
        let lengths: [Length]
        let cornerRadius: CGFloat
        let lineHeight: CGFloat
        let lineSpacing: CGFloat
        let lineNumber: Int

        /// 텍스트 종류인지 여부
        public var isText: Bool { category == .text }
        /// 사각형 종류인지 여부
        public var isRectangle: Bool { category == .rectangle }
        /// 원형 종류인지 여부
        public var isCircle: Bool { category == .circle }

        // MARK: - New API

        /// 텍스트 줄을 나타내는 스켈레톤을 생성합니다.
        ///
        /// `variant`의 `lineHeight`를 기반으로 뷰 높이에 맞는 줄 수를 자동 계산하고,
        /// 첫 줄은 100%, 나머지는 가변 길이로 표시합니다.
        ///
        /// - Parameters:
        ///   - variant: 텍스트의 타이포그래피 변형. `lineHeight`를 기준으로 줄 수를 자동 계산합니다
        ///   - alignment: 텍스트 정렬 방식, 생략하면 기본값으로 `.leading` 적용
        ///   - cornerRadius: 모서리 둥글기, 생략하면 기본값으로 `3` 적용
        /// - Returns: 텍스트 스켈레톤 Kind
        public static func text(
            variant: Typography.Variant,
            alignment: Align = .leading,
            cornerRadius: CGFloat = 3
        ) -> Kind {
            Kind(
                category: .text,
                alignment: alignment,
                lengths: [],
                cornerRadius: cornerRadius,
                lineHeight: variant.lineHeight,
                lineSpacing: variant.lineSpacing,
                lineNumber: 0
            )
        }

        // MARK: - Deprecated API

        /// 텍스트 줄을 나타내는 스켈레톤을 생성합니다.
        ///
        /// - Parameters:
        ///   - alignment: 텍스트 정렬 방식
        ///   - lengths: 각 줄의 상대적 길이
        ///   - cornerRadius: 모서리 둥글기
        ///   - lineNumber: 텍스트 줄 수. `0`이면 자동 계산
        /// - Returns: 텍스트 스켈레톤 Kind
        @available(*, deprecated, message: "text(variant:alignment:cornerRadius:)를 사용하세요")
        public static func text(
            alignment: Align = .leading,
            lengths: [Length] = [],
            cornerRadius: CGFloat = 3,
            lineNumber: Int = 0
        ) -> Kind {
            Kind(
                category: .text,
                alignment: alignment,
                lengths: lengths,
                cornerRadius: cornerRadius,
                lineHeight: SkeletonView.textReferenceLineHeight,
                lineSpacing: SkeletonView.textLineSpacing,
                lineNumber: lineNumber
            )
        }

        /// 사각형 모양의 스켈레톤을 생성합니다.
        ///
        /// - Parameter cornerRadius: 모서리 둥글기, 생략하면 기본값으로 `3` 적용
        /// - Returns: 사각형 스켈레톤 Kind
        public static func rectangle(cornerRadius: CGFloat = 3) -> Kind {
            Kind(
                category: .rectangle,
                alignment: .leading,
                lengths: [],
                cornerRadius: cornerRadius,
                lineHeight: 0,
                lineSpacing: 0,
                lineNumber: 0
            )
        }

        /// 원형 스켈레톤
        public static var circle: Kind {
            Kind(
                category: .circle,
                alignment: .leading,
                lengths: [],
                cornerRadius: 0,
                lineHeight: 0,
                lineSpacing: 0,
                lineNumber: 0
            )
        }
    }
    
    // MARK: - Views
    /// 스켈레톤 로딩 UI를 표시하는 뷰입니다.
    ///
    /// 지정된 형태(텍스트, 사각형, 원형)에 따라 적절한 스켈레톤 UI를 렌더링합니다.
    /// 색상, 투명도 등을 커스터마이징할 수 있습니다.
    ///
    /// 텍스트 스켈레톤의 자동 계산:
    /// - `variant.lineHeight`를 기준으로 뷰 높이를 나누어 최적의 줄 수를 계산합니다.
    /// - 첫 줄 100%, 중간 줄 65~90%, 마지막 줄 40~55% 비율로 자동 생성합니다.
    ///
    /// ```swift
    /// // variant 기반 자동 모드
    /// Skeleton.SkeletonView(.text(variant: .body1))
    ///     .color(.gray)
    ///     .opacity(0.8)
    /// ```
    public struct SkeletonView: View {
        // MARK: - Constants

        /// 텍스트 스켈레톤 자동 계산 시 기준 라인 높이 (pt)
        static let textReferenceLineHeight: CGFloat = 14

        /// 텍스트 스켈레톤 라인 간 상하 여백 (pt)
        static let textLineSpacing: CGFloat = 4

        // MARK: - Initializer
        private let kind: Kind
        
        /// 스켈레톤 뷰를 초기화합니다.
        ///
        /// - Parameters:
        ///   - kind: 표시할 스켈레톤의 종류
        public init(_ kind: Kind) {
            self.kind = kind
        }
        
        // MARK: - Body
        
        /// 뷰의 내용과 동작을 정의합니다.
        public var body: some View {
            Group {
                switch kind.category {
                case .text:
                    GeometryReader { proxy in
                        let spacing = kind.lineSpacing
                        let effectiveLineCount = kind.lineNumber > 0
                            ? kind.lineNumber
                            : max(1, Int(proxy.size.height / (kind.lineHeight + spacing)))
                        let barHeight = max(0, kind.lineHeight - spacing)

                        VStack(alignment: kind.alignment.horizontalAlignment, spacing: 0) {
                            ForEach(0 ..< effectiveLineCount, id: \.self) { index in
                                let ratio = kind.lengths[safe: index]?.rawValue
                                    ?? Self.autoLengthRatio(
                                        for: index, in: effectiveLineCount
                                    )
                                RoundedRectangle(cornerRadius: kind.cornerRadius)
                                    .frame(
                                        width: proxy.size.width * ratio,
                                        height: barHeight
                                    )
                                    .padding(.vertical, spacing / 2)
                            }
                        }
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height,
                            alignment: kind.alignment.alignment
                        )
                    }
                case .rectangle:
                    RoundedRectangle(cornerRadius: kind.cornerRadius)
                case .circle:
                    Circle()
                }
            }
            .foregroundStyle(color)
            .opacity(opacity)
        }
        
        // MARK: - Helpers

        private static func autoLengthRatio(for index: Int, in lineCount: Int) -> CGFloat {
            if index == 0 { return 1.0 }
            if lineCount > 1, index == lineCount - 1 {
                return [0.45, 0.55, 0.5, 0.4][index % 4]
            }
            return [0.85, 0.75, 0.9, 0.7, 0.8, 0.65][(index - 1) % 6]
        }

        // MARK: - Modifiers

        private var color: SwiftUI.Color = .semantic(.fillNormal)
        private var opacity: CGFloat = 1
        
        /// 스켈레톤 뷰의 색상을 설정합니다.
        ///
        /// - Parameters:
        ///   - color: 적용할 색상
        /// - Returns: 수정된 SkeletonView 인스턴스
        public func color(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.color = color
            return zelf
        }
        
        /// 스켈레톤 뷰의 투명도를 설정합니다.
        ///
        /// - Parameters:
        ///   - opacity: 적용할 투명도 (0.0 ~ 1.0)
        /// - Returns: 수정된 SkeletonView 인스턴스
        public func opacity(_ opacity: CGFloat) -> Self {
            var zelf = self
            zelf.opacity = opacity
            return zelf
        }
    }
    
    struct PredefinedSkeletonModifier: ViewModifier {
        private let kind: Skeleton.Kind
        private let color: SwiftUI.Color
        private let opacity: CGFloat
        private let size: CGSize?
        
        private let isPresented: Bool
        
        init(
            isPresented: Bool,
            kind: Skeleton.Kind,
            color: SwiftUI.Color? = nil,
            opacity: CGFloat? = nil,
            size: CGSize? = nil
        ) {
            self.isPresented = isPresented
            self.kind = kind
            self.color = color ?? .semantic(.fillNormal)
            self.opacity = opacity ?? 1
            self.size = (size?.isNegativeOrNonfinite ?? false) ? nil : size
        }
        
        @State private var contentSize: CGSize = .zero
        
        func body(content: Content) -> some View {
            ZStack(alignment: .topLeading) {
                content
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
                    .opacity(isPresented ? 0 : 1)

                if isPresented {
                    let w = size?.width ?? contentSize.width
                    let h = size?.height ?? contentSize.height
                    SwiftUI.Color.clear
                        .frame(width: w, height: h)
                        .skeleton(isPresented: isPresented) {
                            Skeleton.SkeletonView(kind)
                                .color(color)
                                .opacity(opacity)
                                .frame(width: w, height: h)
                        }
                }
            }
        }
    }
    
    struct SkeletonModifier<V: View>: ViewModifier {
        private let isPresented: Bool
        private let skeletonView: () -> V
        
        init(isPresented: Bool, @ViewBuilder skeletonView: @escaping () -> V) {
            self.isPresented = isPresented
            self.skeletonView = skeletonView
        }
        
        @State private var animationOpacity: CGFloat = 1
        
        func body(content: Content) -> some View {
            ZStack {
                content.opacity(isPresented ? 0 : 1)
                if isPresented {
                    skeletonView()
                        .opacity(animationOpacity)
                        .onAppear {
                            withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 1)
                                .repeatForever(autoreverses: true)) {
                                    animationOpacity = 0.5
                                }
                        }
                        .onDisappear {
                            withAnimation(.none) { animationOpacity = 1 }
                        }
                }
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 커스텀 스켈레톤 로딩 UI를 적용합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 스켈레톤 표시 여부를 제어하는 불리언 값
    ///   - skeletonView: 커스텀 스켈레톤 뷰를 생성하는 클로저
    /// - Returns: 스켈레톤 기능이 적용된 뷰
    public func skeleton<V: View>(
        isPresented: Bool,
        @ViewBuilder skeletonView: @escaping () -> V
    ) -> some View {
        modifier(Skeleton.SkeletonModifier(isPresented: isPresented, skeletonView: skeletonView))
    }
    
    /// 현재 뷰에 미리 정의된 스켈레톤 로딩 UI를 적용합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 스켈레톤 표시 여부를 제어하는 불리언 값
    ///   - kind: 스켈레톤 종류 (텍스트, 사각형, 원형 등)
    ///   - color: 스켈레톤 색상, 생략하면 기본값으로 `nil` 적용 (.semantic(.fillNormal) 사용)
    ///   - opacity: 스켈레톤 투명도, 생략하면 기본값으로 `nil` 적용
    ///   - size: 스켈레톤 크기 (지정하지 않으면 원본 뷰 크기를 사용), 생략하면 기본값으로 `nil` 적용
    /// - Returns: 스켈레톤 기능이 적용된 뷰
    public func skeleton(
        isPresented: Bool,
        kind: Skeleton.Kind,
        color: SwiftUI.Color? = nil,
        opacity: CGFloat? = nil,
        size: CGSize? = nil
    ) -> some View {
        modifier(
            Skeleton.PredefinedSkeletonModifier(
                isPresented: isPresented,
                kind: kind,
                color: color,
                opacity: opacity,
                size: size
            )
        )
    }
}
