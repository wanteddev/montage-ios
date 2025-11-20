//
//  ProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

/// 단계별 진행 상태를 수평/수직으로 표시하는 컴포넌트입니다.
///
/// 여러 단계로 구성된 프로세스의 현재 위치를 시각화하며, 완료 단계에는 체크 마크, 진행 중/대기 단계에는 상태에 따른 스타일을 적용합니다.
/// 수평(horizontal)과 수직(vertical) 레이아웃을 모두 지원합니다.
///
/// - 수평(horizontal)
///   ```swift
///   @State private var currentStep = 2
///   ProgressTracker(
///       progress: $currentStep,
///       variant: .horizontal(labels: ["회원 정보", "배송지 정보", "결제 정보", "주문 완료"])
///   )
///   ```
///
/// - 수직(vertical)
///   ```swift
///   @State private var currentStep = 2
///   ProgressTracker(
///       progress: $currentStep,
///       variant: .vertical(stepContents: [
///           ProgressTracker.VerticalStepContent(label: "기본 정보"),
///           ProgressTracker.VerticalStepContent(
///               label: "상세 정보",
///               contentView: { Text("내용을 입력해주세요") }
///           ),
///           ProgressTracker.VerticalStepContent(label: "완료")
///       ])
///   )
///   ```

public struct ProgressTracker: View {
    /// 레이아웃 및 구성을 정의하는 옵션입니다.
    public enum Variant {
        /// 수평 레이아웃. 각 단계의 라벨을 지정합니다.
        /// - Parameters:
        ///   - labels: 각 단계의 라벨 텍스트 배열
        case horizontal(labels: [String])
        /// 수직 레이아웃. 각 단계의 라벨과 보조/콘텐츠 뷰를 지정합니다.
        /// - Parameters:
        ///   - stepContents: 각 단계에 표시되는 콘텐츠 배열
        case vertical(stepContents: [VerticalStepContent])
    }

    @Binding private var progress: Int
    private let variant: Variant

    public init(progress: Binding<Int>, variant: Variant) {
        _progress = progress
        self.variant = variant
    }

    public var body: some View {
        switch variant {
        case .horizontal(let labels):
            Horizontal(progress: $progress, labels: labels)
        case .vertical(let stepContents):
            Vertical(progress: $progress, stepContents: stepContents)
        }
    }

    /// 수직 진행 추적기에서 각 단계에 표시되는 콘텐츠를 표현하는 공개 타입입니다.
    public struct VerticalStepContent: View {
        private let label: String
        private let labelAccessoryView: () -> AnyView
        private let contentView: () -> AnyView

        public init(
            label: String = "",
            labelAccessoryView: (() -> any View)? = nil,
            contentView: (() -> any View)? = nil
        ) {
            self.label = label
            self.labelAccessoryView =
                labelAccessoryView.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
            self.contentView =
                contentView.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
        }

        public var body: some View {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center, spacing: 6) {
                        text
                        labelAccessoryView()
                    }
                    .frame(height: 20)
                    .if(!label.isEmpty)

                    contentView()
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
                .typography(variant: .label2, weight: .bold, color: labelColor)
                .lineLimit(1)
                .fixedSize()
        }

        private var labelColor: SwiftUI.Color {
            switch status {
            case .complete, .inactive:
                .semantic(.labelAlternative)
            case .active:
                .semantic(.labelNormal)
            }
        }
    }
}

extension ProgressTracker {
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
    
    struct Horizontal: View {
        @Binding private var progress: Int
        private let labels: [String]
        
        init(progress: Binding<Int>, labels: [String]) {
            _progress = progress
            self.labels = labels
        }
        
        @State private var size: CGSize = .zero
        @State private var stepperSize: CGSize = .zero
        @State private var textMaxHeight: CGFloat = .zero
        
        var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(labels.indices, id: \.self) { index in
                        let alignment: HorizontalAlignment = .center
                        VStack(alignment: alignment, spacing: 8) {
                            HStack(spacing: 0) {
                                line(before: index)
                                ProgressTracker.Stepper(step: index + 1, state: state(at: index))
                                line(after: index)
                            }
                            if labels[index].isEmpty {
                                SwiftUI.Color.clear
                            } else {
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
                            }
                        }
                    }
                }
                
                Group {
                    SwiftUI.Color.clear
                        .fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
                    ProgressTracker.Stepper(step: 0, state: state(at: 0))
                        .onGeometryChange(
                            for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
                }
                .opacity(0)
            }
        }
        
        private func text(at index: Int, alignment: TextAlignment) -> some View {
            Text(labels[index])
                .typography(variant: .label2, weight: .bold, color: labelColor(at: index))
                .multilineTextAlignment(alignment)
                .if(!labels[index].isEmpty)
        }
        
        private func labelColor(at index: Int) -> SwiftUI.Color {
            switch state(at: index) {
            case .complete, .inactive:
                    .semantic(.labelAlternative)
            case .active:
                    .semantic(.labelNormal)
            }
        }
        
        private func textAlignment(from horizontalAlignment: HorizontalAlignment) -> TextAlignment {
            switch horizontalAlignment {
            case .leading: .leading
            case .trailing: .trailing
            default: .center
            }
        }
        
        private func state(at index: Int) -> ProgressTracker.Stepper.Status {
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
                            SwiftUI.Color.semantic(
                                state(at: index - 1) == .complete
                                ? .primaryNormal : .lineSolidNormal
                            )
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
                            SwiftUI.Color.semantic(
                                state(at: index) == .complete ? .primaryNormal : .lineSolidNormal
                            )
                        )
                } else {
                    SwiftUI.Color.clear
                }
            }
            .frame(height: 1)
        }
    }
    
    struct Vertical: View {
        
        @Binding private var progress: Int
        private let stepContents: [ProgressTracker.VerticalStepContent]
        
        init(progress: Binding<Int>, stepContents: [ProgressTracker.VerticalStepContent]) {
            _progress = progress
            self.stepContents = stepContents
        }
        
        @State private var lineLengths: [Int: CGFloat] = [:]
        @State private var stepperSize: CGSize = .zero
        
        var body: some View {
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
                            ProgressTracker.Stepper(step: index + 1, state: state(at: index))
                            
                            stepContents[safe: index]?
                                .status(state(at: index))
                                .padding(.leading, 8)
                            
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
                
                Group {
                    ProgressTracker.Stepper(step: 0, state: state(at: 0))
                        .onGeometryChange(
                            for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
                }
                .opacity(0)
            }
        }
        
        private func state(at index: Int) -> ProgressTracker.Stepper.Status {
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
                        .semantic(state(at: index) == .complete ? .primaryNormal : .lineSolidNormal)
                )
        }
    }
}
