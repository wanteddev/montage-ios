//
//  PressActionDetectingModifier.swift
//  Views
//
//  Created by 김삼열 on 3/31/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

struct PressActionDetectingModifier: ViewModifier {
    @Binding var isPressed: Bool
    private let action: (() -> Void)?
    
    init(isPressed: Binding<Bool>, action: (() -> Void)?) {
        self._isPressed = isPressed
        self.action = action
    }
    
    func body(content: Content) -> some View {
        /// pressed 상태를 감지하는 방법을 변경할 때는 다음 사항을 테스트해야 한다.
        /// 1. 버튼의 액션이 잘 동작하는가?
        /// 2. 버튼을 빠르게 눌렀을 때 버튼의 외관이 잘 변경되는가?
        /// 3. 버튼이 스크롤뷰에 올라가 있을 때 버튼위에서 스크롤을 시작하면 스크롤이 되는가?
        /// 4. 버튼 아래에 다른 버튼이 있을 때 불필요하게 아래 버튼으로 제스처가 전달되지는 않는가?
        ///
        /// 이 기준으로 판단했을 때 simultaneousGesture를 사용하는 것이 가장 모든 조건을 완벽하게 만족하는 방법이다.
        /// 하지만 iOS 17 이하에서는 이 방법을 사용할 경우 1, 3번 조건을 만족하지 못한다.
        /// 이에 대안을 찾고자 ButtonStyle을 사용하는 방법을 사용했다. 이 방법은 2번 조건을 만족하지 못하지만
        /// 천천히 눌렀을 때는 버튼의 외관이 잘 변경되고 빠르게 눌렀을 때만 안되는 것이기에 크리티컬하지는 않다고 판단하여 이렇게 구현했다.
        
        if #available(iOS 26.0, *) {
            content
                .if(action != nil) { view in
                    view.onTapGesture {
                        action?()
                    }
                }
        } else if #available(iOS 18.0, *) {
            content
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isPressed = value.translation == .zero
                        }
                        .onEnded { _ in
                            isPressed = false
                        }
                )
                .if(action != nil) { view in
                    view.onTapGesture {
                        action?()
                    }
                }
        } else {
            SwiftUI.Button {
                action?()
            } label: {
                content
            }
            .buttonStyle(PressDetectingButtonStyle(isPressed: $isPressed))
        }
    }
    
    struct PressDetectingButtonStyle: ButtonStyle {
        @Binding var isPressed: Bool
        
        init(isPressed: Binding<Bool> = .constant(false)) {
            self._isPressed = isPressed
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .onChange(of: configuration.isPressed) { newValue in
                    isPressed = newValue
                }
        }
    }
}
