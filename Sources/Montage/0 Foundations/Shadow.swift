//
//  Shadow.swift
//  Views
//
//  Created by 김삼열 on 8/21/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

/// 그림자의 강도를 정의하는 열거형입니다.
///
/// 각 레벨은 키 그림자와 앰비언트 그림자의 조합으로 구성되어 있으며,
/// 레벨이 높을수록 더 강하고 넓은 그림자가 적용됩니다.
public enum ShadowLevel: CaseIterable {
    /// 그림자 없음
    case none
    /// 매우 작은 그림자
    case xsmall
    /// 작은 그림자
    case small
    /// 중간 크기 그림자
    case medium
    /// 큰 그림자
    case large
    /// 매우 큰 그림자
    case xlarge
}

// MARK: - ViewModifier

/// 뷰에 그림자 효과를 적용하기 위한 뷰 모디파이어입니다.
///
/// 지정된 레벨에 따라 키 그림자와 앰비언트 그림자를 조합하여 적용합니다.
/// 각 레벨마다 다른 투명도, 반경, 위치 값을 사용하여 자연스러운 그림자 효과를 만듭니다.
struct ShadowModifier: ViewModifier {
    private let level: ShadowLevel
    
    /// 그림자 모디파이어를 초기화합니다.
    ///
    /// - Parameter level: 적용할 그림자 레벨
    init(level: ShadowLevel) {
        self.level = level
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .init(red: 0.09, green: 0.09, blue: 0.09, opacity: colorOpacity(layer: .ambient)),
                radius: radius(layer: .ambient),
                x: position(layer: .ambient).x,
                y: position(layer: .ambient).y
            )
            .shadow(
                color: .init(red: 0.09, green: 0.09, blue: 0.09, opacity: colorOpacity(layer: .key)),
                radius: radius(layer: .key),
                x: position(layer: .key).x,
                y: position(layer: .key).y
            )
    }
    
    private enum Layer {
        case key
        case ambient
    }
    
    private func colorOpacity(layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 0.1
        case .small:
            return 0.06
        case .medium:
            return 0.07
        case .large:
            return 0.08
        case .xlarge:
            return layer == .ambient ? 0.1 : 0.12
        }
    }
    
    private func radius(layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 1
        case .small:
            return layer == .ambient ? 2 : 3
        case .medium:
            return layer == .ambient ? 3 : 7.5
        case .large:
            return layer == .ambient ? 5 : 12
        case .xlarge:
            return layer == .ambient ? 7.5 : 19
        }
    }
    
    private func position(layer: Layer) -> CGPoint {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return CGPoint(x: 0, y: layer == .ambient ? .zero : 1)
        case .small:
            return CGPoint(x: 0, y: layer == .ambient ? 2 : 4)
        case .medium:
            return CGPoint(x: 0, y: layer == .ambient ? 4 : 10)
        case .large:
            return CGPoint(x: 0, y: layer == .ambient ? 6 : 16)
        case .xlarge:
            return CGPoint(x: 0, y: layer == .ambient ? 10 : 24)
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 그림자를 적용합니다.
    ///
    /// 지정된 레벨의 그림자를 뷰에 적용하여 깊이감을 줍니다.
    /// 키 그림자와 앰비언트 그림자가 조합되어 자연스러운 그림자 효과를 만듭니다.
    ///
    /// - Parameter level: 적용할 그림자 레벨
    /// - Returns: 그림자가 적용된 뷰
    ///
    /// ```swift
    /// // 기본 사용법
    /// RoundedRectangle(cornerRadius: 12)
    ///     .fill(.white)
    ///     .shadow(.medium)
    ///
    /// // 버튼에 그림자 적용
    /// Button("확인") { }
    ///     .padding()
    ///     .background(.blue)
    ///     .foregroundColor(.white)
    ///     .cornerRadius(8)
    ///     .shadow(.small)
    ///
    /// // 카드에 큰 그림자 적용
    /// VStack {
    ///     Text("카드 제목")
    ///     Text("카드 내용")
    /// }
    /// .padding()
    /// .background(.white)
    /// .cornerRadius(16)
    /// .shadow(.large)
    /// ```
    public func shadow(_ level: ShadowLevel) -> some View {
        modifier(ShadowModifier(level: level))
    }
}
