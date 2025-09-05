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
/// ```swift
/// // 텍스트 스켈레톤 사용
/// Text("콘텐츠")
///     .skeleton(isPresented: isLoading, kind: .text(lineNumber: 3))
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
///
/// - Note: 스켈레톤 뷰는 로딩 상태일 때 부드러운 페이드 인/아웃 애니메이션을 제공합니다.
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
    
    /// 스켈레톤 요소의 종류를 지정하는 열거형입니다.
    ///
    /// 다양한 콘텐츠 유형에 맞게 적절한 스켈레톤 형태를 선택할 수 있습니다.
    ///
    /// ```swift
    /// // 3줄 텍스트 스켈레톤
    /// Skeleton.Kind.text(lineNumber: 3)
    ///
    /// // 둥근 모서리 사각형 스켈레톤
    /// Skeleton.Kind.rectangle(cornerRadius: 8)
    ///
    /// // 원형 스켈레톤 (프로필 이미지 등에 적합)
    /// Skeleton.Kind.circle
    /// ```
    public enum Kind {
        /// 텍스트 줄을 나타내는 스켈레톤
        ///
        /// - Parameters:
        ///   - alignment: 텍스트 정렬 방식 (기본값: .leading)
        ///   - lengths: 각 줄의 상대적 길이 (기본값: [._100])
        ///   - cornerRadius: 모서리 둥글기 (기본값: 3)
        ///   - lineNumber: 텍스트 줄 수 (기본값: 1)
        case text(
            alignment: Align = .leading,
            lengths: [Length] = [._100],
            cornerRadius: CGFloat = 3,
            lineNumber: Int = 1
        )
        /// 사각형 모양의 스켈레톤
        ///
        /// - Parameter cornerRadius: 모서리 둥글기 (기본값: 3)
        case rectangle(cornerRadius: CGFloat = 3)
        /// 원형 스켈레톤
        case circle
    }
    
    // MARK: - Views
    /// 스켈레톤 로딩 UI를 표시하는 뷰입니다.
    ///
    /// 지정된 형태(텍스트, 사각형, 원형)에 따라 적절한 스켈레톤 UI를 렌더링합니다.
    /// 색상, 투명도 등을 커스터마이징할 수 있습니다.
    ///
    /// ```swift
    /// Skeleton.SkeletonView(.text(lineNumber: 3))
    ///     .color(.gray)
    ///     .opacity(0.8)
    /// ```
    public struct SkeletonView: View {
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
        
        public var body: some View {
            Group {
                switch kind {
                case .text(let alignment, let lengths, let cornerRadius, let lineNumber):
                    GeometryReader { proxy in
                        VStack(alignment: alignment.horizontalAlignment, spacing: 0) {
                            ForEach(0 ..< lineNumber, id: \.self) { index in
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .frame(
                                        width: proxy.size.width * (lengths[safe: index]?.rawValue ?? 1.0),
                                        height: max(0, proxy.size.height / CGFloat(lineNumber) - 4)
                                    )
                                    .padding(.vertical, 2)
                            }
                        }
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height,
                            alignment: alignment.alignment
                        )
                    }
                case .rectangle(let cornerRadius):
                    RoundedRectangle(cornerRadius: cornerRadius)
                case .circle:
                    Circle()
                }
            }
            .foregroundStyle(color)
            .opacity(opacity)
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
            ZStack {
                if isPresented {
                    if let size {
                        SwiftUI.Color.clear
                            .skeleton(isPresented: isPresented) {
                                Skeleton.SkeletonView(kind)
                                    .color(color)
                                    .opacity(opacity)
                            }
                            .frame(
                                width: size.width,
                                height: size.height
                            )
                    } else {
                        content
                            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
                            .hidden()
                        
                        content
                            .skeleton(isPresented: isPresented) {
                                Skeleton.SkeletonView(kind)
                                    .color(color)
                                    .opacity(opacity)
                            }
                            .frame(
                                width: contentSize.width,
                                height: contentSize.height
                            )
                    }
                } else {
                    content
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
        
        @State var animationOpacity: CGFloat = 1
        
        func body(content: Content) -> some View {
            if isPresented {
                skeletonView()
                    .opacity(animationOpacity)
                    .onAppear {
                        withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)
                            .repeatForever(autoreverses: true)) {
                                animationOpacity = 0.5
                            }
                    }
                    .onDisappear {
                        withAnimation(.none) {
                            animationOpacity = 1
                        }
                    }
            } else {
                content
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
    ///   - color: 스켈레톤 색상 (기본값: 시스템 색상)
    ///   - opacity: 스켈레톤 투명도 (기본값: 1.0)
    ///   - size: 스켈레톤 크기 (지정하지 않으면 원본 뷰 크기를 사용)
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
