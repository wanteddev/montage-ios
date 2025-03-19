//
//  ProgressIndicator.swift
//  Montage
//
//  Created by 김삼열 on 11/19/24.
//

import SwiftUI

public struct ProgressIndicator: View {
    @Binding private var percentage: CGFloat

    public init(percentage: Binding<CGFloat>) {
        _percentage = percentage
    }

    @State private var size: CGSize = .zero

    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(SwiftUI.Color.semantic(.fillNormal))
            Rectangle()
                .foregroundStyle(SwiftUI.Color.semantic(.primaryNormal))
                .frame(width: size.width * percentage, height: 2)
        }
        .frame(height: 2)
        .frame(maxWidth: .infinity)
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
    }
}
