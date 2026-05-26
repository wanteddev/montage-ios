//
//  Opacity.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/14.
//

import Foundation
import UIKit

/// 색상의 불투명도(alpha)를 정의하는 시스템
///
/// Montage 디자인 시스템에서 사용하는 정규화된 불투명도 값을 제공합니다.
/// 각 토큰 이름의 숫자는 백분율(%)을 의미합니다. 예: `opacity52`는 0.52(52%) 불투명도입니다.
///
/// ```swift
/// // CGFloat 값으로 사용
/// let alpha: CGFloat = .opacity52
///
/// // SwiftUI 뷰 불투명도
/// myView.opacity(.opacity88)
///
/// // 색상 알파 채널
/// UIColor.black.withAlphaComponent(.opacity43)
/// ```
///
/// - Note: `opacity0`은 완전 투명(0.0), `opacity100`은 완전 불투명(1.0)입니다.
///
/// 실제 값은 `CGFloat.opacity{N}` 정적 프로퍼티로 노출됩니다.
/// 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.
public enum Opacity {}

public extension CGFloat {
    /// 0%의 불투명도 (완전 투명)
    static let opacity0: CGFloat = 0
    /// 5%의 불투명도
    static let opacity5: CGFloat = 0.05
    /// 8%의 불투명도
    static let opacity8: CGFloat = 0.08
    /// 12%의 불투명도
    static let opacity12: CGFloat = 0.12
    /// 16%의 불투명도
    static let opacity16: CGFloat = 0.16
    /// 22%의 불투명도
    static let opacity22: CGFloat = 0.22
    /// 28%의 불투명도
    static let opacity28: CGFloat = 0.28
    /// 32%의 불투명도
    static let opacity32: CGFloat = 0.32
    /// 35%의 불투명도
    static let opacity35: CGFloat = 0.35
    /// 43%의 불투명도
    static let opacity43: CGFloat = 0.43
    /// 52%의 불투명도
    static let opacity52: CGFloat = 0.52
    /// 61%의 불투명도
    static let opacity61: CGFloat = 0.61
    /// 74%의 불투명도
    static let opacity74: CGFloat = 0.74
    /// 88%의 불투명도
    static let opacity88: CGFloat = 0.88
    /// 97%의 불투명도
    static let opacity97: CGFloat = 0.97
    /// 100%의 불투명도 (완전 불투명)
    static let opacity100: CGFloat = 1
}
