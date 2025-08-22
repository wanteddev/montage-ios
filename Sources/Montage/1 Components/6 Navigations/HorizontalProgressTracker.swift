//
//  HorizontalProgressTracker.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI

/// 수평 방향으로 단계별 진행 상태를 표시하는 컴포넌트입니다.
///
/// `Horizontal`은 여러 단계로 구성된 프로세스의 진행 상태를 수평 레이아웃으로 표시합니다.
/// 각 단계는 원형 아이콘과 선으로 연결되며, 완료된 단계는 체크 마크로 표시됩니다.
/// 각 단계에 라벨을 추가하여 단계의 의미를 명확히 전달할 수 있습니다.
///
/// ```swift
/// @State private var currentStep = 2
/// 
/// HorizontalProgressTracker(
///     progress: $currentStep,
///     labels: ["회원 정보", "배송지 정보", "결제 정보", "주문 완료"]
/// )
/// ```
///
/// - Note: 현재 단계는 강조 표시되며, 이전 단계는 완료 상태로, 이후 단계는 비활성 상태로 표시됩니다.
public struct HorizontalProgressTracker: View {
    @Binding private var progress: Int
    private let labels: [String]
    
    /// 수평 진행 추적기를 초기화합니다.
    ///
    /// - Parameters:
    ///   - progress: 현재 진행 중인 단계 (1부터 시작)
    ///   - labels: 각 단계의 라벨 텍스트 배열
    public init(progress: Binding<Int>, labels: [String]) {
        _progress = progress
        self.labels = labels
    }
    
    /// 라벨 없는 수평 진행 추적기를 초기화합니다.
    ///
    /// - Parameters:
    ///   - progress: 현재 진행 중인 단계 (1부터 시작)
    ///   - count: 전체 단계 수
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
                            ProgressTrackerStepper(step: index + 1, state: state(at: index))
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
                ProgressTrackerStepper(step: 0, state: state(at: 0))
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { stepperSize = $0 })
            }
            .opacity(0)
        }
    }
    
    private func text(at index: Int, alignment: TextAlignment) -> some View {
        Text(labels[index])
            .typographyNew(variant: .label2, weight: .bold, color: labelColor(at: index))
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
    
    private func state(at index: Int) -> ProgressTrackerStepper.Status {
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
                            state(at: index - 1) == .complete ? .primaryNormal : .lineSolidNormal
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
