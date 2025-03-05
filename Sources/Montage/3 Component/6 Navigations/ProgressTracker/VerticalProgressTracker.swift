//
//  VerticalProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/20/24.
//

import SwiftUI

extension ProgressTracker {
    public struct Vertical: View {
        public struct StepContent: View {
            private let label: String
            private let labelAccessoryView: (() -> any View)?
            private let contentView: (() -> any View)?
            
            public init(
                label: String = "",
                labelAccessoryView: (() -> any View)? = nil,
                contentView: (() -> any View)? = nil
            ) {
                self.label = label
                self.labelAccessoryView = labelAccessoryView
                self.contentView = contentView
            }
            
            public var body: some View {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center, spacing: 6) {
                            text
                            if let labelAccessoryView {
                                AnyView(labelAccessoryView())
                            }
                        }
                        .frame(height: 20)
                        .if(!label.isEmpty)
                        
                        if let contentView {
                            AnyView(contentView())
                        }
                    }
                }
            }
            
            private var status: Stepper.Status = .inactive
            func status(_ status: Stepper.Status) -> Self {
                var zelf = self
                zelf.status = status
                return zelf
            }
            
            private var text: some View {
                Text(label)
                    .montage(variant: .label2, weight: .bold, color: labelColor)
                    .lineLimit(1)
                    .fixedSize()
            }
            
            private var labelColor: SwiftUI.Color {
                switch status {
                case .complete, .inactive:
                    .alias(.labelAlternative)
                case .active:
                    .alias(.labelNormal)
                }
            }
        }
        
        @Binding private var progress: Int
        private let stepContents: [StepContent]
        public init(progress: Binding<Int>, stepContents: [StepContent]) {
            _progress = progress
            self.stepContents = stepContents
        }
        
        @State private var lineLengths: [Int: CGFloat] = [:]
        @State private var stepperSize: CGSize = .zero
        
        public var body: some View {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(stepContents.indices, id: \.self) { index in
                        Group {
                            if index < stepContents.count - 1 {
                                line(after: index)
                            } else {
                                SwiftUI.Color.clear
                            }
                        }
                        .frame(height: lineLengths[index] ?? .zero)
                    }
                }
                .frame(width: stepperSize.width)
                
                VStack(spacing: 0) {
                    ForEach(stepContents.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 0) {
                            Stepper(step: index + 1, state: state(at: index))
                            
                            if index >= 0 && index < stepContents.count {
                                stepContents[index]
                                    .status(state(at: index))
                                    .padding(.leading, 8)
                            }
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.bottom, index < stepContents.count - 1 ? 20 : 0)
                        .onGeometryChange(
                            for: CGFloat.self,
                            of: { $0.size.height },
                            action: { lineLengths.updateValue($0, forKey: index) }
                        )
                    }
                }
                
                // 사이즈 측정을 위한 투명 뷰들
                Group {
                    Stepper(step: 0, state: state(at: 0))
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
                }
                .opacity(0)
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
        
        private func line(after index: Int) -> some View {
            Rectangle()
                .frame(width: 1)
                .foregroundStyle(
                    SwiftUI.Color
                        .alias(state(at: index) == .complete ? .primaryNormal : .lineSolidNormal)
                )
        }
    }
}
