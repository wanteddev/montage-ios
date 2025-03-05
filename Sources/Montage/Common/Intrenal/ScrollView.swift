//
//  ScrollView.swift
//  Montage
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI

public struct ScrollView: View {
    // MARK: - Initializer
    @Binding private var scrollStatus: ScrollStatus
    private let onOffsetChanged: (CGPoint) -> Void
    private let content: () -> any View

    public init(
        scrollStatus: Binding<ScrollStatus> = .constant(.init()),
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> any View
    ) {
        self.onOffsetChanged = onOffsetChanged
        _scrollStatus = scrollStatus
        self.content = content
    }

    // MARK: - Body

    @State private var scrollViewSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var contentOffset: CGPoint = .zero

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
            }
            .onGeometryChange(for: CGSize.self, of: { $0.size }, for: .milliseconds(100), action: {
                contentSize = $0
            })
        }
        .onGeometryChange(for: CGSize.self, of: { $0.size }, for: .milliseconds(100), action: {
            scrollViewSize = $0
        })
        .coordinateSpace(name: "ScrollViewOrigin")
        .onChange(of: "\(axis)\(contentSize)\(scrollViewSize)\(contentOffset)") { _ in
            scrollStatus = .init(
                axis: axis,
                scrollViewSize: scrollViewSize,
                contentSize: contentSize,
                contentOffset: contentOffset
            )
        }
        .onPreferenceChange(OffsetPreferenceKey.self) {
            contentOffset = $0
            onOffsetChanged($0)
        }
        .if(onRefresh != nil) {
            $0.pullToRefresh(scrollYOffset: $contentOffset.y) {
                await onRefresh?()
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

    public struct ScrollStatus {
        public let axis: Axis
        public let scrollViewSize: CGSize
        public let contentSize: CGSize
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
            if axis == .vertical {
                Int(contentOffset.y) <= Int(scrollViewSize.height) - Int(contentSize.height)
            } else {
                Int(contentOffset.x) <= Int(scrollViewSize.width) - Int(contentSize.width)
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
