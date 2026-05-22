//
//  Dimension.swift
//  Montage
//

import Foundation
import UIKit

/// 컴포넌트의 너비/높이를 정의하는 시스템
///
/// Dimension은 아이콘, 아바타, 컨트롤 등 컴포넌트의 고정 치수(width/height)에
/// 일관된 값을 적용하기 위한 토큰입니다.
///
/// ```swift
/// // SwiftUI
/// Image(systemName: "star")
///     .frame(width: .dimension(.d24), height: .dimension(.d24))
///
/// // UIKit
/// imageView.widthAnchor.constraint(equalToConstant: .dimension(.d24)).isActive = true
/// ```
public enum Dimension {
    /// 14px
    case d14
    /// 16px
    case d16
    /// 18px
    case d18
    /// 20px
    case d20
    /// 24px
    case d24
    /// 32px
    case d32
    /// 40px
    case d40
    /// 48px
    case d48
    /// 56px
    case d56
    /// 64px
    case d64
}

extension CGFloat {
    /// Dimension 열거형 값에 해당하는 CGFloat 값을 반환합니다.
    ///
    /// - Parameter dimension: 사용할 Dimension 열거형 값
    /// - Returns: 지정된 치수에 해당하는 CGFloat 값
    public static func dimension(_ dimension: Dimension) -> CGFloat {
        switch dimension {
        case .d14: 14
        case .d16: 16
        case .d18: 18
        case .d20: 20
        case .d24: 24
        case .d32: 32
        case .d40: 40
        case .d48: 48
        case .d56: 56
        case .d64: 64
        }
    }
}

extension Float {
    /// Dimension 열거형 값에 해당하는 Float 값을 반환합니다.
    ///
    /// - Parameter dimension: 사용할 Dimension 열거형 값
    /// - Returns: 지정된 치수에 해당하는 Float 값
    public static func dimension(_ dimension: Dimension) -> Float {
        switch dimension {
        case .d14: 14
        case .d16: 16
        case .d18: 18
        case .d20: 20
        case .d24: 24
        case .d32: 32
        case .d40: 40
        case .d48: 48
        case .d56: 56
        case .d64: 64
        }
    }
}
