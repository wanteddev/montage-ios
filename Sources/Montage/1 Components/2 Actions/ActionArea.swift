//
//  ActionArea.swift
//  Montage
//
//  Created by 김삼열 on 2/19/25.
//

import SwiftUI

/// 화면 하단에 사용자 액션 버튼을 표시하는 영역 컴포넌트입니다.
///
/// 이 컴포넌트는 화면 하단에 위치하며 주요 액션 버튼과 보조 버튼을 표시합니다.
/// 다양한 레이아웃 변형을 지원하고, 캡션 텍스트와 추가 콘텐츠를 포함할 수 있습니다.
///
/// ```swift
/// // 기본 강조 버튼 영역
/// ActionArea(variant: .strong(
///     main: .init(text: "확인", action: { confirmAction() }),
///     sub: .init(text: "취소", action: { cancelAction() })
/// ))
///
/// // 캡션이 있는 중립 버튼 영역
/// ActionArea(variant: .neutral(
///     main: .init(text: "저장", action: { saveData() })
/// ))
/// .caption("변경 사항을 저장하시겠습니까?")
///
/// // 추가 콘텐츠가 있는 취소 버튼 영역
/// ActionArea(variant: .cancel(
///     main: .init(text: "닫기", action: { dismiss() })
/// ))
/// .extra({ 
///     Text("추가 정보")
///         .typography(variant: .label2) 
/// })
/// ```
///
/// - Note: 키보드가 표시될 때 자동으로 조정됩니다.
public struct ActionArea: View, KeyboardReadable {
    // MARK: - Initializers
    
    private let variant: Variant
    
    /// ActionArea 컴포넌트를 초기화합니다.
    ///
    /// - Parameter variant: 버튼 영역의 변형 스타일과 버튼 구성
    /// - Returns: 구성된 ActionArea 인스턴스
    public init(variant: Variant) {
        self.variant = variant
    }
    
    // MARK: - Body
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var isKeyboardVisible = false
    @State private var height: CGFloat = .zero
    @State private var gradientOpacity: CGFloat = 1
    @State private var isExtraEmpty = true
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                extra()
                    .padding([.top, .horizontal], 20)
                    .padding(.bottom, 24)
                    .background(backgroundColor)
                    .ifEmptyView { isExtraEmpty = $0 }
                
                if !isExtraEmpty && extraDivider {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.semantic(.lineNeutral))
                        .frame(height: 1)
                }
            }
            
            if isExtraEmpty {
                SwiftUI.Color.semantic(.backgroundElevated)
                    .frame(height: 0)
                    .overlay {
                        LinearGradient(
                            colors: gradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 40)
                        .offset(y: -20)
                    }
                    .opacity(gradientOpacity)
            }
            
            VStack(spacing: 16) {
                captionView
                
                Buttons(variant)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, isKeyboardVisible ? 20 : 0)
            .background(backgroundColor)
        }
        .onReceive(keyboardPublisher) { isKeyboardVisible = $0 }
        .onChange(of: transparentBackground) { transparentBackground in
            withAnimation(.easeInOut(duration: 0.5)) {
                gradientOpacity = transparentBackground ? 0 : 1
            }
        }
    }
    
    // MARK: - Modifiers
    
    private var transparentBackground = false
    private var caption: String?
    private var extra: () -> AnyView = { AnyView(EmptyView()) }
    private var extraDivider = true
    
    /// 배경을 투명하게 설정합니다.
    ///
    /// 이 수정자를 사용하면 그라데이션 배경이 숨겨지고 투명한 배경이 표시됩니다.
    ///
    /// - Parameter transparenBackground: 배경 투명 여부, 기본값은 `true`
    /// - Returns: 수정된 ActionArea 인스턴스
    public func transparentBackground(_ transparentBackground: Bool = true) -> Self {
        var zelf = self
        zelf.transparentBackground = transparentBackground
        return zelf
    }
    
    /// 버튼 위에 표시할 캡션 텍스트를 설정합니다.
    ///
    /// - Parameter caption: 표시할 캡션 텍스트
    /// - Returns: 수정된 ActionArea 인스턴스
    public func caption(_ caption: String?) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }
    
    /// 버튼 위에 표시할 추가 콘텐츠를 설정합니다.
    ///
    /// - Parameters:
    ///   - content: 표시할 추가 콘텐츠를 생성하는 클로저
    ///   - divider: 추가 콘텐츠 위에 구분선 표시 여부, 기본값은 `true`
    /// - Returns: 수정된 ActionArea 인스턴스
    public func extra<V: View>(@ViewBuilder _ content: @escaping () -> V, divider: Bool = true) -> Self {
        var zelf = self
        zelf.extra = { AnyView(content()) }
        zelf.extraDivider = divider
        return zelf
    }
}
    
// MARK: - Types
extension ActionArea {
    /// ActionArea의 버튼 레이아웃 변형을 정의합니다.
    public enum Variant {
        /// 강조된 주 버튼과 보조/대체 버튼이 있는 레이아웃
        case strong(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        /// 중립적인 스타일의 버튼 레이아웃
        case neutral(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        /// 취소 버튼만 있는 간단한 레이아웃
        case cancel(main: ButtonInfo)
        
        fileprivate var isCaptionAvailable: Bool {
            switch self {
            case .strong, .neutral: true
            default: false
            }
        }
    }
    
    /// ActionArea에 표시될 버튼 정보를 정의하는 구조체입니다.
    ///
    /// 버튼의 텍스트, 액션, 커스텀 뷰 등을 지정할 수 있습니다.
    public struct ButtonInfo {
        internal let text: String
        internal let action: () -> Void
        internal var custom: () -> AnyView
        
        /// 기본 버튼 정보를 초기화합니다.
        ///
        /// - Parameters:
        ///   - text: 버튼에 표시할 텍스트
        ///   - action: 버튼 클릭 시 실행할 액션
        /// - Returns: 구성된 ButtonInfo 인스턴스
        public init(text: String, action: @escaping (() -> Void)) {
            self.text = text
            self.action = action
            custom = { AnyView(EmptyView()) }
        }
        
        /// 커스텀 버튼 뷰를 사용하는 버튼 정보를 생성합니다.
        ///
        /// - Parameter custom: 커스텀 버튼 뷰를 생성하는 클로저
        /// - Returns: 커스텀 뷰가 포함된 ButtonInfo 인스턴스
        /// - Note: 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하세요.
        public static func custom<V: View>(@ViewBuilder _ custom: @escaping () -> V) -> Self {
            var zelf = self.init(text: "", action: {})
            zelf.custom = { AnyView(custom()) }
            return zelf
        }
    }
    
    /// ActionArea를 구성하기 위한 모델 구조체입니다.
    ///
    /// 이 구조체는 ActionArea의 모든 구성 정보를 담아 ActionAreaModifier에 전달합니다.
    /// 버튼 레이아웃, 배경 투명도, 캡션 텍스트, 추가 콘텐츠 등을 구성할 수 있습니다.
    public struct Model {
        let variant: ActionArea.Variant
        let backgroundTransparencyControl: BackgroundTransparencyControl
        let caption: String?
        let extra: () -> AnyView
        let extraDivider: Bool
        
        /// ActionArea 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 버튼 레이아웃 변형
        ///   - backgroundTransparencyControl: 배경 투명도 제어 방식 (기본값: .automatic)
        ///   - caption: 캡션 텍스트
        ///   - extraDivider: 추가 콘텐츠 위에 구분선 표시 여부
        public init(
            variant: ActionArea.Variant,
            backgroundTransparencyControl: BackgroundTransparencyControl = .automatic,
            caption: String? = nil,
            extraDivider: Bool = true
        ) {
            self.variant = variant
            self.backgroundTransparencyControl = backgroundTransparencyControl
            self.caption = caption
            self.extra = { AnyView(EmptyView()) }
            self.extraDivider = extraDivider
        }
        
        /// ActionArea 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 버튼 레이아웃 변형
        ///   - backgroundTransparencyControl: 배경 투명도 설정
        ///   - caption: 캡션 텍스트
        ///   - extra: 추가 콘텐츠를 생성하는 클로저
        ///   - extraDivider: 추가 콘텐츠 위에 구분선 표시 여부
        public init<V: View>(
            variant: ActionArea.Variant,
            backgroundTransparencyControl: BackgroundTransparencyControl = .automatic,
            caption: String? = nil,
            @ViewBuilder extra: @escaping () -> V,
            extraDivider: Bool = true
        ) {
            self.variant = variant
            self.backgroundTransparencyControl = backgroundTransparencyControl
            self.caption = caption
            self.extra = { AnyView(extra()) }
            self.extraDivider = extraDivider
        }
    }
}

// MARK: - Private
private extension ActionArea {
    private var captionView: some View {
        Group {
            if let caption = caption, variant.isCaptionAvailable {
                Text(caption)
                    .paragraph(variant: .label2, semantic: .labelAlternative)
            }
        }
    }
    
    private var gradient: [SwiftUI.Color] {
        [0, 0.14, 0.27, 0.38, 0.48, 0.57, 0.65, 0.71, 0.77, 0.82, 0.86, 0.9, 0.93, 0.96, 0.98, 1]
            .map {
                .semantic(.backgroundElevated).opacity($0)
            }
    }
    
    private var backgroundColor: SwiftUI.Color {
        !transparentBackground || !isExtraEmpty ? .semantic(.backgroundElevated) : .clear
    }
}

// MARK: - Inner Views

private extension ActionArea {
    private struct Buttons: View {
        private let variant: Variant
        
        init( _ variant: Variant) {
            self.variant = variant
        }
        
        var body: some View {
            Group {
                switch variant {
                case let .strong(main, sub, alternative):
                    strong(main, sub, alternative)
                case let .neutral(main, sub, alternative):
                    neutral(main, sub, alternative)
                case let .cancel(main):
                    cancel(main)
                }
            }
        }
        
        @ViewBuilder
        private func strong(
            _ main: ButtonInfo,
            _ sub: ButtonInfo?,
            _ alternative: ButtonInfo?
        ) -> some View {
            VStack(spacing: 8) {
                primarySolidButton(main)
                if let alternative {
                    secondaryOutlinedButton(alternative)
                }
                if let sub {
                    assistiveTextButton(sub)
                }
            }
        }
        
        @ViewBuilder
        private func neutral(
            _ main: ButtonInfo,
            _ sub: ButtonInfo?,
            _ alternative: ButtonInfo?
        ) -> some View {
            HStack(spacing: 12) {
                if let sub {
                    assistiveOutlinedButton(sub, fillWidth: false)
                }
                if let alternative {
                    secondaryOutlinedButton(alternative)
                }
                primarySolidButton(main)
            }
        }
        
        @ViewBuilder
        private func cancel(
            _ main: ButtonInfo
        ) -> some View {
            assistiveOutlinedButton(main)
        }
        
        @ViewBuilder private func primarySolidButton(_ buttonInfo: ButtonInfo) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                Button(
                    color: .primary,
                    size: .large,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .fill(horizontal: true, vertical: false)
            }
        }
        
        @ViewBuilder private func secondaryOutlinedButton(_ buttonInfo: ButtonInfo) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                Button(
                    variant: .outlined,
                    color: .primary,
                    size: .large,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .fill(horizontal: true, vertical: false)
            }
        }
        
        @ViewBuilder private func assistiveOutlinedButton(_ buttonInfo: ButtonInfo, fillWidth: Bool = true) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                Button(
                    variant: .outlined,
                    color: .assistive,
                    size: .large,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .if(fillWidth) {
                    $0.fill(horizontal: true, vertical: false)
                }
            }
        }
        
        @ViewBuilder private func assistiveTextButton(_ buttonInfo: ButtonInfo) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                TextButton(
                    color: .assistive,
                    size: .small,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .padding(.vertical, 8)
            }
        }
    }
    
    private struct CustomOrFallback<Fallback: View>: View {
        let custom: () -> AnyView
        @ViewBuilder var fallback: () -> Fallback
        @State private var isEmpty = true
        
        var body: some View {
            ZStack {
                custom()
                    .ifEmptyView { isEmpty = $0 }
                if isEmpty {
                    fallback()
                }
            }
        }
    }
}

struct ActionAreaModifier: ViewModifier {
    // MARK: - Initializer
    private let model: ActionArea.Model
    init(model: ActionArea.Model) {
        self.model = model
    }
    
    // MARK: - Body
        
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            ActionArea(variant: model.variant)
                .caption(model.caption)
                .extra(model.extra, divider: model.extraDivider)
                .modifying {
                    if case .manual(let visibility) = model.backgroundTransparencyControl {
                        $0.transparentBackground(visibility)
                    } else {
                        $0
                    }
                }
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 하단 ActionArea를 적용합니다.
    ///
    /// - Parameters:
    ///   - model: ActionArea의 구성 모델
    /// - Returns: ActionArea가 적용된 뷰
    ///
    /// ```swift
    /// contentView
    ///     .actionArea(model: .init(
    ///         variant: .strong(
    ///             main: .init(text: "확인", action: { confirmAction() }),
    ///             sub: .init(text: "취소", action: { cancelAction() })
    ///         ),
    ///         caption: "변경 사항을 저장하시겠습니까?"
    ///     ))
    /// ```
    public func actionArea(model: ActionArea.Model) -> some View {
        modifier(ActionAreaModifier(model: model))
    }
}
