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
        self._percentage = percentage
    }
    
    @State private var size: CGSize = .zero
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(SwiftUI.Color.component(.fillNormal))
            Rectangle()
                .foregroundStyle(SwiftUI.Color.alias(.primaryNormal))
                .frame(width: size.width * percentage, height: 2)
        }
        .frame(height: 2)
        .frame(maxWidth: .infinity)
        .readSize(onChange: { size = $0 })
    }
}
