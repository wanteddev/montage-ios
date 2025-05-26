//
//  ProgressIndicator.swift
//  Montage
//
//  Created by 김삼열 on 11/19/24.
//

import SwiftUI

/// 진행 상태를 시각적으로 표시하는 인디케이터 뷰
///
/// 주어진 퍼센트에 따라 진행 상태를 막대 형태로 표시합니다.
/// 왼쪽에서 오른쪽으로 채워지는 형태로 진행 상태를 시각화합니다.
///
/// ```swift
/// @State private var progress: CGFloat = 0.5
/// 
/// ProgressIndicator(percentage: $progress)
/// ```
///
/// - Parameters:
///   - percentage: 진행 상태를 나타내는 값 (0.0 ~ 1.0 사이의 값)
public struct ProgressIndicator: View {
    @Binding private var percentage: CGFloat

    /// 진행 상태 인디케이터를 초기화합니다.
    ///
    /// - Parameters:
    ///   - percentage: 진행 상태를 나타내는 바인딩 값 (0.0 ~ 1.0 사이의 값)
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
