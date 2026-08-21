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
/// ```swift
/// ScreenScaffold {
///     VStack(spacing: 16) {
///         ForEach(items) { row($0) }
///     }
///     .padding(.horizontal, 20)
/// }
/// .topNavigation {
///     TopNavigation()
///         .title("언어 설정")
/// }
/// .actionArea {
///     ActionArea(variant: .neutral(main: .init(text: "저장", action: save)))
/// }
/// ```
///
/// ## 스크롤을 누가 쥐는가
///
/// 기본값 ``ScrollContainer/builtIn``은 스캐폴드가 ``Montage/ScrollView``를 깔아 줍니다.
/// `List`처럼 스크롤을 스스로 쥐어야 하는 콘텐츠는 ``ScrollContainer/content``로 바꾸고,
/// 콘텐츠가 직접 신호를 올립니다.
///
/// ```swift
/// ScreenScaffold(scrollContainer: .content) {
///     List {
///         ForEach(items) { row($0) }
///     }
///     .reportsScrollOffset()
///     .reportsScrollReachedEnd()
/// }
/// ```
///
/// ## 쓰지 않는 곳
///
/// ``BottomSheet``와 ``Popup`` 안에는 넣지 않습니다. 두 컴포넌트가 이미 같은 일을 합니다 -
/// 콘텐츠 스크롤 상태를 스스로 재서 ``ActionArea``에 넘기고, ``ActionArea``의 높이를 자기
/// 높이 계산에 넣어 `resize`와 드래그 범위를 정합니다. 그 안에 스캐폴드를 한 겹 더 두면
/// 시트가 높이를 계산할 근거를 잃습니다. ``ActionArea``는 `actionArea:` 인자로 넘기세요.
///
/// 다만 `isFullScreenCover`로 띄운 전체 화면이나 `navigationDestination`으로 push한 화면은
/// 시트가 아니라 하나의 화면이므로, 그 안에서는 이 스캐폴드를 씁니다.
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
        case content
    }

    // MARK: - Initializer

    private let scrollContainer: ScrollContainer
    private let content: () -> Content

    /// 화면 스캐폴드를 초기화합니다.
    ///
    /// - Parameters:
    ///   - scrollContainer: 스크롤 컨테이너를 누가 둘지, 생략하면 기본값으로 ``ScrollContainer/builtIn`` 적용
    ///   - content: 화면 본문을 만드는 클로저
    public init(
        scrollContainer: ScrollContainer = .builtIn,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.scrollContainer = scrollContainer
        self.content = content
    }

    // MARK: - Body

    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets

    /// ``ScrollContainer/builtIn``에서 스캐폴드가 직접 재는 스크롤 상태.
    @State private var scrollStatus = ScrollView.ScrollStatus()
    /// ``ScrollContainer/content``에서 콘텐츠가 preference로 올려 준 값.
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

    private var topNavigation: (() -> TopNavigation)?
    private var actionArea: (() -> ActionArea)?
    private var backgroundColor: SwiftUI.Color?

    /// 화면 상단에 ``TopNavigation``을 놓습니다.
    ///
    /// 스크롤 오프셋은 스캐폴드가 넣어 주므로 호출부가 넘기지 않습니다.
    ///
    /// - Parameter topNavigation: 상단에 배치할 ``TopNavigation``을 만드는 클로저
    /// - Returns: 수정된 스캐폴드
    ///
    /// - Note: 슬롯 클로저에 `@ViewBuilder`를 붙이지 않았습니다. 붙이면 `if`문이
    ///   `_ConditionalContent`를 만들어 ``TopNavigation`` 타입 제약이 깨집니다.
    public func topNavigation(_ topNavigation: @escaping () -> TopNavigation) -> Self {
        var zelf = self
        zelf.topNavigation = topNavigation
        return zelf
    }

    /// 화면 하단에 ``ActionArea``를 놓습니다.
    ///
    /// 스크롤 하단 도달 여부는 스캐폴드가 전달하므로 호출부가 넘기지 않습니다.
    ///
    /// - Parameter actionArea: 하단에 배치할 ``ActionArea``를 만드는 클로저
    /// - Returns: 수정된 스캐폴드
    ///
    /// - Note: 슬롯 클로저에 `@ViewBuilder`를 붙이지 않은 이유는
    ///   ``topNavigation(_:)``과 같습니다.
    public func actionArea(_ actionArea: @escaping () -> ActionArea) -> Self {
        var zelf = self
        zelf.actionArea = actionArea
        return zelf
    }

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

        case .content:
            content()
                .background(backgroundColor ?? .clear)
                .safeAreaInset(edge: .top, spacing: 0) {
                    SwiftUI.Color.clear.frame(height: navigationHeight)
                }
        }
    }

    @ViewBuilder
    var navigationLayer: some View {
        if let topNavigation {
            topNavigation()
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
    /// ``ScrollContainer/content``인데 콘텐츠가 신호를 올리지 않으면 스크롤 위치를 알 수 없다.
    /// 이때 최상단(`0`)으로 두면 배경이 투명해져 콘텐츠가 내비게이션 글자와 겹치므로,
    /// 배경이 완전히 짙어지는 값을 넣어 불투명으로 고정한다.
    var effectiveScrollOffset: CGFloat {
        switch scrollContainer {
        case .builtIn:
            scrollStatus.contentOffset.y
        case .content:
            reportedScrollOffset ?? -safeAreaInsets.top
        }
    }

    var effectiveScrollReachedEnd: Bool? {
        switch scrollContainer {
        case .builtIn:
            scrollStatus.reachedEnd
        case .content:
            reportedScrollReachedEnd
        }
    }
}
