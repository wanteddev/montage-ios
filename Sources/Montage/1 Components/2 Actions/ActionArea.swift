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
/// - Note: 키보드가 표시될 때 ActionArea가 위치가 자동으로 키보드 상단에 붙어있도록 조정됩니다.
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

    @State private var isKeyboardVisible = false
    @State private var height: CGFloat = .zero
    @State private var backgroundOpacity: CGFloat = 1
    @State private var gradientOpacity: CGFloat = 1
    @State private var isExtraEmpty = true

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                extra()
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    .background(backgroundColor)
                    .ifEmptyView { isExtraEmpty = $0 }

                if !isExtraEmpty && extraDivider {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.semantic(.lineNeutralTertiary))
                        .frame(height: 1)
                }
            }

            if isExtraEmpty {
                SwiftUI.Color.semantic(.surfaceElevatedPrimary)
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
        .onAppear {
            applyTransparentBackground(transparentBackground, animated: false)
        }
        .onChange(of: transparentBackground) { newValue in
            applyTransparentBackground(newValue, animated: true)
        }
        .onChange(of: isExtraEmpty) { _ in
            applyTransparentBackground(transparentBackground, animated: true)
        }
    }

    // MARK: - Modifiers
    
    private var transparentBackground = false
    private var caption: String?
    private var captionIcon: Icon?
    private var extra: () -> AnyView = { AnyView(EmptyView()) }
    private var extraDivider = true
    private var customBackgroundColor: SwiftUI.Color?

    /// 배경을 투명하게 설정합니다.
    ///
    /// 이 수정자를 사용하면 그라데이션 배경이 숨겨지고 투명한 배경이 표시됩니다.
    ///
    /// - Parameter transparentBackground: 배경 투명 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ActionArea 인스턴스
    public func transparentBackground(_ transparentBackground: Bool = true) -> Self {
        var zelf = self
        zelf.transparentBackground = transparentBackground
        return zelf
    }

    /// 버튼 위에 표시할 캡션 텍스트를 설정합니다.
    ///
    /// `icon`을 지정하면 캡션 텍스트 앞에 16pt 아이콘을 함께 표시합니다. 아이콘 색은 캡션 텍스트와 같습니다.
    ///
    /// ```swift
    /// .caption("변경 사항을 저장하시겠습니까?")                      // 텍스트만
    /// .caption("변경 사항을 저장하시겠습니까?", icon: .circleInfo)   // 아이콘 + 텍스트
    /// ```
    ///
    /// - Parameters:
    ///   - caption: 표시할 캡션 텍스트
    ///   - icon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
    /// - Returns: 수정된 ActionArea 인스턴스
    public func caption(_ caption: String?, icon: Icon? = nil) -> Self {
        var zelf = self
        zelf.caption = caption
        zelf.captionIcon = icon
        return zelf
    }

    /// 버튼 위에 표시할 추가 콘텐츠를 설정합니다.
    ///
    /// - Parameters:
    ///   - content: 표시할 추가 콘텐츠를 생성하는 클로저
    ///   - divider: 추가 콘텐츠 위에 구분선 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ActionArea 인스턴스
    public func extra<V: View>(@ViewBuilder _ content: @escaping () -> V, divider: Bool = true) -> Self {
        var zelf = self
        zelf.extra = { AnyView(content()) }
        zelf.extraDivider = divider
        return zelf
    }

    /// 배경 색상을 설정합니다.
    ///
    /// 지정한 색은 배경뿐 아니라 상단 sticky 그라데이션의 시작색으로도 함께 적용됩니다.
    /// 두 색이 어긋나면 경계가 보이므로 값을 분리하지 않습니다.
    ///
    /// - Parameter backgroundColor: 설정할 색상, 생략하면 기본값으로 `nil`을 적용하여 기본 배경색을 사용합니다.
    /// - Returns: 수정된 ActionArea 인스턴스
    public func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBackgroundColor = backgroundColor
        return zelf
    }
}

// MARK: - Types
extension ActionArea {
    /// ActionArea의 버튼 레이아웃 변형을 정의합니다.
    public enum Variant {
        /// 강조된 주 버튼과 보조/대체 버튼이 있는 레이아웃
        /// - Parameters:
        ///   - main: 주 버튼 정보
        ///   - sub: 보조 버튼 정보, 생략하면 기본값으로 `nil` 적용
        ///   - alternative: 대체 버튼 정보, 생략하면 기본값으로 `nil` 적용
        case strong(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        /// 중립적인 스타일의 버튼 레이아웃
        /// - Parameters:
        ///   - main: 주 버튼 정보
        ///   - sub: 보조 버튼 정보, 생략하면 기본값으로 `nil` 적용
        ///   - alternative: 대체 버튼 정보, 생략하면 기본값으로 `nil` 적용
        case neutral(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        /// 취소 버튼만 있는 간단한 레이아웃
        /// - Parameter main: 주 버튼 정보
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
        let backgroundTransparencyControl: ActionArea.BackgroundTransparencyControl
        let caption: String?
        let captionIcon: Icon?
        let extra: () -> AnyView
        let extraDivider: Bool
        let backgroundColor: SwiftUI.Color?

        /// ActionArea 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 버튼 레이아웃 변형
        ///   - backgroundTransparencyControl: 배경 투명도 제어 방식, 생략하면 기본값으로 `.automatic` 적용
        ///   - caption: 캡션 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
        ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
        ///   - backgroundColor: 배경 및 상단 그라데이션 시작 색상, 생략하면 기본값으로 `nil`을 적용하여 기본 배경색을 사용합니다.
        public init(
            variant: ActionArea.Variant,
            backgroundTransparencyControl: ActionArea.BackgroundTransparencyControl = .automatic,
            caption: String? = nil,
            captionIcon: Icon? = nil,
            backgroundColor: SwiftUI.Color? = nil
        ) {
            self.variant = variant
            self.backgroundTransparencyControl = backgroundTransparencyControl
            self.caption = caption
            self.captionIcon = captionIcon
            self.extra = { AnyView(EmptyView()) }
            self.extraDivider = true
            self.backgroundColor = backgroundColor
        }

        /// ActionArea 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 버튼 레이아웃 변형
        ///   - backgroundTransparencyControl: 배경 투명도 제어 방식, 생략하면 기본값으로 `.automatic` 적용
        ///   - caption: 캡션 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
        ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
        ///   - extra: 추가 콘텐츠를 생성하는 클로저
        ///   - extraDivider: 추가 콘텐츠 위에 구분선 표시 여부, 생략하면 기본값으로 `true` 적용
        ///   - backgroundColor: 배경 및 상단 그라데이션 시작 색상, 생략하면 기본값으로 `nil`을 적용하여 기본 배경색을 사용합니다.
        public init<V: View>(
            variant: ActionArea.Variant,
            backgroundTransparencyControl: ActionArea.BackgroundTransparencyControl = .automatic,
            caption: String? = nil,
            captionIcon: Icon? = nil,
            @ViewBuilder extra: @escaping () -> V,
            extraDivider: Bool = true,
            backgroundColor: SwiftUI.Color? = nil
        ) {
            self.variant = variant
            self.backgroundTransparencyControl = backgroundTransparencyControl
            self.caption = caption
            self.captionIcon = captionIcon
            self.extra = { AnyView(extra()) }
            self.extraDivider = extraDivider
            self.backgroundColor = backgroundColor
        }
    }
    
    /// ActionArea의 배경 투명도를 제어하는 열거형입니다.
    public enum BackgroundTransparencyControl {
        /// 자동으로 배경 투명도를 결정합니다. 기본적으로 스크롤 위치나 콘텐츠에 따라 투명도가 자동 처리됩니다.
        case automatic
        /// 수동으로 배경 투명도를 설정합니다. true면 배경이 투명해지고, false면 배경이 표시됩니다.
        case manual(_ transparency: Bool)
        
        var isManual: Bool {
            switch self {
            case .automatic:
                false
            case .manual:
                true
            }
        }
    }
}

// MARK: - Private
extension ActionArea {
    private var captionView: some View {
        Group {
            if let caption = caption, variant.isCaptionAvailable {
                HStack(spacing: 4) {
                    if let captionIcon {
                        Image.icon(captionIcon)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralTertiary))
                    }

                    Text(caption)
                        .paragraph(variant: .label2, weight: .medium, semantic: .foregroundNeutralTertiary)
                }
            }
        }
    }

    private var baseColor: SwiftUI.Color {
        customBackgroundColor ?? .semantic(.surfaceElevatedPrimary)
    }

    private var gradient: [SwiftUI.Color] {
        [0, 0.14, 0.27, 0.38, 0.48, 0.57, 0.65, 0.71, 0.77, 0.82, 0.86, 0.9, 0.93, 0.96, 0.98, 1]
            .map {
                baseColor.opacity($0)
            }
    }

    private var backgroundColor: SwiftUI.Color {
        baseColor.opacity(backgroundOpacity)
    }
    
    private func applyTransparentBackground(_ transparentBackground: Bool, animated: Bool) {
        let update = {
            backgroundOpacity = (transparentBackground && isExtraEmpty) ? 0 : 1
            gradientOpacity = transparentBackground ? 0 : 1
        }

        if animated {
            withAnimation(.easeInOut(duration: 0.5)) {
                update()
            }
        } else {
            update()
        }
    }
}

// MARK: - Inner Views

extension ActionArea {
    private struct Buttons: View {
        private let variant: Variant

        init(_ variant: Variant) {
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
                .caption(model.caption, icon: model.captionIcon)
                .extra(model.extra, divider: model.extraDivider)
                .backgroundColor(model.backgroundColor)
                .modifying {
                    if case .manual(let transparency) = model.backgroundTransparencyControl {
                        $0.transparentBackground(transparency)
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
    ///   - variant: ActionArea의 버튼 레이아웃 변형
    ///   - backgroundTransparency: 배경 투명도 설정, 생략하면 기본값으로 `false` 적용
    ///   - caption: 캡션 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
    ///   - backgroundColor: 배경 및 상단 그라데이션 시작 색상, 생략하면 기본값으로 `nil`을 적용하여 기본 배경색을 사용합니다.
    /// - Returns: ActionArea가 적용된 뷰
    ///
    /// ```swift
    /// contentView
    ///     .actionArea(
    ///         variant: .strong(
    ///             main: .init(text: "확인", action: { confirmAction() }),
    ///             sub: .init(text: "취소", action: { cancelAction() })
    ///         ),
    ///         caption: "변경 사항을 저장하시겠습니까?"
    ///     )
    /// ```
    public func actionArea(
        variant: ActionArea.Variant,
        backgroundTransparency: Bool = false,
        caption: String? = nil,
        captionIcon: Icon? = nil,
        backgroundColor: SwiftUI.Color? = nil
    ) -> some View {
        modifier(
            ActionAreaModifier(
                model: .init(
                    variant: variant,
                    backgroundTransparencyControl: .manual(backgroundTransparency),
                    caption: caption,
                    captionIcon: captionIcon,
                    backgroundColor: backgroundColor
                )
            )
        )
    }
    
    /// 현재 뷰에 하단 ActionArea를 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: ActionArea의 버튼 레이아웃 변형
    ///   - backgroundTransparency: 배경 투명도 설정, 생략하면 기본값으로 `true` 적용
    ///   - caption: 캡션 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - captionIcon: 캡션 텍스트 앞에 표시할 아이콘, 생략하면 기본값으로 `nil`을 적용하여 아이콘을 표시하지 않습니다.
    ///   - extra: 추가 콘텐츠를 생성하는 클로저
    ///   - extraDivider: 추가 콘텐츠 위에 구분선 표시 여부, 생략하면 기본값으로 `true` 적용
    ///   - backgroundColor: 배경 및 상단 그라데이션 시작 색상, 생략하면 기본값으로 `nil`을 적용하여 기본 배경색을 사용합니다.
    /// - Returns: ActionArea가 적용된 뷰
    ///
    /// ```swift
    /// contentView
    ///     .actionArea(
    ///         variant: .strong(
    ///             main: .init(text: "확인", action: { confirmAction() }),
    ///             sub: .init(text: "취소", action: { cancelAction() })
    ///         ),
    ///         caption: "변경 사항을 저장하시겠습니까?",
    ///         extra: {
    ///             Text("추가 정보")
    ///                 .typography(variant: .label2)
    ///         },
    ///         extraDivider: true
    ///     )
    /// ```
    public func actionArea<V: View>(
        variant: ActionArea.Variant,
        backgroundTransparency: Bool = true,
        caption: String? = nil,
        captionIcon: Icon? = nil,
        @ViewBuilder extra: @escaping () -> V,
        extraDivider: Bool = true,
        backgroundColor: SwiftUI.Color? = nil
    ) -> some View {
        modifier(
            ActionAreaModifier(
                model: .init(
                    variant: variant,
                    backgroundTransparencyControl: .manual(backgroundTransparency),
                    caption: caption,
                    captionIcon: captionIcon,
                    extra: extra,
                    extraDivider: extraDivider,
                    backgroundColor: backgroundColor
                )
            )
        )
    }
}
