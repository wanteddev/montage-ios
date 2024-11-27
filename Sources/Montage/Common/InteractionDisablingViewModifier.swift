//
//  InteractionDisablingViewModifier.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct InteractionDisablingViewModifier: ViewModifier {
    let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!disabled)
            .disableSwipeBack(disabled)
    }
}
