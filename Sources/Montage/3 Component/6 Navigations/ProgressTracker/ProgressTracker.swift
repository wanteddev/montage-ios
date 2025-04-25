//
//  ProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

/// 단계별 진행 상태를 추적하고 표시하는 컴포넌트 타입을 그룹화하는 네임스페이스입니다.
///
/// `ProgressTracker`는 다단계 프로세스의 진행 상태를 시각적으로 표시하는 컴포넌트를 제공합니다.
/// 수평 및 수직 레이아웃을 지원하며, 각 단계의 완료/활성/비활성 상태를 구분하여 표시합니다.
///
/// - Note: 각 `ProgressTracker`컴포넌트는 개별 구현체로 제공되며, 이 열거형은 네임스페이스 역할만 합니다.
/// - SeeAlso: ``ProgressTracker/Horizontal``, ``ProgressTracker/Vertical``
public enum ProgressTracker {
    struct Stepper: View {
        enum Status {
            case complete, active, inactive
        }
        
        private let step: Int
        private let state: Status
        init(step: Int, state: Status) {
            self.step = step
            self.state = state
        }
        
        @State private var textSize: CGSize = .zero
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 20, height: 20)
                if state == .complete {
                    Image.montage(.checkThick)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
                } else {
                    Text(String(step))
                        .montage(variant: .caption1, weight: .bold, semantic: .staticWhite)
                        .frame(height: 16, alignment: .center)
                }
            }
        }
        
        private var backgroundColor: SwiftUI.Color {
            switch state {
            case .complete, .active:
                .semantic(.primaryNormal)
            case .inactive:
                .semantic(.lineSolidNormal)
            }
        }
    }
    
    struct StepperStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .overlay {
                    Text("단계")
                        .offset(y: 20)
                }
        }
    }
}
