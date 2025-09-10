//
//  VerticalProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/20/24.
//

import SwiftUI

/// 수직 방향으로 단계별 진행 상태를 표시하는 컴포넌트입니다.
///
/// `Vertical`은 여러 단계로 구성된 프로세스의 진행 상태를 수직 레이아웃으로 표시합니다.
/// 각 단계는 원형 아이콘과 수직선으로 연결되며, 완료된 단계는 체크 마크로 표시됩니다.
/// 각 단계에 라벨과 추가 콘텐츠를 표시할 수 있어 풍부한 정보 제공이 가능합니다.
///
/// ```swift
/// @State private var currentStep = 2
/// 
/// VerticalProgressTracker(
///     progress: $currentStep,
///     stepContents: [
///         VerticalProgressTracker.StepContent(label: "기본 정보"),
///         VerticalProgressTracker.StepContent(
///             label: "상세 정보",
///             contentView: { Text("내용을 입력해주세요") }
///         ),
///         VerticalProgressTracker.StepContent(label: "완료")
///     ]
/// )
/// ```
///
/// - Note: 각 단계에는 라벨 외에도 추가 콘텐츠를 표시할 수 있어 복잡한 단계별 정보를 표현하는 데 적합합니다.
public struct VerticalProgressTracker: View {
    /// 수직 진행 추적기의 각 단계에 표시되는 콘텐츠 컴포넌트입니다.
    ///
    /// 각 단계의 라벨, 라벨 보조 뷰, 그리고 추가 콘텐츠를 포함할 수 있습니다.
    ///
    /// ```swift
    /// VerticalProgressTracker.StepContent(
    ///     label: "배송 정보",
    ///     labelAccessoryView: { Image(systemName: "info.circle") },
    ///     contentView: { AddressInputView() }
    /// )
    /// ```
    ///
    /// - Note: 콘텐츠 뷰를 통해 각 단계에 맞는 복잡한 UI를 표시할 수 있습니다.
    public struct StepContent: View {
        private let label: String
        private let labelAccessoryView: () -> AnyView
        private let contentView: () -> AnyView
        
        /// 단계 콘텐츠를 초기화합니다.
        ///
        /// - Parameters:
        ///   - label: 단계의 제목 텍스트
        ///   - labelAccessoryView: 라벨 옆에 표시할 보조 뷰를 생성하는 클로저
        ///   - contentView: 라벨 아래에 표시할 추가 콘텐츠 뷰를 생성하는 클로저
        public init(
            label: String = "",
            labelAccessoryView: (() -> any View)? = nil,
            contentView: (() -> any View)? = nil
        ) {
            self.label = label
            self.labelAccessoryView = labelAccessoryView.map { view in { AnyView(view()) }} ?? { AnyView(EmptyView()) }
            self.contentView = contentView.map { view in { AnyView(view()) }} ?? { AnyView(EmptyView()) }
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
        
        private var status: ProgressTrackerStepper.Status = .inactive
        func status(_ status: ProgressTrackerStepper.Status) -> Self {
            var zelf = self
            zelf.status = status
            return zelf
        }
        
        private var text: some View {
            Text(label)
                .typographyNew(variant: .label2, weight: .bold, color: labelColor)
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
    
    @Binding private var progress: Int
    private let stepContents: [StepContent]
    
    /// 수직 진행 추적기를 초기화합니다.
    ///
    /// - Parameters:
    ///   - progress: 현재 진행 중인 단계 (1부터 시작)
    ///   - stepContents: 각 단계의 콘텐츠 배열
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
                        ProgressTrackerStepper(step: index + 1, state: state(at: index))
                        
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
            
            // 사이즈 측정을 위한 투명 뷰들
            Group {
                ProgressTrackerStepper(step: 0, state: state(at: 0))
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
            }
            .opacity(0)
        }
    }
    
    private func state(at index: Int) -> ProgressTrackerStepper.Status {
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
