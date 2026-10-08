//
//  ListCellInteractionModifier.swift
//  Montage
//
//  Created by 김삼열 on 1/3/25.
//

import SwiftUI

struct ListCellInteractionModifier: ViewModifier {
    @Binding private var pressed: Bool
    /// 인터랙션 배경이 콘텐츠 경계 바깥으로 확장되는 좌우 크기.
    private let outset: CGFloat
    /// 인터랙션 배경의 모서리 반경. `outset`과 독립적으로 지정한다.
    private let radius: CGFloat

    init(pressed: Binding<Bool>, outset: CGFloat, radius: CGFloat) {
        _pressed = pressed
        self.outset = outset
        self.radius = radius
    }

    @State private var labelSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { labelSize = $0 })
            .background(
                Interaction(
                    state: pressed ? .pressed : .normal,
                    variant: .light,
                    color: .foregroundNeutralPrimary
                )
                .frame(
                    width: labelSize.width + outset * 2,
                    height: labelSize.height
                )
                .clipShape(RoundedRectangle(cornerRadius: radius))
            )
    }
}
