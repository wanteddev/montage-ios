//
//  HorizontalProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

extension ProgressTracker {
    public struct Horizontal: View {
        @Binding private var progress: Int
        private let labels: [String]
        public init(progress: Binding<Int>, labels: [String]) {
            _progress = progress
            self.labels = labels
        }
        
        public init(progress: Binding<Int>, count: Int) {
            _progress = progress
            labels = .init(repeating: "", count: count)
        }
        
        @State private var size: CGSize = .zero
        @State private var stepperSize: CGSize = .zero
        @State private var textMaxHeight: CGFloat = .zero
        
        public var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(labels.indices, id: \.self) { index in
                        let alignment: HorizontalAlignment = .center
                        VStack(alignment: alignment, spacing: 8) {
                            HStack(spacing: 0) {
                                line(before: index)
                                Stepper(step: index + 1, state: state(at: index))
                                line(after: index)
                            }
                            ZStack {
                                text(at: index, alignment: textAlignment(from: alignment))
                                    .frame(height: textMaxHeight, alignment: .top)
                                text(at: index, alignment: .center)
                                    .onGeometryChange(
                                        for: CGFloat.self,
                                        of: { $0.size.height },
                                        action: { textMaxHeight = max(textMaxHeight, $0) }
                                    )
                                    .opacity(0)
                            }
                            .if(!labels[index].isEmpty)
                        }
                    }
                }
                
                Group {
                    SwiftUI.Color.clear
                        .fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
                    Stepper(step: 0, state: state(at: 0))
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
                }
                .opacity(0)
            }
        }
        
        private func text(at index: Int, alignment: TextAlignment) -> some View {
            Text(labels[index])
                .montage(variant: .label2, weight: .bold, color: labelColor(at: index))
                .multilineTextAlignment(alignment)
                .if(!labels[index].isEmpty)
        }
        
        private func labelColor(at index: Int) -> SwiftUI.Color {
            switch state(at: index) {
            case .complete, .inactive:
                .alias(.labelAlternative)
            case .active:
                .alias(.labelNormal)
            }
        }
        
        private func textAlignment(from horizontalAlignment: HorizontalAlignment) -> TextAlignment {
            switch horizontalAlignment {
            case .leading: .leading
            case .trailing: .trailing
            default: .center
            }
        }
        
        private func state(at index: Int) -> Stepper.Status {
            if index < progress - 1 {
                .complete
            } else if index > progress - 1 {
                .inactive
            } else {
                .active
            }
        }
        
        private func line(before index: Int) -> some View {
            Group {
                if index > 0 {
                    Rectangle()
                        .foregroundStyle(
                            SwiftUI.Color
                                .alias(state(at: index - 1) == .complete ? .primaryNormal : .lineSolidNormal)
                        )
                } else {
                    SwiftUI.Color.clear
                }
            }
            .frame(height: 1)
        }
        
        private func line(after index: Int) -> some View {
            Group {
                if index < labels.count - 1 {
                    Rectangle()
                        .foregroundStyle(
                            SwiftUI.Color
                                .alias(state(at: index) == .complete ? .primaryNormal : .lineSolidNormal)
                        )
                } else {
                    SwiftUI.Color.clear
                }
            }
            .frame(height: 1)
        }
    }
}
