//
//  ScreenScaffold.swift
//  Montage
//
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI

/// 화면의 골격을 잡는 컨테이너입니다.
///
/// 상단 ``TopNavigation``, 하단 ``ActionArea``, 그리고 그 사이 스크롤 영역을 한곳에서 관리합니다.
/// 세 요소는 서로의 크기와 스크롤 상태에 의존하므로, 따로 붙이면 호출부가 그 배선을 떠안게 됩니다.
///
/// ``BottomSheet``·``Popup``과 같은 형태로 슬롯을 받습니다. 본문은 마지막 인자입니다 -
/// 슬롯이 함께 오면 SwiftLint의 `multiple_closures_with_trailing_closure`가 trailing closure를
/// 막으므로, 이 레포의 다른 호출부와 같이 괄호 안에 둡니다.
///
/// ```swift
/// ScreenScaffold(
///     navigation: {
///         TopNavigation()
///             .title("언어 설정")
///     },
///     actionArea: {
///         ActionArea(variant: .neutral(main: .init(text: "저장", action: save)))
///     },
///     {
///         VStack(spacing: 16) {
///             ForEach(items) { row($0) }
///         }
///         .padding(.horizontal, 20)
///     }
/// )
/// ```
///
/// ## 스크롤을 누가 쥐는가
///
/// 기본값 ``ScrollContainer/builtIn``은 스캐폴드가 ``Montage/ScrollView``를 깔아 줍니다.
/// `List`처럼 스크롤을 스스로 쥐어야 하는 콘텐츠는 ``ScrollContainer/custom``로 바꾸고,
/// 콘텐츠가 직접 신호를 올립니다.
///
/// ```swift
/// ScreenScaffold(scrollContainer: .custom) {
///     List {
///         ForEach(items) { row($0) }
///             .listRowBackground(SwiftUI.Color.clear)
///     }
///     .scrollContentBackground(.hidden)
///     .reportsScrollOffset()
///     .reportsScrollReachedEnd()
/// }
/// ```
///
/// `List`는 행 배경과 스크롤 배경을 각각 깔기 때문에 둘 다 걷어내야 합니다. 하나만 처리하면
/// ``backgroundColor(_:)``로 지정한 색이 가려지고, ``ActionArea``가 바닥에서 투명해질 때
/// 그 경계가 드러납니다.
///
/// - Note: ``BottomSheet``·``Popup`` 안에는 넣지 않습니다. 두 컴포넌트가 같은 일을 하며
///   ``ActionArea`` 높이를 자기 높이 계산에 쓰므로 `actionArea:` 인자로 넘기세요.
///   전체 화면 커버나 push된 목적지는 시트가 아니라 화면이므로 여기에 해당하지 않습니다.
public struct ScreenScaffold<Content: View>: View {
    /// 스크롤 컨테이너를 누가 두는지 정합니다.
    public enum ScrollContainer: Equatable {
        /// 스캐폴드가 ``Montage/ScrollView``를 깔고, 콘텐츠는 그 안에 놓입니다.
        case builtIn
        /// 콘텐츠가 스크롤 컨테이너를 직접 둡니다. `List`처럼 컨테이너를 바꿀 수 없을 때 씁니다.
        ///
        /// 스캐폴드가 스크롤 상태를 알 수 없으므로, 콘텐츠가
        /// ``SwiftUI/View/reportsScrollOffset(_:)``과
        /// ``SwiftUI/View/reportsScrollReachedEnd(_:)``로 직접 신호를 올려야 합니다.
        case custom
    }

    // MARK: - Initializer

    private let scrollContainer: ScrollContainer
    private let navigation: (() -> TopNavigation)?
    private let actionArea: (() -> ActionArea)?
    private let content: () -> Content

    /// 화면 스캐폴드를 초기화합니다.
    ///
    /// 스크롤 오프셋과 하단 도달 여부는 스캐폴드가 슬롯에 넣어 주므로 호출부가 넘기지 않습니다.
    ///
    /// - Parameters:
    ///   - scrollContainer: 스크롤 컨테이너를 누가 둘지, 생략하면 기본값으로 ``ScrollContainer/builtIn`` 적용
    ///   - navigation: 상단에 배치할 ``TopNavigation``을 만드는 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - actionArea: 하단에 배치할 ``ActionArea``를 만드는 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - content: 화면 본문을 만드는 클로저
    ///
    /// - Note: 슬롯 클로저에 `@ViewBuilder`를 붙이지 않았습니다. 붙이면 `if`문이
    ///   `_ConditionalContent`를 만들어 ``ActionArea``·``TopNavigation`` 타입 제약이 깨집니다.
    ///   조건부로 넣을 때는 `actionArea: isEditing ? slot : nil`처럼 클로저 자체를 갈라 주세요.
    public init(
        scrollContainer: ScrollContainer = .builtIn,
        navigation: (() -> TopNavigation)? = nil,
        actionArea: (() -> ActionArea)? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.scrollContainer = scrollContainer
        self.navigation = navigation
        self.actionArea = actionArea
        self.content = content
    }

    // MARK: - Body

    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets

    /// ``ScrollContainer/builtIn``에서 스캐폴드가 직접 재는 스크롤 상태.
    @State private var scrollStatus = ScrollView.ScrollStatus()
    /// ``ScrollContainer/custom``에서 콘텐츠가 preference로 올려 준 값.
    @State private var reportedScrollOffset: CGFloat?
    @State private var reportedScrollReachedEnd: Bool?
    /// ``TopNavigation``이 차지하는 높이. 콘텐츠 상단 여백이 이 값을 따른다.
    @State private var navigationHeight: CGFloat = .zero

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .top) {
            contentLayer
                // ActionArea를 safe area로 넣으면 스크롤 컨테이너가 그만큼 콘텐츠 인셋을 잡아,
                // 바닥까지 내렸을 때 마지막 요소가 버튼에 가리지 않는다. 인셋을 쓰지 않고 높이를
                // 잘라내면 ActionArea 그라데이션이 덮는 만큼을 호출부가 손으로 비워 줘야 한다.
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    actionAreaLayer
                }

            navigationLayer
        }
        .environment(\.topNavigationScrollOffset, effectiveScrollOffset)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { reportedScrollOffset = $0 }
        .onPreferenceChange(ScrollReachedEndPreferenceKey.self) { reportedScrollReachedEnd = $0 }
    }

    // MARK: - Modifiers

    private var backgroundColor: SwiftUI.Color?

    /// 화면 전체의 바탕색을 설정합니다.
    ///
    /// - Parameter color: 바탕색, `nil`이면 칠하지 않습니다
    /// - Returns: 수정된 스캐폴드
    public func backgroundColor(_ color: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.backgroundColor = color
        return zelf
    }
}

// MARK: - Private

private extension ScreenScaffold {
    @ViewBuilder
    var contentLayer: some View {
        switch scrollContainer {
        case .builtIn:
            ScrollView(scrollStatus: $scrollStatus) {
                content()
            }
            .background(backgroundColor ?? .clear)
            // TopNavigation은 콘텐츠 위에 겹쳐 그려지고 스크롤 양에 따라 배경이 짙어진다.
            // 콘텐츠를 밀어내는 대신 인셋으로 자리를 비워야 그 아래로 흘러 지나간다.
            .safeAreaInset(edge: .top, spacing: 0) {
                SwiftUI.Color.clear.frame(height: navigationHeight)
            }

        case .custom:
            content()
                .background(backgroundColor ?? .clear)
                .safeAreaInset(edge: .top, spacing: 0) {
                    SwiftUI.Color.clear.frame(height: navigationHeight)
                }
        }
    }

    @ViewBuilder
    var navigationLayer: some View {
        if let navigation {
            navigation()
                .onGeometryChange(
                    for: CGSize.self,
                    of: { $0.size },
                    action: { navigationHeight = $0.height }
                )
        }
    }

    @ViewBuilder
    var actionAreaLayer: some View {
        if let actionArea {
            actionArea()
                .environment(\.actionAreaScrollReachedEnd, effectiveScrollReachedEnd)
        }
    }

    /// ``TopNavigation``에 내려 줄 스크롤 오프셋.
    ///
    /// ``ScrollContainer/custom``인데 콘텐츠가 신호를 올리지 않으면 스크롤 위치를 알 수 없다.
    /// 이때 최상단(`0`)으로 두면 배경이 투명해져 콘텐츠가 내비게이션 글자와 겹치므로,
    /// 배경이 완전히 짙어지는 값을 넣어 불투명으로 고정한다.
    var effectiveScrollOffset: CGFloat {
        switch scrollContainer {
        case .builtIn:
            scrollStatus.contentOffset.y
        case .custom:
            reportedScrollOffset ?? -safeAreaInsets.top
        }
    }

    var effectiveScrollReachedEnd: Bool? {
        switch scrollContainer {
        case .builtIn:
            scrollStatus.reachedEnd
        case .custom:
            reportedScrollReachedEnd
        }
    }
}
