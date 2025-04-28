//
//  UserInteractionDisablingModifier.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct UserInteractionDisablingModifier: ViewModifier {
    let disabled: Bool

    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!disabled)
            .disableSwipeBack(disabled)
    }
}

// MARK: - View Extension

extension View {
    /// 사용자 상호작용을 비활성화하는 modifier를 적용합니다.
    ///
    /// 뷰의 터치 이벤트와 스와이프 백 제스처를 비활성화합니다.
    ///
    /// - Parameters:
    ///   - disabled: 상호작용 비활성화 여부
    /// - Returns: 사용자 상호작용이 비활성화된 뷰
    public func userInteractionDisabled(_ disabled: Bool) -> some View {
        ZStack {
            modifier(UserInteractionDisablingModifier(disabled: disabled))
        }
    }
}
