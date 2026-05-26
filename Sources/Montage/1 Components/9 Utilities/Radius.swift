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
public enum Radius {}

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
