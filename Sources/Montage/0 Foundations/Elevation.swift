//
//  Elevation.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/16.
//

import UIKit
import SwiftUI

/// 높낮이의 차이를 표현하기 위한 그림자 효과
///
/// Elevation은 UI 요소의 시각적 깊이와 높이를 표현하기 위한 
/// 그림자 효과를 정의합니다. 여러 단계의 그림자를 통해 
/// 요소 간의 계층 구조와 중요도를 시각적으로 나타냅니다.
///
/// ```swift
/// // UIKit에서 사용
/// let cardView = UIView()
/// cardView.setElevation(.shadowNormal)
///
/// // SwiftUI에서 사용
/// Text("Hello, World!")
///     .elevation(.shadowEmphasize)
/// ```
///
/// - Note: `UIView.setElevation(_:)`을 사용하여 레이어에 그림자를 적용할 수 있습니다.
/// 중첩된 뷰에 그림자를 적용할 경우 성능에 영향을 줄 수 있으므로 주의해야 합니다.
public enum Elevation: Equatable {
    /// 그림자 없음
    case none
    /// 일반적인 수준의 그림자
    case shadowNormal
    /// 강조된 수준의 그림자
    case shadowEmphasize
    /// 강한 수준의 그림자
    case shadowStrong
    /// 가장 강한 수준의 그림자
    case shadowHeavy
}

extension Elevation {
    struct Descriptor {
        let offset: CGSize
        let blur: CGFloat
        let color: UIColor?
        let alpha: CGFloat
    }

    var descriptor: Descriptor {
        let shadowColor = UIColor.semantic(.staticBlack)

        switch self {
        case .none:
            return .init(offset: .init(width: 0, height: -3), blur: 0, color: nil, alpha: 0)
        case .shadowNormal:
            return .init(offset: .init(width: 0, height: 1), blur: 2, color: shadowColor, alpha: 0.16)
        case .shadowEmphasize:
            return .init(offset: .init(width: 0, height: 2), blur: 8, color: shadowColor, alpha: 0.16)
        case .shadowStrong:
            return .init(offset: .init(width: 0, height: 4), blur: 12, color: shadowColor, alpha: 0.22)
        case .shadowHeavy:
            return .init(offset: .init(width: 0, height: 8), blur: 24, color: shadowColor, alpha: 0.28)
        }
    }
}

// MARK: - UIKit View Extensions
public extension UIView {
    /// Montage 디자인 시스템의 그림자 효과를 적용합니다.
    ///
    /// - Parameter elevation: 적용할 그림자 효과. nil인 경우 그림자가 제거됩니다.
    func setElevation(_ elevation: Elevation?) {
        let elevation = elevation ?? .none
        let descriptor = elevation.descriptor

        if let color = descriptor.color {
            layer.shadowColor = color.withAlphaComponent(descriptor.alpha).cgColor
        } else {
            layer.shadowColor = nil
        }

        layer.shadowRadius = descriptor.blur
        layer.shadowOffset = descriptor.offset
        layer.shadowOpacity = elevation == .none ? 0 : 1
    }
}

// MARK: - SwiftUI View Extensions
public extension View {
    /// Montage 디자인 시스템의 그림자 효과를 적용합니다.
    ///
    /// - Parameter elevation: 적용할 그림자 효과
    /// - Returns: 그림자 효과가 적용된 View
    func elevation(_ elevation: Elevation) -> Self {
        let currentView = self

        guard elevation != .none else {
            return currentView
        }

        let descriptor = elevation.descriptor

        guard let color = descriptor.color else {
            return currentView
        }

        let _ = currentView.shadow(
            color: SwiftUI.Color(color.withAlphaComponent(descriptor.alpha)),
            radius: descriptor.blur,
            x: descriptor.offset.width,
            y: descriptor.offset.height
        )

        return currentView
    }
}
