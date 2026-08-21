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
    ///     ForEach(items) { row($0) }
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
    /// - Important: 스크롤 기하를 읽는 `onScrollGeometryChange`가 iOS 18부터라 이 수정자도
    ///   iOS 18 이상에서만 쓸 수 있습니다. 그 아래 버전에서도 그라데이션이 필요하면 호출부가
    ///   직접 잰 값을 ``ActionArea/scrollReachedEnd(_:)``나 `actionArea(scrollReachedEnd:_:)`로
    ///   넘기세요.
    @available(iOS 18, *)
    func reportsScrollReachedEnd(_ isEnabled: Bool = true) -> some View {
        modifier(ScrollReachedEndReporter(isEnabled: isEnabled))
    }
}

/// 스크롤 기하를 읽어 하단 도달 여부를 preference로 올리는 수정자입니다.
@available(iOS 18, *)
private struct ScrollReachedEndReporter: ViewModifier {
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
            .preference(key: ScrollReachedEndPreferenceKey.self, value: reachedEnd)
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
