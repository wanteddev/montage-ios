//
//  ScrollView.swift
//  Montage
//
//  Created by 김삼열 on 11/15/24.
//

import Observation
import SwiftUI

/// 스크롤 상태 추적과 오프셋 감지가 가능한 커스텀 스크롤 뷰입니다.
///
/// 기본 SwiftUI 스크롤 뷰를 확장하여 스크롤 상태 추적, 오프셋 감지, 새로고침 등
/// 추가 기능을 제공합니다.
///
/// 스크롤 위치는 스크롤 뷰 안에서만 추적하고, 바깥에는 필요한 만큼만 알립니다.
/// 오프셋에서 필요한 값만 뽑아 받으려면 ``onScrollOffsetChange(for:transform:action:)``를,
/// 크기와 오프셋을 함께 읽으려면 ``Geometry``를 씁니다.
///
/// ```swift
/// @State private var showsTopButton = false
///
/// ScrollView {
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
/// .onScrollOffsetChange(for: Bool.self) { offset in
///     offset.y < -300
/// } action: { _, newValue in
///     showsTopButton = newValue
/// }
/// .onRefresh {
///     // 새로고침 작업 수행
///     try? await Task.sleep(nanoseconds: 2_000_000_000)
/// }
/// ```
///
/// - Note: 콘텐츠 오프셋은 최상단에서 `0`이고, 아래(가로는 오른쪽)로 스크롤할수록 음수가 됩니다.
///   당겨서 새로고침처럼 최상단 너머로 당기면 양수가 됩니다.
public struct ScrollView: View {
    // MARK: - Initializer

    private let content: AnyView
    private var geometrySink: ((Metrics) -> Void)?
    private var legacyScrollStatus: Binding<ScrollStatus>?

    /// 스크롤 뷰를 초기화합니다.
    ///
    /// - Parameter content: 스크롤 뷰에 표시할 콘텐츠
    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }

    /// 스크롤 상태를 ``Geometry``에 기록하는 스크롤 뷰를 초기화합니다.
    ///
    /// `geometry`는 값이 바뀐 속성만 알리므로, 그 속성을 읽는 뷰만 다시 그려집니다.
    /// 스크롤마다 바뀌는 ``Geometry/contentOffset``을 화면 전체의 `body`에서 읽으면
    /// 스크롤하는 내내 화면 전체가 다시 그려지니, 읽는 부분을 작은 하위 뷰로 떼어 내세요.
    /// ``Geometry/reachedEnd``도 오프셋을 읽어 스크롤마다 다시 그려집니다. `Bool` 하나만 필요하면
    /// ``onScrollOffsetChange(for:transform:action:)``가 값이 바뀔 때만 알려 더 쌉니다.
    ///
    /// ```swift
    /// @State private var scrollGeometry = ScrollView.Geometry()
    ///
    /// ScrollView(geometry: scrollGeometry) {
    ///     content
    /// }
    /// .overlay(alignment: .bottom) {
    ///     BottomGradient(geometry: scrollGeometry) // 하위 뷰에서 reachedEnd를 읽는다
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - geometry: 스크롤 상태를 기록할 객체
    ///   - content: 스크롤 뷰에 표시할 콘텐츠
    @available(iOS 17, *)
    public init<Content: View>(geometry: Geometry, @ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
        geometrySink = { geometry.update($0) }
    }

    /// 스크롤 뷰를 초기화합니다.
    ///
    /// - Parameters:
    ///   - scrollStatus: 스크롤 상태를 추적하기 위한 바인딩
    ///   - onOffsetChanged: 스크롤 오프셋이 변경될 때 호출되는 클로저, 생략하면 기본값으로 빈 클로저 적용
    ///   - content: 스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저
    ///
    /// - Important: 스크롤할 때마다 `scrollStatus`에 값을 써서 바인딩을 쥔 뷰의 `body` 전체가 다시 그려집니다.
    ///   오프셋에서 필요한 값만 받으려면 ``onScrollOffsetChange(for:transform:action:)``를,
    ///   스크롤 상태를 통째로 읽어야 하면 ``init(geometry:content:)``를 쓰세요.
    @available(*, deprecated, message: "스크롤마다 바인딩을 쥔 뷰 전체가 다시 그려집니다. init(content:)에 onScrollOffsetChange(for:transform:action:)를 붙이거나 init(geometry:content:)를 쓰세요.")
    public init(
        scrollStatus: Binding<ScrollStatus>?,
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> any View
    ) {
        self.content = AnyView(content())
        legacyScrollStatus = scrollStatus
        offsetHandlers = [Self.legacyOffsetHandler(onOffsetChanged)]
    }

    /// 스크롤 뷰를 초기화합니다.
    ///
    /// - Parameters:
    ///   - onOffsetChanged: 스크롤 오프셋이 변경될 때 호출되는 클로저
    ///   - content: 스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저
    ///
    /// - Important: 스크롤할 때마다 `onOffsetChanged`가 불립니다. 그 안에서 상태를 바꾸면 그 상태를 쥔 뷰의
    ///   `body` 전체가 스크롤 틱마다 다시 그려집니다. 오프셋에서 필요한 값만 받으려면
    ///   ``onScrollOffsetChange(for:transform:action:)``를 쓰세요.
    @available(*, deprecated, message: "스크롤 틱마다 불립니다. init(content:)에 onScrollOffsetChange(for:transform:action:)를 붙여 필요한 값이 바뀔 때만 받으세요.")
    public init(
        onOffsetChanged: @escaping (CGPoint) -> Void,
        @ViewBuilder content: @escaping () -> any View
    ) {
        self.content = AnyView(content())
        offsetHandlers = [Self.legacyOffsetHandler(onOffsetChanged)]
    }

    /// `() -> any View`를 돌려주는 클로저로 스크롤 뷰를 초기화합니다.
    ///
    /// `any View`는 `View`를 따르지 않아 ``init(content:)``로 넘길 수 없습니다. 이전 init에 이런 클로저를
    /// 넘기던 호출을 받아 두려고 남긴 경로이며, `@ViewBuilder` 클로저는 이 init으로 오지 않습니다.
    ///
    /// - Parameter content: 스크롤 뷰에 표시할 콘텐츠를 반환하는 클로저
    @_disfavoredOverload
    @available(*, deprecated, message: "콘텐츠 클로저가 any View를 돌려주지 않게 바꾸고 init(content:)를 쓰세요.")
    public init(@ViewBuilder content: @escaping () -> any View) {
        self.content = AnyView(content())
    }

    private static func legacyOffsetHandler(_ onOffsetChanged: @escaping (CGPoint) -> Void) -> OffsetChangeHandler {
        // 이전 구현은 `onPreferenceChange`라 처음 나타날 때도 한 번 불렸다. 첫 로드를 여기에 건 사용처가 있어 맞춘다.
        OffsetChangeHandler(for: CGPoint.self, firesOnAppear: true, transform: { $0 }, action: { _, newValue in
            onOffsetChanged(newValue)
        })
    }

    // MARK: - Body

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        // 스크롤마다 바뀌는 값은 ``ScrollTracker``만 읽는다. 여기서 읽으면 스크롤 틱마다
        // 이 `body`와 콘텐츠가 통째로 다시 평가된다.
        SwiftUI.ScrollView(axisSet, showsIndicators: !hidesIndicators) {
            VStack {
                content
            }
            .modifying { view in
                if #available(iOS 18, *) {
                    view
                } else {
                    view.background(alignment: .topLeading) {
                        GeometryReader { proxy in
                            SwiftUI.Color.clear
                                .preference(key: OffsetPreferenceKey.self, value: proxy.frame(in: .named(Self.coordinateSpaceName)).origin)
                                .preference(key: ContentSizePreferenceKey.self, value: proxy.size)
                        }
                    }
                }
            }
        }
        .modifier(
            ScrollTracker(
                axis: axis,
                offsetHandlers: offsetHandlers,
                geometrySink: geometrySink,
                legacyScrollStatus: legacyScrollStatus,
                onRefresh: onRefresh
            )
        )
    }

    // MARK: - Modifiers

    private var axis: Axis = .vertical
    private var hidesIndicators = false
    private var onRefresh: (() async -> Void)?
    private var offsetHandlers: [OffsetChangeHandler] = []

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

    /// 스크롤 오프셋에서 뽑은 값이 바뀔 때 동작을 실행합니다.
    ///
    /// `transform`은 스크롤할 때마다 불리지만 `action`은 그 결과가 달라질 때만 불립니다.
    /// 필요한 만큼으로 값을 줄일수록 `action`이 덜 불리고, 그 안에서 바꾼 상태 때문에 다시 그려지는 일도 줄어듭니다.
    ///
    /// ```swift
    /// ScrollView {
    ///     content
    /// }
    /// .onScrollOffsetChange(for: Bool.self) { offset in
    ///     offset.y < 0
    /// } action: { _, isScrolled in
    ///     showsDivider = isScrolled
    /// }
    /// ```
    ///
    /// `transform`이 바깥 값을 쓰면 그 값만 바뀌어도 결과가 달라질 수 있습니다. 이때도 `action`이 불립니다.
    /// `action`은 직전 렌더에서 만든 클로저가 불리므로, 상태는 `@State`·`@Binding`으로 바꾸고
    /// 부모가 넘긴 `let` 값은 캡처하지 마세요.
    /// 여러 번 붙이면 붙인 순서대로 각각 동작합니다.
    ///
    /// - Parameters:
    ///   - type: `transform`이 돌려주는 값의 타입
    ///   - transform: 콘텐츠 오프셋을 받아 지켜볼 값으로 바꾸는 클로저. 오프셋은 최상단에서 `0`이고 스크롤할수록 음수가 됩니다
    ///   - action: 지켜보는 값이 바뀔 때 이전 값과 새 값을 받아 실행할 클로저
    /// - Returns: 수정된 스크롤 뷰
    ///
    /// - Note: 처음 그려질 때는 `action`이 불리지 않습니다. 상태의 초깃값은 오프셋이 `.zero`일 때의 결과에 맞춰 두세요.
    public func onScrollOffsetChange<T: Equatable>(
        for type: T.Type,
        transform: @escaping (_ offset: CGPoint) -> T,
        action: @escaping (_ oldValue: T, _ newValue: T) -> Void
    ) -> Self {
        var zelf = self
        zelf.offsetHandlers.append(OffsetChangeHandler(for: type, transform: transform, action: action))
        return zelf
    }

    // MARK: - Types

    /// 스크롤 뷰의 상태를 추적하는 구조체입니다.
    ///
    /// 스크롤 방향, 스크롤 뷰 크기, 콘텐츠 크기, 오프셋 등의 정보를 포함합니다.
    ///
    /// - Note: deprecated된 ``init(scrollStatus:onOffsetChanged:content:)``에서만 쓰입니다.
    ///   새 코드는 ``Geometry``를 쓰세요.
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
            Metrics(axis: axis, contentOffset: contentOffset, scrollViewSize: scrollViewSize, contentSize: contentSize)
                .reachedEnd
        }
    }

    /// 스크롤 뷰의 상태를 담는 관찰 가능한 객체입니다.
    ///
    /// ``ScrollView/init(geometry:content:)``에 넘기면 스크롤 뷰가 값을 채웁니다.
    /// 값이 바뀐 속성만 알리므로, 그 속성을 읽은 뷰만 다시 그려집니다.
    ///
    /// ```swift
    /// @State private var scrollGeometry = ScrollView.Geometry()
    /// ```
    @available(iOS 17, *)
    @Observable
    public final class Geometry {
        /// 스크롤 방향
        public internal(set) var axis: Axis = .vertical
        /// 스크롤 뷰 크기
        public internal(set) var scrollViewSize: CGSize = .zero
        /// 콘텐츠 크기
        public internal(set) var contentSize: CGSize = .zero
        /// 콘텐츠 오프셋. 최상단에서 `0`이고 스크롤할수록 음수가 됩니다
        public internal(set) var contentOffset: CGPoint = .zero

        /// 스크롤 상태를 초기화합니다.
        public init() {}

        /// 스크롤이 끝(세로는 바닥, 가로는 오른쪽 끝)에 도달했는지 여부입니다.
        public var reachedEnd: Bool {
            Metrics(axis: axis, contentOffset: contentOffset, scrollViewSize: scrollViewSize, contentSize: contentSize)
                .reachedEnd
        }

        /// 바뀐 값만 써서 읽지 않은 속성 때문에 뷰가 다시 그려지지 않게 한다.
        func update(_ metrics: Metrics) {
            if axis != metrics.axis { axis = metrics.axis }
            if scrollViewSize != metrics.scrollViewSize { scrollViewSize = metrics.scrollViewSize }
            if contentSize != metrics.contentSize { contentSize = metrics.contentSize }
            if contentOffset != metrics.contentOffset { contentOffset = metrics.contentOffset }
        }
    }
}

// MARK: - Tracking

extension ScrollView {
    static let coordinateSpaceName = "ScrollViewOrigin"

    /// 스크롤 뷰가 재는 값 묶음입니다.
    struct Metrics: Equatable {
        var axis: Axis = .vertical
        var contentOffset: CGPoint = .zero
        var scrollViewSize: CGSize = .zero
        var contentSize: CGSize = .zero

        init(
            axis: Axis = .vertical,
            contentOffset: CGPoint = .zero,
            scrollViewSize: CGSize = .zero,
            contentSize: CGSize = .zero
        ) {
            self.axis = axis
            self.contentOffset = contentOffset
            self.scrollViewSize = scrollViewSize
            self.contentSize = contentSize
        }

        var reachedEnd: Bool {
            // FloatingPoint 오류를 보정하기 위해 0.1을 빼줍니다.
            if axis == .vertical {
                contentOffset.y - 0.1 <= scrollViewSize.height - contentSize.height
            } else {
                contentOffset.x - 0.1 <= scrollViewSize.width - contentSize.width
            }
        }
    }

    /// ``ScrollView/onScrollOffsetChange(for:transform:action:)``로 받은 클로저를 타입을 지워 담는다.
    ///
    /// `ScrollView`가 제네릭이 아니라 `T`를 그대로 들 수 없다.
    struct OffsetChangeHandler {
        let firesOnAppear: Bool
        let value: (CGPoint) -> AnyEquatable
        let fire: (_ oldValue: AnyEquatable, _ newValue: AnyEquatable) -> Void

        init<T: Equatable>(
            for _: T.Type,
            firesOnAppear: Bool = false,
            transform: @escaping (CGPoint) -> T,
            action: @escaping (T, T) -> Void
        ) {
            self.firesOnAppear = firesOnAppear
            value = { AnyEquatable(transform($0)) }
            fire = { oldValue, newValue in
                guard let oldValue = oldValue.base as? T, let newValue = newValue.base as? T else { return }
                action(oldValue, newValue)
            }
        }
    }

    struct AnyEquatable: Equatable {
        let base: Any
        private let isEqual: (Any) -> Bool

        init<T: Equatable>(_ base: T) {
            self.base = base
            isEqual = { ($0 as? T) == base }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.isEqual(rhs.base)
        }
    }
}

/// 스크롤 위치를 재고 바깥에 알리는 일을 ``ScrollView``의 `body`에서 떼어 낸 수정자입니다.
///
/// 스크롤 틱마다 다시 평가되는 건 이 수정자의 `body`뿐이고, 감싼 스크롤 뷰와 콘텐츠는 다시 평가되지 않는다.
private struct ScrollTracker: ViewModifier {
    let axis: Axis
    let offsetHandlers: [ScrollView.OffsetChangeHandler]
    let geometrySink: ((ScrollView.Metrics) -> Void)?
    let legacyScrollStatus: Binding<ScrollView.ScrollStatus>?
    let onRefresh: (() async -> Void)?

    @State private var metrics = ScrollView.Metrics()

    func body(content: Content) -> some View {
        let handlerValues = offsetHandlers.map { $0.value(metrics.contentOffset) }

        content
            .modifying { view in
                if #available(iOS 18, *) {
                    view.onScrollGeometryChange(for: ScrollView.Metrics.self) { geometry in
                        // iOS 18 미만 경로(콘텐츠 원점을 스크롤 뷰 좌표로 잰 값)와 같은 기준으로 맞춘다.
                        // `contentOffset`은 최상단에서 `-인셋`이므로 인셋을 더해 0에서 시작하게 한다.
                        ScrollView.Metrics(
                            axis: axis,
                            contentOffset: CGPoint(
                                x: -(geometry.contentOffset.x + geometry.contentInsets.leading),
                                y: -(geometry.contentOffset.y + geometry.contentInsets.top)
                            ),
                            scrollViewSize: geometry.containerSize,
                            contentSize: geometry.contentSize
                        )
                    } action: { _, newValue in
                        metrics = newValue
                    }
                } else {
                    view
                        .background {
                            GeometryReader { proxy in
                                SwiftUI.Color.clear.preference(key: ScrollViewSizePreferenceKey.self, value: proxy.size)
                            }
                        }
                        .coordinateSpace(name: ScrollView.coordinateSpaceName)
                        .onPreferenceChange(OffsetPreferenceKey.self) { metrics.contentOffset = $0 }
                        .onPreferenceChange(ContentSizePreferenceKey.self) { metrics.contentSize = $0 }
                        .onPreferenceChange(ScrollViewSizePreferenceKey.self) { metrics.scrollViewSize = $0 }
                        // 바깥의 다른 ScrollView가 이 값을 자기 것으로 읽지 않게 여기서 끊는다.
                        .transformPreference(OffsetPreferenceKey.self) { $0 = OffsetPreferenceKey.defaultValue }
                        .transformPreference(ContentSizePreferenceKey.self) { $0 = ContentSizePreferenceKey.defaultValue }
                        .transformPreference(ScrollViewSizePreferenceKey.self) { $0 = ScrollViewSizePreferenceKey.defaultValue }
                        .onAppear { metrics.axis = axis }
                        .onChange(of: axis) { metrics.axis = $0 }
                }
            }
            .onChange(of: metrics) { newValue in
                geometrySink?(newValue)
                legacyScrollStatus?.wrappedValue = ScrollView.ScrollStatus(
                    axis: newValue.axis,
                    scrollViewSize: newValue.scrollViewSize,
                    contentSize: newValue.contentSize,
                    contentOffset: newValue.contentOffset
                )
            }
            .onAppear {
                for handler in offsetHandlers where handler.firesOnAppear {
                    let value = handler.value(metrics.contentOffset)
                    handler.fire(value, value)
                }
            }
            // 이전 값은 직전 렌더에서 캡처한 배열로 얻는다. 그래서 `action`도 직전 렌더의 클로저가 불린다.
            .onChange(of: handlerValues) { [handlerValues] newValues in
                for (handler, (oldValue, newValue)) in zip(offsetHandlers, zip(handlerValues, newValues)) where oldValue != newValue {
                    handler.fire(oldValue, newValue)
                }
            }
            // 하단 도달 여부를 위로 올려 ``ActionArea``가 그라데이션 표시를 스스로 정하게 한다.
            // 가로 스크롤(캐러셀 등)은 하단이라는 개념이 없어 신호를 내지 않는다.
            .preference(
                key: ScrollReachedEndPreferenceKey.self,
                value: axis == .vertical ? metrics.reachedEnd : nil
            )
            // 세로 오프셋도 함께 올려 ``ScreenScaffold``의 ``TopNavigation``이 배경 농도를 정하게 한다.
            .preference(
                key: ScrollOffsetPreferenceKey.self,
                value: axis == .vertical ? ScrollOffsetPreferenceKey.clamped(metrics.contentOffset.y) : nil
            )
            .if(onRefresh != nil) {
                if #available(iOS 18, *) {
                    $0.pullToRefresh(scrollYOffset: $metrics.contentOffset.y) {
                        await onRefresh?()
                    }
                } else {
                    $0.refreshable {
                        await onRefresh?()
                    }
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
}

struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {}
}

struct ScrollViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
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
                        ScrollOffsetPreferenceKey.clamped(-(geometry.contentOffset.y + geometry.contentInsets.top))
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

    /// ``TopNavigation``이 배경 농도를 정하는 데 쓰는 구간만 남긴다.
    ///
    /// 배경은 0에서 상단 safe area 높이(없으면 32)만큼 내려가는 사이에만 바뀐다. 그 밖의 값까지 올리면
    /// 스크롤 틱마다 스캐폴드가 다시 그려지므로, 가장 긴 safe area보다 넉넉한 거리에서 잘라 낸다.
    static func clamped(_ offset: CGFloat) -> CGFloat {
        min(0, max(-maxReportedDistance, offset))
    }

    private static let maxReportedDistance: CGFloat = 120
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
