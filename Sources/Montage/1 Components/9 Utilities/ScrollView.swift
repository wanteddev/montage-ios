//
//  ScrollView.swift
//  Montage
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI

/// 스크롤 상태 추적과 오프셋 감지가 가능한 커스텀 스크롤 뷰입니다.
///
/// 기본 SwiftUI 스크롤 뷰를 확장하여 스크롤 상태 추적, 오프셋 감지, 새로고침 등
/// 추가 기능을 제공합니다.
///
/// ```swift
/// @State private var scrollStatus = ScrollView.ScrollStatus()
///
/// ScrollView(scrollStatus: $scrollStatus, 
///             onOffsetChanged: { offset in
///               print("스크롤 오프셋: \(offset)")
///             }) {
///     VStack(spacing: 16) {
///         ForEach(0..<20) { index in
///             Text("항목 \(index)")
///                 .frame(maxWidth: .infinity)
///                 .padding()
///                 .background(Color.gray.opacity(0.1))
///                 .cornerRadius(8)
///         }
///     }
///     .padding()
/// }
/// .axis(.vertical)
/// .hidesIndicators()
/// .onRefresh {
///     // 새로고침 작업 수행
///     try? await Task.sleep(nanoseconds: 2_000_000_000)
/// }
/// ```
public struct ScrollView: View {
    // MARK: - Initializer
    private var externalScrollStatus: Binding<ScrollStatus>?
    private let onOffsetChanged: (CGPoint) -> Void
    private let content: () -> any View

    /// 스크롤 뷰를 초기화합니다.
    ///
    /// - Parameters:
    ///   - scrollStatus: 스크롤 상태를 추적하기 위한 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - onOffsetChanged: 스크롤 오프셋이 변경될 때 호출되는 클로저, 생략하면 기본값으로 빈 클로저 적용
    ///   - content: 스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저
    public init(
        scrollStatus: Binding<ScrollStatus>? = nil,
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> any View
    ) {
        self.onOffsetChanged = onOffsetChanged
        externalScrollStatus = scrollStatus
        self.content = content
    }

    // MARK: - Body
    
    @State private var defaultScrollStatus = ScrollStatus()

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        SwiftUI.ScrollView(axisSet, showsIndicators: !hidesIndicators) {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    SwiftUI.Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(in: .named("ScrollViewOrigin")).origin
                    )
                }
                .frame(width: 0, height: 0)
                VStack {
                    AnyView(content())
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, for: .milliseconds(200), action: {
                            scrollStatus.wrappedValue.contentSize = $0
                        })
                }
            }
        }
        .background(
            GeometryReader { proxy in
                SwiftUI.Color.clear.preference(
                    key: ScrollViewSizePreferenceKey.self,
                    value: proxy.size
                )
            }
        )
        .coordinateSpace(name: "ScrollViewOrigin")
        .onChange(of: axis) {
            scrollStatus.wrappedValue.axis = $0
        }
        .onPreferenceChange(OffsetPreferenceKey.self) {
            scrollStatus.wrappedValue.contentOffset = $0
            onOffsetChanged($0)
        }
        .onPreferenceChange(ScrollViewSizePreferenceKey.self) {
            scrollStatus.wrappedValue.scrollViewSize = $0
        }
        // 하단 도달 여부를 위로 올려 ``ActionArea``가 그라데이션 표시를 스스로 정하게 한다.
        // 가로 스크롤(캐러셀 등)은 하단이라는 개념이 없어 신호를 내지 않는다.
        .preference(
            key: ScrollReachedEndPreferenceKey.self,
            value: axis == .vertical ? scrollStatus.wrappedValue.reachedEnd : nil
        )
        // 세로 오프셋도 함께 올려 ``ScreenScaffold``의 ``TopNavigation``이 배경 농도를 정하게 한다.
        .preference(
            key: ScrollOffsetPreferenceKey.self,
            value: axis == .vertical ? scrollStatus.wrappedValue.contentOffset.y : nil
        )
        .if(onRefresh != nil) {
            if #available(iOS 18, *) {
            	$0.pullToRefresh(scrollYOffset: scrollStatus.contentOffset.y) {
                    await onRefresh?()
                }
            } else {
                $0.refreshable {
                    await onRefresh?()
                }
            }
        }
    }

    // MARK: - Modifiers
    private var axis: Axis = .vertical
    private var hidesIndicators = false
    private var onRefresh: (() async -> Void)?

    /// 스크롤 방향을 설정합니다.
    ///
    /// - Parameter axis: 스크롤 방향 (.vertical 또는 .horizontal)
    /// - Returns: 수정된 스크롤 뷰
    public func axis(_ axis: Axis) -> Self {
        var zelf = self
        zelf.axis = axis
        return zelf
    }

    /// 스크롤 인디케이터 표시 여부를 설정합니다.
    ///
    /// - Parameter hidesIndicators: 인디케이터를 숨길지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 스크롤 뷰
    public func hidesIndicators(_ hidesIndicators: Bool = true) -> Self {
        var zelf = self
        zelf.hidesIndicators = hidesIndicators
        return zelf
    }

    /// 당겨서 새로고침 동작을 설정합니다.
    ///
    /// - Parameter perform: 새로고침 시 실행할 비동기 작업
    /// - Returns: 수정된 스크롤 뷰
    public func onRefresh(_ perform: @escaping () async -> Void) -> Self {
        var zelf = self
        zelf.onRefresh = perform
        return zelf
    }

    // MARK: - Types

    /// 스크롤 뷰의 상태를 추적하는 구조체입니다.
    ///
    /// 스크롤 방향, 스크롤 뷰 크기, 콘텐츠 크기, 오프셋 등의 정보를 포함합니다.
    public struct ScrollStatus: Equatable {
        /// 스크롤 방향
        public var axis: Axis
        /// 스크롤 뷰 크기
        public var scrollViewSize: CGSize
        /// 콘텐츠 크기
        public var contentSize: CGSize
        /// 콘텐츠 오프셋
        public var contentOffset: CGPoint

        /// 스크롤 상태를 초기화합니다.
        ///
        /// - Parameters:
        ///   - axis: 스크롤 방향, 생략하면 기본값으로 `.vertical` 적용
        ///   - scrollViewSize: 스크롤 뷰 크기, 생략하면 기본값으로 `.zero` 적용
        ///   - contentSize: 콘텐츠 크기, 생략하면 기본값으로 `.zero` 적용
        ///   - contentOffset: 콘텐츠 오프셋, 생략하면 기본값으로 `.zero` 적용
        public init(
            axis: Axis = .vertical,
            scrollViewSize: CGSize = .zero,
            contentSize: CGSize = .zero,
            contentOffset: CGPoint = .zero
        ) {
            self.axis = axis
            self.scrollViewSize = scrollViewSize
            self.contentSize = contentSize
            self.contentOffset = contentOffset
        }

        /// 스크롤이 끝(세로는 바닥, 가로는 오른쪽 끝)에 도달했는지 여부입니다.
        ///
        /// ``ActionArea``의 상단 그라데이션은 이 값으로 표시 여부를 정합니다.
        public var reachedEnd: Bool {
            // FloatingPoint 오류를 보정하기 위해 0.1을 빼줍니다.
            if axis == .vertical {
                contentOffset.y - 0.1 <= scrollViewSize.height - contentSize.height
            } else {
                contentOffset.x - 0.1 <= scrollViewSize.width - contentSize.width
            }
        }
    }
}

private extension ScrollView {
    var axisSet: Axis.Set {
        switch axis {
        case .horizontal: .horizontal
        case .vertical: .vertical
        }
    }
    
    var scrollStatus: Binding<ScrollStatus> {
        externalScrollStatus ?? $defaultScrollStatus
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {}
}

struct ScrollViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

// MARK: - Scroll Reached End Reporter

public extension View {
    /// 스크롤이 바닥에 닿았는지를 스스로 재서 하위 ``ActionArea``에 전달합니다.
    ///
    /// ``Montage/ScrollView``는 이 신호를 자동으로 올리므로 이 수정자가 필요 없습니다.
    /// 신호를 올려주지 않는 `SwiftUI.ScrollView`·`List`에만 붙입니다.
    ///
    /// ```swift
    /// List {
    ///     ForEach(items) { item in
    ///         row(item)
    ///             .scrollContentBottomMarker(isLast: item.id == items.last?.id)
    ///     }
    /// }
    /// .reportsScrollReachedEnd()
    /// .actionArea {
    ///     ActionArea(variant: .neutral(main: .init(text: "저장", action: save)))
    /// }
    /// ```
    ///
    /// - Parameter isEnabled: 신호를 올릴지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 하단 도달 신호를 올리는 뷰
    ///
    /// - Important: 배포 타깃이 iOS 18 미만이면 ``SwiftUI/View/scrollContentBottomMarker(isLast:)``를
    ///   마지막 요소에 함께 붙여야 합니다. 스크롤 기하를 한 번에 읽는 `onScrollGeometryChange`가
    ///   iOS 18부터라, 그 아래에서는 마지막 요소의 위치로 바닥을 가늠하기 때문입니다.
    ///   마커가 없으면 콘텐츠가 남아 있다고 보아 ``ActionArea``가 그라데이션을 계속 그립니다.
    func reportsScrollReachedEnd(_ isEnabled: Bool = true) -> some View {
        modifier(ScrollReachedEndReporter(isEnabled: isEnabled))
    }

    /// 스크롤 콘텐츠의 마지막 요소에 붙여 콘텐츠 바닥 위치를 컨테이너로 올립니다.
    ///
    /// ``SwiftUI/View/reportsScrollReachedEnd(_:)``가 iOS 18 미만에서 바닥 도달을 재는 근거입니다.
    /// `List`는 화면 밖 행을 만들지 않아 콘텐츠 전체 높이를 알 수 없으므로, 마지막 요소가
    /// 어디까지 내려왔는지를 직접 알려 줘야 합니다.
    ///
    /// - Parameter isLast: 이 요소가 마지막인지 여부, 생략하면 기본값으로 `true` 적용.
    ///   `false`면 아무 일도 하지 않습니다
    /// - Returns: 콘텐츠 바닥 위치를 올리는 뷰
    ///
    /// - Important: 배포 타깃이 iOS 18 미만일 때만 쓸 수 있습니다. iOS 18부터는
    ///   ``SwiftUI/View/reportsScrollReachedEnd(_:)``가 스크롤 기하를 직접 읽어 마커가 필요 없고,
    ///   붙여 둬도 행마다 `GeometryReader`를 다는 비용만 남습니다. 타깃을 18로 올리면 컴파일러가
    ///   이 호출을 잡아 주므로 그때 지우세요.
    @available(iOS, obsoleted: 18, message: "iOS 18부터는 reportsScrollReachedEnd()가 스크롤 기하를 직접 읽으므로 마커가 필요 없습니다.")
    func scrollContentBottomMarker(isLast: Bool = true) -> some View {
        overlay {
            if isLast {
                GeometryReader { proxy in
                    SwiftUI.Color.clear.preference(
                        key: ScrollContentBottomPreferenceKey.self,
                        value: proxy.frame(in: .global).maxY
                    )
                }
            }
        }
    }
}

/// 하단 도달 여부를 재는 경로를 iOS 버전에 따라 고르는 수정자입니다.
private struct ScrollReachedEndReporter: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content.modifying { view in
            if #available(iOS 18, *) {
                view.modifier(ScrollGeometryReachedEndReporter(isEnabled: isEnabled))
            } else {
                view.modifier(ContentMarkerReachedEndReporter(isEnabled: isEnabled))
            }
        }
    }
}

/// 스크롤 기하를 읽어 하단 도달 여부를 preference로 올리는 수정자입니다.
@available(iOS 18, *)
private struct ScrollGeometryReachedEndReporter: ViewModifier {
    /// 소수점 오차와 1pt 미만의 어긋남을 바닥으로 본다.
    private static let tolerance: CGFloat = 1

    let isEnabled: Bool

    @State private var reachedEnd: Bool?

    func body(content: Content) -> some View {
        content
            .modifying { view in
                if isEnabled {
                    view.onScrollGeometryChange(for: Bool.self) { geometry in
                        let visibleBottom = geometry.contentOffset.y + geometry.containerSize.height
                        let contentBottom = geometry.contentSize.height + geometry.contentInsets.bottom
                        return visibleBottom >= contentBottom - Self.tolerance
                    } action: { _, newValue in
                        reachedEnd = newValue
                    }
                } else {
                    view
                }
            }
            .preference(key: ScrollReachedEndPreferenceKey.self, value: isEnabled ? reachedEnd : nil)
    }
}

/// 마지막 요소가 올려 준 바닥 위치를 컨테이너 바닥과 견줘 하단 도달 여부를 내는 수정자입니다.
///
/// `onScrollGeometryChange`를 쓸 수 없는 iOS 18 미만 경로입니다.
private struct ContentMarkerReachedEndReporter: ViewModifier {
    /// 소수점 오차와 1pt 미만의 어긋남을 바닥으로 본다.
    private static let tolerance: CGFloat = 1

    let isEnabled: Bool

    @State private var reachedEnd: Bool?
    @State private var containerBottom: CGFloat?
    @State private var contentBottom: CGFloat?

    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    SwiftUI.Color.clear
                        .onAppear { containerBottom = proxy.frame(in: .global).maxY }
                        .onChange(of: proxy.frame(in: .global).maxY) { newValue in
                            containerBottom = newValue
                        }
                }
            }
            .onPreferenceChange(ScrollContentBottomPreferenceKey.self) { contentBottom = $0 }
            // 컨테이너 바닥과 마지막 요소 바닥은 서로 다른 시점에 갱신되므로 둘 다 본다.
            .onChange(of: contentBottom) { _ in update() }
            .onChange(of: containerBottom) { _ in update() }
            // 컨테이너가 사라지면(예: 빈 상태로 전환) 마지막 값이 남지 않게 되돌린다.
            .onDisappear { reachedEnd = nil }
            .preference(key: ScrollReachedEndPreferenceKey.self, value: isEnabled ? reachedEnd : nil)
    }

    private func update() {
        guard let containerBottom else {
            reachedEnd = nil
            return
        }
        guard let contentBottom else {
            // `List`는 화면 밖 행을 만들지 않는다. 마커를 못 찾았다는 건 마지막 요소가
            // 아직 렌더 범위 밖, 즉 가려진 콘텐츠가 남아 있다는 뜻이다. 마커를 아예 붙이지
            // 않은 경우도 같은 값이 되는데, 그편이 그라데이션을 잘못 지우는 것보다 안전하다.
            reachedEnd = false
            return
        }
        reachedEnd = contentBottom <= containerBottom + Self.tolerance
    }
}

/// 콘텐츠 마지막 요소의 바닥 위치를 화면 좌표(`.global`)로 올리는 키입니다.
///
/// `List` 안에서는 `.named(_:)` 좌표계가 스크롤 오프셋을 반영하지 않아 콘텐츠 기준 위치가
/// 그대로 올라옵니다. 화면 좌표는 스크롤을 따라 움직이므로 컨테이너 바닥과 바로 견줄 수 있습니다.
struct ScrollContentBottomPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let next = nextValue() else { return }
        value = max(value ?? next, next)
    }
}

public extension View {
    /// 세로 스크롤 오프셋을 스스로 재서 상위 ``ScreenScaffold``에 전달합니다.
    ///
    /// ``ScreenScaffold``의 ``TopNavigation``은 이 값으로 배경 농도를 정합니다. 스크롤을 스캐폴드가
    /// 쥐는 `.builtIn`에서는 자동으로 전달되므로, 소비자가 스크롤을 직접 쥐는 `.custom`에서만 붙입니다.
    ///
    /// ```swift
    /// ScreenScaffold(scrollContainer: .custom) {
    ///     List {
    ///         ForEach(items) { row($0) }
    ///     }
    ///     .reportsScrollOffset()
    ///     .reportsScrollReachedEnd()
    /// }
    /// ```
    ///
    /// - Parameter isEnabled: 신호를 올릴지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 스크롤 오프셋을 올리는 뷰
    ///
    /// - Important: 스크롤 기하를 읽는 `onScrollGeometryChange`가 iOS 18부터라 이 수정자도
    ///   iOS 18 이상에서만 쓸 수 있습니다. 그 아래 버전에서는 ``TopNavigation``이 배경 농도를
    ///   바꿀 근거를 얻지 못해 불투명 배경으로 고정됩니다.
    @available(iOS 18, *)
    func reportsScrollOffset(_ isEnabled: Bool = true) -> some View {
        modifier(ScrollOffsetReporter(isEnabled: isEnabled))
    }
}

/// 스크롤 기하를 읽어 세로 오프셋을 preference로 올리는 수정자입니다.
@available(iOS 18, *)
private struct ScrollOffsetReporter: ViewModifier {
    let isEnabled: Bool

    @State private var offset: CGFloat?

    func body(content: Content) -> some View {
        content
            .modifying { view in
                if isEnabled {
                    // ``Montage/ScrollView``가 올리는 값과 부호를 맞춘다. 최상단이 0이고
                    // 아래로 내릴수록 음수다.
                    view.onScrollGeometryChange(for: CGFloat.self) { geometry in
                        -(geometry.contentOffset.y + geometry.contentInsets.top)
                    } action: { _, newValue in
                        offset = newValue
                    }
                } else {
                    view
                }
            }
            .preference(key: ScrollOffsetPreferenceKey.self, value: isEnabled ? offset : nil)
    }
}

/// 세로 스크롤 컨테이너의 오프셋을 상위로 전달하는 키입니다.
///
/// `nil`은 "오프셋을 올려 주는 세로 스크롤 컨테이너가 없다"는 뜻입니다. 이때 ``TopNavigation``은
/// 스크롤 위치를 알 수 없으므로 배경을 불투명하게 고정합니다 - 투명하게 두면 콘텐츠가 내비게이션
/// 글자와 겹쳐 읽을 수 없게 됩니다.
///
/// 스크롤 컨테이너가 여럿이면 가장 많이 내려간 쪽(가장 작은 값)을 따릅니다.
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let next = nextValue() else { return }
        value = min(value ?? next, next)
    }
}

/// 세로 스크롤 컨테이너가 바닥에 닿았는지를 상위로 전달하는 키입니다.
///
/// `nil`은 "신호를 주는 세로 스크롤 컨테이너가 없다"는 뜻이고, 이때 ``ActionArea``는 가려진 콘텐츠가
/// 있는지 알 수 없으므로 그라데이션을 그대로 그립니다.
/// 스크롤 컨테이너가 여럿이면 하나라도 끝에 닿지 않은 쪽을 따른다 - 가려진 콘텐츠가 남아 있다는 뜻이기 때문이다.
struct ScrollReachedEndPreferenceKey: PreferenceKey {
    static let defaultValue: Bool? = nil

    static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
        guard let next = nextValue() else { return }
        value = (value ?? true) && next
    }
}
