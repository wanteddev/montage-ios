//
//  AutoScrollModifier.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct AutoScrollModifier: ViewModifier {
    private let axis: Axis.Set
    @Binding private var contentOffset: CGPoint
    
    init(axis: Axis.Set, contentOffset: Binding<CGPoint>) {
        self.axis = axis
        _contentOffset = contentOffset
    }
    
    @State private var scrollNotNeeded = false
    @State private var contentSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        OffsettableScrollView {
            contentOffset = $0
        } content: {
            contentView(content)
        }
        .axis(axis)
        .showIndicators(false)
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
        default:
            true
        }
    }
    
    // MARK: - private
    
    private func contentView(_ content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
    }
}
