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
                        .background(
                            GeometryReader { proxy in
                                SwiftUI.Color.clear.preference(
                                    key: ContentSizePreferenceKey.self,
                                    value: proxy.size
                                )
                            }
                        )
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
        .onPreferenceChange(ContentSizePreferenceKey.self) {
            scrollStatus.wrappedValue.contentSize = $0
        }
        .onPreferenceChange(ScrollViewSizePreferenceKey.self) {
            scrollStatus.wrappedValue.scrollViewSize = $0
        }
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

        /// 스크롤이 최대 위치에 도달했는지 여부입니다.
        public var scrolledToMax: Bool {
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

struct ContentSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

struct ScrollViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}
