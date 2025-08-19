//
//  Filter.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import Pretendard
import SwiftUI

/// 필터링 기능을 제공하는 칩 컴포넌트입니다.
///
/// 이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다.
/// 다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.
///
/// ```swift
/// FilterChip(
///     variant: .solid,
///     size: .medium,
///     text: "카테고리",
///     state: $state
/// )
/// .backgroundColor(.semantic(.primary))
/// .fontColor(.semantic(.staticWhite))
/// .active(true)
/// .activeLabel("최신순")
/// ```
///
public struct FilterChip: View {
    // MARK: - Types

    /// 칩의 외관을 결정하는 열거형입니다.
    public enum Variant {
        /// 배경색이 있는 실선 스타일
        case solid
        /// 테두리만 있는 아웃라인 스타일
        case outlined
    }
    
    /// 칩의 크기를 정의합니다.
    public enum Size: String {
        /// 가장 작은 크기
        case xsmall
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
    }
    
    /// 칩의 확장 상태를 정의합니다.
    public enum State {
        /// 기본 상태
        case normal
        /// 확장된 상태 (드롭다운 표시)
        case expand
    }
    
    // MARK: - Initializer
    
    private let variant: Variant
    private let size: Size
    private let text: String
    private let state: Binding<State>
    private let handler: (() -> Void)?
    
    /// 필터 칩을 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 칩의 외관 스타일, 기본값은 `.solid`
    ///   - size: 칩의 크기, 기본값은 `.medium`
    ///   - text: 칩에 표시할 텍스트
    ///   - state: 칩의 확장 상태 바인딩, 기본값은 `.constant(.normal)`
    ///   - handler: 칩 클릭 시 실행할 핸들러, 기본값은 `nil`
    public init(
        variant: Variant = .solid,
        size: Size = .medium,
        text: String,
        state: Binding<State> = .constant(.normal),
        handler: (() -> Void)? = nil
    ) {
        self.variant = variant
        self.size = size
        self.text = text
        self.state = state
        self.handler = handler
    }
    
    // MARK: - Body
    
    @SwiftUI.State private var isPressed = false
    
    public var body: some View {
        HStack(spacing: contentSpacing) {
            Text(active && activeLabel != nil ? activeLabel! : text)
                .paragraph(variant: typoVariant, weight: .medium, color: fontColor)
                .padding(.horizontal, textPadding)
            
            Image.icon(state.wrappedValue == .normal ? .caretDown : .caretUp)
                .resizable()
                .foregroundStyle(iconColor)
                .frame(width: imageSize, height: imageSize)
        }
        .padding(contentPadding)
        .frame(
            maxWidth: fillHorizontal ? .infinity : nil,
            maxHeight: fillVertical ? .infinity : nil
        )
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .opacity(disable ? 0.5 : 1.0)
        .contentShape(Rectangle())
        .background(
            Interaction(
                state: isPressed ? .pressed : .normal,
                variant: .light,
                color: .labelNormal
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        .disabled(disable)
    }
    
    // MARK: - Modifiers
    
    private var active = false
    private var activeLabel: String?
    private var disable = false
    private var customBackgroundColor: SwiftUI.Color?
    private var customFontColor: SwiftUI.Color?
    private var customActiveColor: SwiftUI.Color?
    private var customIconColor: SwiftUI.Color?
    private var fillHorizontal = false
    private var fillVertical = false
    
    /// 칩의 활성화 상태와 레이블을 설정합니다.
    ///
    /// - Parameters:
    ///   - active: 활성화 여부
    ///   - label: 활성화 상태일 때 표시할 레이블
    /// - Returns: 수정된 칩 인스턴스
    public func active(_ active: Bool, label: String? = nil) -> Self {
        var view = self
        view.active = active
        view.activeLabel = label
        return view
    }
    
    /// 칩의 비활성화 여부를 설정합니다.
    ///
    /// - Parameter disable: 비활성화 여부
    /// - Returns: 수정된 칩 인스턴스
    public func disabled(_ disable: Bool = true) -> Self {
        var view = self
        view.disable = disable
        return view
    }
    
    /// 칩의 배경색을 설정합니다.
    ///
    /// - Parameter color: 적용할 배경색
    /// - Returns: 수정된 칩 인스턴스
    public func backgroundColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customBackgroundColor = color
        return view
    }
    
    /// 칩의 텍스트 색상을 설정합니다.
    ///
    /// - Parameter color: 적용할 텍스트 색상
    /// - Returns: 수정된 칩 인스턴스
    public func fontColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customFontColor = color
        return view
    }
    
    /// 칩의 활성화 상태 색상을 설정합니다.
    ///
    /// - Parameter color: 활성화 상태일 때의 색상
    /// - Returns: 수정된 칩 인스턴스
    public func activeColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customActiveColor = color
        return view
    }
    
    /// 아이콘의 색상을 설정합니다.
    ///
    /// - Parameter color: 아이콘에 적용할 색상
    /// - Returns: 수정된 칩 인스턴스
    /// - Note: 기본값은 `.semantic(.labelAlternative)`입니다.
    public func iconColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customIconColor = color
        return view
    }
}

extension FilterChip.Variant {
    var backgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.fillAlternative)
        case .outlined:
            .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .solid:
            .zero
        case .outlined:
            1
        }
    }
    
    var disableBackgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.interactionDisable)
        case .outlined:
            .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseBackground)
        case .outlined:
            .semantic(.primaryNormal).withAlphaComponent(0.05)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseLabel)
        case .outlined:
            .semantic(.primaryNormal)
        }
    }
    
    var activeArrowColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseLabel)
        case .outlined:
            .semantic(.labelNormal)
        }
    }
}

private extension FilterChip {
    var backgroundColor: SwiftUI.Color {
        if disable {
            switch variant {
            case .solid:
                return .semantic(.interactionDisable)
            case .outlined:
                return .clear
            }
        } else if active {
            switch variant {
            case .solid:
                return customActiveColor ?? .semantic(.inverseBackground)
            case .outlined:
                return .semantic(.primaryNormal).opacity(0.05)
            }
        } else {
            switch variant {
            case .solid:
                return customBackgroundColor ?? .semantic(.fillAlternative)
            case .outlined:
                return .clear
            }
        }
    }
    
    var fontColor: SwiftUI.Color {
        if disable {
            return .semantic(.labelDisable)
        } else if active {
            return activeContentColor
        } else {
            return customFontColor ?? .semantic(.labelAlternative)
        }
    }
    
    var iconColor: SwiftUI.Color {
        if disable {
            return .semantic(.labelDisable)
        } else if active {
            return activeContentColor
        } else {
            return customIconColor ?? .semantic(.labelAlternative)
        }
    }
    
    var activeContentColor: SwiftUI.Color {
        switch variant {
        case .solid:
            return .semantic(.inverseLabel)
        case .outlined:
            return customActiveColor ?? .semantic(.primaryNormal)
        }
    }
    
    var borderColor: SwiftUI.Color {
        guard variant == .outlined else { return .clear }
        if disable {
            return .semantic(.lineNeutral)
        } else if active {
            return (customActiveColor ?? .semantic(.primaryNormal)).opacity(0.43)
        } else {
            return .semantic(.lineNeutral)
        }
    }
    
    var borderWidth: CGFloat {
        variant == .outlined ? 1 : 0
    }
    
    var imageSize: CGFloat {
        switch size {
        case .large: return 16
        case .medium: return 16
        case .small: return 16
        case .xsmall: return 12
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .large: return .body2
        case .medium: return .body2
        case .small: return .label1
        case .xsmall: return .caption1
        }
    }
    
    var contentPadding: EdgeInsets {
        switch size {
        case .large: return EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12)
        case .medium: return EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11)
        case .small: return EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
        case .xsmall: return EdgeInsets(top: 4, leading: 7, bottom: 4, trailing: 7)
        }
    }
    
    var contentSpacing: CGFloat {
        switch size {
        case .large: return 2
        case .medium: return 2
        case .small: return 1
        case .xsmall: return 1
        }
    }
    
    var textPadding: CGFloat {
        switch size {
        case .large: return 2.0
        case .medium: return 2.0
        case .small: return 2.0
        case .xsmall: return 1.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch size {
        case .large: return 10.0
        case .medium: return 10.0
        case .small: return 8.0
        case .xsmall: return 6.0
        }
    }
}
