//
//  Radius.swift
//  Montage
//

import Foundation
import UIKit

/// 모서리 반경(corner radius)을 정의하는 시스템
///
/// Radius는 컴포넌트의 둥근 모서리 반경을 일관되게 적용하기 위한 토큰입니다.
///
/// ```swift
/// // SwiftUI
/// RoundedRectangle(cornerRadius: .radius12)
///
/// // UIKit
/// view.layer.cornerRadius = .radius12
/// ```
///
/// - Note: 실제 값은 `CGFloat.radius{N}` 정적 프로퍼티로 노출됩니다.
/// 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.
public enum Radius {
    /// 정의된 모든 radius 토큰 값(오름차순).
    ///
    /// 컴포넌트가 토큰에 스냅하거나 최대/최소 토큰을 동적으로 도출할 때 사용한다.
    /// 토큰이 추가/삭제되면 이 배열만 갱신하면 사용처가 자동으로 반영된다.
    public static let allValues: [CGFloat] = [
        .radius0, .radius4, .radius8, .radius10, .radius12, .radius14,
        .radius16, .radius20, .radius24
    ]

    /// 정의된 radius 토큰 중 최소값.
    public static var min: CGFloat { allValues.first ?? 0 }

    /// 정의된 radius 토큰 중 최대값. `full`(pill)은 포함되지 않는다.
    public static var max: CGFloat { allValues.last ?? 0 }
}

public extension CGFloat {
    /// 0pt의 모서리 반경 (직각 모서리)
    static let radius0: CGFloat = .primitive0
    /// 4pt의 모서리 반경
    static let radius4: CGFloat = .primitive4
    /// 8pt의 모서리 반경
    static let radius8: CGFloat = .primitive8
    /// 10pt의 모서리 반경
    static let radius10: CGFloat = .primitive10
    /// 12pt의 모서리 반경
    static let radius12: CGFloat = .primitive12
    /// 14pt의 모서리 반경
    static let radius14: CGFloat = .primitive14
    /// 16pt의 모서리 반경
    static let radius16: CGFloat = .primitive16
    /// 20pt의 모서리 반경
    static let radius20: CGFloat = .primitive20
    /// 24pt의 모서리 반경
    static let radius24: CGFloat = .primitive24
}
