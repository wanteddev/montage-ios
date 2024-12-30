//
//  ProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

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
                        .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
                } else {
                    Text(String(step))
                        .montage(variant: .caption1, weight: .bold, alias: .staticWhite)
                        .frame(height: 16, alignment: .center)
                }
            }
        }
        
        private var backgroundColor: SwiftUI.Color {
            switch state {
            case .complete, .active:
                return .alias(.primaryNormal)
            case .inactive:
                return .alias(.lineSolidNormal)
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

