//
//  GradientScrollEdgeModifier.swift
//  Montage
//
//  Created by 김삼열 on 2/4/25.
//

import SwiftUI

struct GradientScrollEdgeModifier: ViewModifier {
    private let gradientColors: [SwiftUI.Color]
    private let gradientWidth: CGFloat
    private let gradientInsets: EdgeInsets
    private let leadingGradientDisabled: Bool
    private let trailingGradientDisabled: Bool

    init(
        gradientColors: [SwiftUI.Color]? = nil,
        gradientWidth: CGFloat,
        gradientInsets: EdgeInsets = .init(),
        leadingGradientDisabled: Bool = false,
        trailingGradientDisabled: Bool = false
    ) {
        self.gradientColors =
            gradientColors
            ?? [
                1.0,
                0.86,
                0.73,
                0.62,
                0.52,
                0.43,
                0.35,
                0.29,
                0.23,
                0.18,
                0.14,
                0.1,
                0.07,
                0.04,
                0.02,
                0.0,
            ]
            .map { SwiftUI.Color.black.opacity($0) }
        self.gradientWidth = gradientWidth
        self.gradientInsets = gradientInsets
        self.leadingGradientDisabled = leadingGradientDisabled
        self.trailingGradientDisabled = trailingGradientDisabled
    }

    @State private var contentOffset: CGPoint = .zero
    @State private var contentWidth: CGFloat = .zero
    @State private var scrollViewWidth: CGFloat = .zero
    @State private var needsLeadingGradient = false
    @State private var needsTrailingGradient = false

    private let animation: Animation = .timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)

    func body(content: Content) -> some View {
        content
            .onGeometryChange(
                for: CGSize.self,
                of: { $0.size },
                action: { contentWidth = $0.width }
            )
            .modifier(AutoScrollModifier(axis: .horizontal, contentOffset: $contentOffset))
            .onGeometryChange(
                for: CGSize.self,
                of: { $0.size },
                action: { scrollViewWidth = $0.width }
            )
            .mask {
                gradientEdge()
                    .padding(gradientInsets)
                    .frame(width: scrollViewWidth)
            }
            .onChange(of: contentOffset) { _ in
                withAnimation(animation) {
                    setNeedsGradientIfNeeded()
                }
            }
            .onChange(of: contentWidth) { _ in
                setNeedsGradientIfNeeded()
            }
    }

    private func gradientEdge() -> some View {
        HStack(spacing: 0) {
            Group {
                if needsLeadingGradient {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .init(x: 1, y: 0),
                        endPoint: .init(x: 0, y: 0)
                    )
                } else {
                    Rectangle()
                }
            }
            .frame(width: gradientWidth)

            Rectangle()
                .frame(maxWidth: .infinity)

            Group {
                if needsTrailingGradient {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .init(x: 0, y: 0),
                        endPoint: .init(x: 1, y: 0)
                    )
                } else {
                    Rectangle()
                }
            }
            .frame(width: gradientWidth)
        }
        .allowsHitTesting(false)
    }

    private func setNeedsGradientIfNeeded() {
        // FloatingPoint 오차로 인해 오른쪽 끝까지 스크롤했을 때 그래디언트가 나타나는
        // 현상이 있어서 소수 아래 절삭한 상태로 비교함
        if Int(-contentOffset.x) + Int(scrollViewWidth) < Int(contentWidth) {
            needsTrailingGradient = true
        } else {
            needsTrailingGradient = false
        }

        if contentOffset.x < 0 {
            needsLeadingGradient = true
        } else {
            needsLeadingGradient = false
        }

        if leadingGradientDisabled {
            needsLeadingGradient = false
        }
        if trailingGradientDisabled {
            needsTrailingGradient = false
        }
    }
}
