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
    @State private var isExtraEmpty = true

    @Environment(\.actionAreaScrollReachedEnd) private var inheritedScrollReachedEnd

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                extra()
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    .background(backgroundColor)
                    .animation(.easeInOut(duration: 0.5), value: hidesBackground)
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
                    .opacity(showsGradient ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showsGradient)
            }

            VStack(spacing: 16) {
                captionView

                Buttons(variant)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, isKeyboardVisible ? 20 : 0)
            .background(backgroundColor)
            .animation(.easeInOut(duration: 0.5), value: hidesBackground)
        }
        .onReceive(keyboardPublisher) { isKeyboardVisible = $0 }
    }

    // MARK: - Modifiers
    
    private var explicitScrollReachedEnd: Bool?
    private var caption: String?
    private var captionIcon: Icon?
    private var extra: () -> AnyView = { AnyView(EmptyView()) }
    private var extraDivider = true
    private var customBackgroundColor: SwiftUI.Color?

    /// 스크롤이 바닥에 닿았는지를 직접 알려줍니다.
    ///
    /// ``ActionArea``는 상단 그라데이션으로 "아래에 가려진 콘텐츠가 있다"를 표현합니다.
    /// ``Montage/ScrollView``를 쓰면 이 값이 자동으로 전달되므로 이 수정자는 필요 없습니다.
    /// `SwiftUI.ScrollView`·`List`처럼 신호를 올려주지 않는 컨테이너를 쓸 때만 사용합니다.
    ///
    /// ```swift
    /// ActionArea(variant: .strong(main: .init(text: "확인", action: {})))
    ///     .scrollReachedEnd(scrollProxy.isAtBottom)
    /// ```
    ///
    /// - Parameter reachedEnd: 스크롤이 끝에 닿았는지 여부. `true`면 그라데이션을 숨깁니다.
    /// - Returns: 수정된 ActionArea 인스턴스
    public func scrollReachedEnd(_ reachedEnd: Bool) -> Self {
        var zelf = self
        zelf.explicitScrollReachedEnd = reachedEnd
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
    /// - Parameter backgroundColor: 설정할 색상. `nil`을 전달하면 기본 배경색을 사용합니다.
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
        /// - Note: 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 `fillWidth(_:)` 모디파이어를 사용하세요.
        public static func custom<V: View>(@ViewBuilder _ custom: @escaping () -> V) -> Self {
            var zelf = self.init(text: "", action: {})
            zelf.custom = { AnyView(custom()) }
            return zelf
        }
    }
}

// MARK: - Scroll Signal

/// ``ActionArea``에게 "아래 스크롤이 바닥에 닿았는지"를 내려보내는 환경 값입니다.
///
/// `nil`은 스크롤 컨테이너가 없다는 뜻이며, 이때 그라데이션은 그리지 않습니다.
/// ``ActionArea/scrollReachedEnd(_:)``로 직접 지정한 값이 있으면 그쪽이 우선합니다.
struct ActionAreaScrollReachedEndKey: EnvironmentKey {
    static let defaultValue: Bool? = nil
}

extension EnvironmentValues {
    var actionAreaScrollReachedEnd: Bool? {
        get { self[ActionAreaScrollReachedEndKey.self] }
        set { self[ActionAreaScrollReachedEndKey.self] = newValue }
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

    /// 그라데이션을 끌 때는 배경도 함께 걷어 페이지 배경이 그대로 비치게 한다.
    ///
    /// 다크 모드에서는 ActionArea 배경(`surfaceElevatedPrimary`)과 페이지 배경이 다른 색이라,
    /// 그라데이션만 끄고 배경을 남기면 경계가 선처럼 드러난다. 라이트 모드에서는 두 색이 사실상
    /// 같아 티가 나지 않을 뿐이다. extra 슬롯이 있으면 그 영역은 배경이 있어야 하므로 유지한다.
    private var hidesBackground: Bool {
        !showsGradient && isExtraEmpty
    }

    /// 실제로 칠하는 배경색. 바닥에 닿으면 투명해진다.
    private var backgroundColor: SwiftUI.Color {
        baseColor.opacity(hidesBackground ? 0 : 1)
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

    /// 직접 지정한 값이 있으면 그 값을, 없으면 스크롤 컨테이너가 내려준 값을 쓴다.
    private var scrollReachedEnd: Bool? {
        explicitScrollReachedEnd ?? inheritedScrollReachedEnd
    }

    /// 그라데이션은 "아래에 가려진 콘텐츠가 있다"는 표시이면서, ActionArea 배경에서 페이지 배경으로
    /// 넘어가는 경계를 부드럽게 잇는 역할도 한다. 그래서 끄는 쪽이 예외다.
    ///
    /// 바닥에 닿았다는 신호(`true`)를 받았을 때만 끄고, 신호가 없으면(`nil`) 가려진 콘텐츠가
    /// 있는지 알 수 없으므로 그린다.
    private var showsGradient: Bool {
        scrollReachedEnd != true
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
                    assistiveOutlinedButton(alternative)
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
                    assistiveOutlinedButton(alternative)
                }
                primarySolidButton(main)
            }
        }

        @ViewBuilder
        private func cancel(
            _ main: ButtonInfo
        ) -> some View {
            assistiveSolidButton(main)
        }

        @ViewBuilder private func primarySolidButton(_ buttonInfo: ButtonInfo) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                Button(
                    color: .primary,
                    size: .large,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .fillWidth()
            }
        }

        @ViewBuilder private func assistiveSolidButton(_ buttonInfo: ButtonInfo) -> some View {
            CustomOrFallback(custom: buttonInfo.custom) {
                Button(
                    color: .assistive,
                    size: .large,
                    text: buttonInfo.text,
                    handler: buttonInfo.action
                )
                .fillWidth()
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
                .fillWidth(fillWidth)
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
    private let actionArea: () -> ActionArea
    private let explicitScrollReachedEnd: Bool?

    init(scrollReachedEnd: Bool? = nil, actionArea: @escaping () -> ActionArea) {
        self.actionArea = actionArea
        explicitScrollReachedEnd = scrollReachedEnd
    }

    // MARK: - Body

    /// 콘텐츠 안의 ``Montage/ScrollView``가 올려준 하단 도달 신호.
    @State private var inheritedScrollReachedEnd: Bool?

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content

            actionArea()
        }
        // 스크롤 컨테이너는 콘텐츠 쪽에 있으므로 preference로 받아 environment로 되돌려 준다.
        .onPreferenceChange(ScrollReachedEndPreferenceKey.self) { inheritedScrollReachedEnd = $0 }
        .environment(
            \.actionAreaScrollReachedEnd,
            explicitScrollReachedEnd ?? inheritedScrollReachedEnd
        )
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 하단 ActionArea를 적용합니다.
    ///
    /// 구성은 ``ActionArea``의 모디파이어 체인으로 하고, 완성된 인스턴스를 이 슬롯에 넘깁니다.
    ///
    /// ```swift
    /// contentView
    ///     .actionArea {
    ///         ActionArea(variant: .strong(
    ///             main: .init(text: "확인", action: { confirmAction() }),
    ///             sub: .init(text: "취소", action: { cancelAction() })
    ///         ))
    ///         .caption("변경 사항을 저장하시겠습니까?")
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - scrollReachedEnd: 콘텐츠 스크롤이 바닥에 닿았는지 여부. ``Montage/ScrollView``를 쓰면 자동으로
    ///     전달되므로 생략하고, `SwiftUI.ScrollView`·`List`를 쓸 때만 직접 넘깁니다.
    ///   - actionArea: 하단에 배치할 ``ActionArea``를 만드는 클로저
    /// - Returns: ActionArea가 적용된 뷰
    ///
    /// - Note: 슬롯 클로저에 `@ViewBuilder`를 붙이지 않았습니다. 붙이면 `if`문이 `_ConditionalContent`를
    ///   만들어 ``ActionArea`` 타입 제약이 깨집니다. 공개 모디파이어가 모두 `Self`를 돌려주므로
    ///   체인과 삼항 연산자는 그대로 쓸 수 있습니다.
    public func actionArea(
        scrollReachedEnd: Bool? = nil,
        _ actionArea: @escaping () -> ActionArea
    ) -> some View {
        modifier(
            ActionAreaModifier(scrollReachedEnd: scrollReachedEnd, actionArea: actionArea)
        )
    }
}
