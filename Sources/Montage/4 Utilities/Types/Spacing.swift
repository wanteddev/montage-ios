//
//  Spacing.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/23.
//

import Foundation
import UIKit

/// UI 요소 간의 간격을 정의하는 시스템
///
/// Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된 
/// 간격을 제공하기 위한 규격화된 값들을 정의합니다. 
/// 모든 간격은 4포인트 기반의 스케일로 구성되어 있어 디자인의 
/// 일관성과 조화를 유지합니다.
///
/// **사용 예시**:
/// ```swift
/// // UIKit에서 사용
/// let padding = CGFloat.spacing(.pt16)
/// view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
///
/// // SwiftUI에서 사용
/// Text("Hello, World!")
///     .padding(.horizontal, .spacing(.pt24))
///     .padding(.vertical, .spacing(.pt16))
/// ```
///
/// - Note: 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다.
/// 예를 들어 pt16은 16포인트의 간격을 의미합니다.
public enum Spacing {
    /// 1포인트 간격
    case pt01
    /// 2포인트 간격
    case pt02
    /// 4포인트 간격
    case pt04
    /// 8포인트 간격
    case pt08
    /// 12포인트 간격
    case pt12
    /// 16포인트 간격 (기본 간격)
    case pt16
    /// 20포인트 간격
    case pt20
    /// 24포인트 간격
    case pt24
    /// 28포인트 간격
    case pt28
    /// 32포인트 간격
    case pt32
    /// 36포인트 간격
    case pt36
    /// 40포인트 간격
    case pt40
    /// 48포인트 간격
    case pt48
    /// 56포인트 간격
    case pt56
    /// 64포인트 간격
    case pt64
    /// 72포인트 간격
    case pt72
    /// 80포인트 간격
    case pt80
}

public extension CGFloat {
    /// Spacing 열거형 값에 해당하는 CGFloat 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// let padding = CGFloat.spacing(.pt16) // 16.0
    /// ```
    ///
    /// - Parameter spacingComponent: 사용할 간격 열거형 값
    /// - Returns: 지정된 간격에 해당하는 CGFloat 값
    static func spacing(_ spacingComponent: Spacing) -> CGFloat {
        switch spacingComponent {
        case .pt01:
            1
        case .pt02:
            2
        case .pt04:
            4
        case .pt08:
            8
        case .pt12:
            12
        case .pt16:
            16
        case .pt20:
            20
        case .pt24:
            24
        case .pt28:
            28
        case .pt32:
            32
        case .pt36:
            36
        case .pt40:
            40
        case .pt48:
            48
        case .pt56:
            56
        case .pt64:
            64
        case .pt72:
            72
        case .pt80:
            80
        }
    }
}

public extension Float {
    /// Spacing 열거형 값에 해당하는 Float 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// let padding = Float.spacing(.pt16) // 16.0
    /// ```
    ///
    /// - Parameter spacingComponent: 사용할 간격 열거형 값
    /// - Returns: 지정된 간격에 해당하는 Float 값
    static func spacing(_ spacingComponent: Spacing) -> Float {
        switch spacingComponent {
        case .pt01:
            1
        case .pt02:
            2
        case .pt04:
            4
        case .pt08:
            8
        case .pt12:
            12
        case .pt16:
            16
        case .pt20:
            20
        case .pt24:
            24
        case .pt28:
            28
        case .pt32:
            32
        case .pt36:
            36
        case .pt40:
            40
        case .pt48:
            48
        case .pt56:
            56
        case .pt64:
            64
        case .pt72:
            72
        case .pt80:
            80
        }
    }
}
