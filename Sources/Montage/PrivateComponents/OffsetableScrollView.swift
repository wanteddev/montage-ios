//
//  OffsettableScrollView.swift
//  Montage
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI

struct OffsettableScrollView<T: View>: View {
    // MARK: - Initializer
    private let onOffsetChanged: (CGPoint) -> Void
    private let content: () -> T

    init(
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> T
    ) {
        self.onOffsetChanged = onOffsetChanged
        self.content = content
    }

    // MARK: - Body
    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    SwiftUI.Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(in: .named("ScrollViewOrigin")).origin
                    )
                }
                .frame(width: 0, height: 0)
                content()
            }
        }
        .coordinateSpace(name: "ScrollViewOrigin")
        .onPreferenceChange(
            OffsetPreferenceKey.self,
            perform: onOffsetChanged
        )
    }

    // MARK: - Modifiers
    private var axis: Axis.Set = .vertical
    private var showsIndicators = true
    private var onRefresh: (() -> Void)?

    func axis(_ axis: Axis.Set) -> Self {
        var zelf = self
        zelf.axis = axis
        return zelf
    }

    func showIndicators(_ showsIndicators: Bool = true) -> Self {
        var zelf = self
        zelf.showsIndicators = showsIndicators
        return zelf
    }
}
