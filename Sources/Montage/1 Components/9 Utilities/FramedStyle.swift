//
//  FramedStyle.swift
//  Views
//
//  Created by 김삼열 on 8/22/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

/// 프레임의 크기를 정의하는 열거형입니다.
///
/// 각 크기마다 다른 패딩, 테두리 반경, 그림자 레벨이 적용됩니다.
public enum FramedStyleSize: CaseIterable {
    /// 작은 크기
    case small
    /// 중간 크기
    case medium
    /// 큰 크기
    case large
    /// 매우 큰 크기
    case xlarge
}

/// 프레임의 상태를 정의하는 열거형입니다.
///
/// 각 상태마다 다른 테두리 색상과 스타일이 적용됩니다.
public enum FramedStyleStatus: CaseIterable {
    /// 기본 상태
    case normal
    /// 선택된 상태
    case selected
    /// 부정적 상태 (오류, 경고 등)
    case negative
}

// MARK: - ViewModifier

struct FramedStyleModifier: ViewModifier {
    private let size: FramedStyleSize
    private let status: FramedStyleStatus
    private let shadowLevel: ShadowLevel
    private let disabled: Bool
    
    init(
        size: FramedStyleSize = .medium,
        status: FramedStyleStatus = .normal,
        shadowLevel: ShadowLevel = .xsmall,
        disabled: Bool = false
    ) {
        self.size = size
        self.status = status
        self.shadowLevel = shadowLevel
        self.disabled = disabled
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background {
                RoundedRectangle(cornerRadius: borderRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: borderRadius))
            }
            .shadow(shadowLevel)
            .disabled(disabled)
    }
    
    private var borderRadius: CGFloat {
        switch size {
        case .small:
            return 10
        case .medium:
            return 14
        case .large:
            return 16
        case .xlarge:
            return 20
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small:
            return 12
        case .medium:
            return 16
        case .large:
            return 20
        case .xlarge:
            return 24
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small:
            return 4
        case .medium:
            return 4
        case .large:
            return 4
        case .xlarge:
            return 8
        }
    }
    
    private var backgroundColor: SwiftUI.Color {
        if disabled {
            .semantic(.interactionDisable)
        } else {
            .semantic(.backgroundNormal)
        }
    }
    
    private var borderWidth: CGFloat {
        status == .selected ? 2 : 1
    }
    
    private var borderColor: SwiftUI.Color {
        switch status {
        case .normal:
            .semantic(.lineNeutral)
        case .selected:
            .semantic(.primaryNormal).opacity(0.43)
        case .negative:
            .semantic(.statusNegative).opacity(0.28)
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 프레임 스타일을 적용합니다.
    ///
    /// 테두리, 배경, 그림자가 있는 프레임을 뷰에 적용하여 일관된 디자인을 제공합니다.
    /// 다양한 크기와 상태를 설정할 수 있어 다양한 UI 요소에 활용할 수 있습니다.
    ///
    /// - Parameters:
    ///   - size: 프레임 크기 (기본값: .medium)
    ///   - status: 프레임 상태 (기본값: .normal)
    ///   - shadowLevel: 그림자 레벨 (기본값: .xsmall)
    ///   - disabled: 비활성화 상태 여부 (기본값: false)
    /// - Returns: 프레임 스타일이 적용된 뷰
    ///
    /// ```swift
    /// // 기본 사용법
    /// Text("입력 필드")
    ///     .framedStyle()
    ///
    /// // 큰 프레임에 그림자 적용
    /// Button("확인") { }
    ///     .framedStyle(size: .large, shadowLevel: .medium)
    ///
    /// // 선택된 상태의 프레임
    /// Rectangle()
    ///     .frame(width: 200, height: 100)
    ///     .framedStyle(status: .selected)
    ///
    /// // 비활성화된 프레임
    /// Text("비활성화된 텍스트")
    ///     .framedStyle(disabled: true)
    ///
    /// // 부정적 상태의 프레임 (오류 표시)
    /// Text("오류 메시지")
    ///     .framedStyle(status: .negative)
    ///
    /// // 작은 크기의 선택된 프레임
    /// Text("선택된 항목")
    ///     .framedStyle(size: .small, status: .selected)
    /// ```
    public func framedStyle(
        size: FramedStyleSize = .medium,
        status: FramedStyleStatus = .normal,
        shadowLevel: ShadowLevel = .xsmall,
        disabled: Bool = false
    ) -> some View {
        modifier(FramedStyleModifier(
            size: size,
            status: status,
            shadowLevel: shadowLevel,
            disabled: disabled
        ))
    }
}
