//
//  AutoScrollModifier.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct AutoScrollModifier: ViewModifier {
    private let axis: Axis
    @Binding private var contentOffset: CGPoint
    
    init(axis: Axis, contentOffset: Binding<CGPoint>) {
        self.axis = axis
        _contentOffset = contentOffset
    }
    
    @State private var scrollNotNeeded = false
    @State private var contentSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        ScrollView {
            contentOffset = $0
        } content: {
            contentView(content)
        }
        .axis(axis)
        .hidesIndicators()
        .scrollDisabled(scrollNotNeeded)
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { scrollViewSize = $0 })
        .onChange(of: contentSize) { _ in
            updateWhetherScrollable()
        }
        .onChange(of: scrollViewSize) { _ in
            updateWhetherScrollable()
        }
    }
    
    func updateWhetherScrollable() {
        scrollNotNeeded = switch axis {
        case .horizontal:
            contentSize.width <= scrollViewSize.width
        case .vertical:
            contentSize.height <= scrollViewSize.height
        }
    }
    
    // MARK: - private
    
    private func contentView(_ content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
    }
}

// MARK: - View Extension

extension View {
    /// 뷰에 자동 스크롤 기능을 적용하는 modifier입니다.
    ///
    /// 콘텐츠 오프셋을 추적하고 스크롤이 필요한 경우에만 스크롤을 활성화합니다.
    /// 콘텐츠가 스크롤 뷰보다 작은 경우 스크롤이 비활성화됩니다.
    ///
    /// - Parameters:
    ///   - axis: 스크롤 방향 (.horizontal 또는 .vertical)
    ///   - contentOffset: 콘텐츠 오프셋을 바인딩하는 CGPoint 값
    /// - Returns: 자동 스크롤 기능이 적용된 뷰
    public func scrollable(_ axis: Axis, contentOffset: Binding<CGPoint>) -> some View {
        modifier(AutoScrollModifier(axis: axis, contentOffset: contentOffset))
    }
}
