//
//  ProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

struct ProgressTrackerStepper: View {
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
                Image.icon(.checkThick)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
            } else {
                Text(String(step))
                    .typography(variant: .caption1, weight: .bold, semantic: .staticWhite)
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
