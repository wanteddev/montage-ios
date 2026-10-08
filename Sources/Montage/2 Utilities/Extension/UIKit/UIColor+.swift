//
//  UIColor+.swift
//  Montage
//
//  Created by Samuel Kim on 8/18/26.
//

import UIKit

public extension UIColor {
    /// 알파 채널만 교체한 색상을 반환합니다.
    ///
    /// ``Opacity`` 토큰은 `Double`로 정의되어 있습니다. UIKit의
    /// `withAlphaComponent(_:)`는 `CGFloat`를 받으므로, 토큰을 leading-dot 문법으로
    /// 넘기려면 `Double`을 받는 진입점이 필요합니다.
    ///
    /// ```swift
    /// UIColor.black.withAlphaComponent(.opacity43)
    /// ```
    ///
    /// - Parameter alpha: 0에서 1 사이의 불투명도
    /// - Returns: 알파 채널이 교체된 UIColor 인스턴스
    func withAlphaComponent(_ alpha: Double) -> UIColor {
        withAlphaComponent(CGFloat(alpha))
    }
}
