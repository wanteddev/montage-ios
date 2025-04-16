//
//  ScrollView.swift
//  Montage
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI

public struct ScrollView: View {
    // MARK: - Initializer
    private var externalScrollStatus: Binding<ScrollStatus>?
    private let onOffsetChanged: (CGPoint) -> Void
    private let content: () -> any View

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
                }
                .onGeometryChange(for: CGSize.self, of: { $0.size }, for: .milliseconds(100), action: {
                    scrollStatus.wrappedValue.contentSize = $0
                })
            }
        }
        .onGeometryChange(for: CGSize.self, of: { $0.size }, for: .milliseconds(100), action: {
            scrollStatus.wrappedValue.scrollViewSize = $0
        })
        .coordinateSpace(name: "ScrollViewOrigin")
        .onChange(of: axis) {
            scrollStatus.wrappedValue.axis = $0
        }
        .onPreferenceChange(OffsetPreferenceKey.self) {
            scrollStatus.wrappedValue.contentOffset = $0
            onOffsetChanged($0)
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

    public func axis(_ axis: Axis) -> Self {
        var zelf = self
        zelf.axis = axis
        return zelf
    }

    public func hidesIndicators(_ hidesIndicators: Bool = true) -> Self {
        var zelf = self
        zelf.hidesIndicators = hidesIndicators
        return zelf
    }

    public func onRefresh(_ perform: @escaping () async -> Void) -> Self {
        var zelf = self
        zelf.onRefresh = perform
        return zelf
    }

    // MARK: - Types

    public struct ScrollStatus: Equatable {
        public var axis: Axis
        public var scrollViewSize: CGSize
        public var contentSize: CGSize
        public var contentOffset: CGPoint

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
