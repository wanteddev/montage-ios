//
//  FilterButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import SwiftUI

/// 필터링 기능을 제공하는 버튼 컴포넌트입니다.
///
/// 이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다.
/// 다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.
///
/// ```swift
/// FilterButton(
///     variant: .solid,
///     size: .medium,
///     text: "카테고리",
///     state: $state
/// )
/// .backgroundColor(.semantic(.surfaceBrandPrimary))
/// .fontColor(.semantic(.staticWhite))
/// .active(true, label: "최신순")
///
/// // 비활성화
/// FilterButton(text: "카테고리", state: $state)
///     .disabled(true)
/// ```
///
/// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
/// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
public struct FilterButton: View {
    // MARK: - Types

    /// 버튼의 외관을 결정하는 열거형입니다.
    public enum Variant {
        /// 배경색이 있는 실선 스타일
        case solid
        /// 테두리만 있는 아웃라인 스타일
        case outlined
    }
    
    /// 버튼의 크기를 정의합니다.
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
    
    /// 버튼의 확장 상태를 정의합니다.
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
    
    /// 필터 버튼을 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 버튼의 외관 스타일, 생략하면 기본값으로 `.solid` 적용
    ///   - size: 버튼의 크기, 생략하면 기본값으로 `.medium` 적용
    ///   - text: 버튼에 표시할 텍스트
    ///   - state: 버튼의 확장 상태 바인딩, 생략하면 기본값으로 `.constant(.normal)` 적용
    ///   - handler: 버튼 클릭 시 실행할 핸들러, 생략하면 기본값으로 `nil` 적용
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
    
    @Environment(\.isEnabled) private var isEnabled
    @SwiftUI.State private var isPressed = false
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        HStack(spacing: 0) {
            Text(active ? (activeLabel ?? text) : text)
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
        .contentShape(Rectangle())
        .background(
            Interaction(
                state: isPressed ? .pressed : .normal,
                variant: .light,
                color: .foregroundNeutralPrimary
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(active ? (activeLabel ?? String(localized: "선택됨", bundle: .module)) : "")
    }
    
    // MARK: - Modifiers
    
    private var active = false
    private var activeLabel: String?
    private var customBackgroundColor: SwiftUI.Color?
    private var customFontColor: SwiftUI.Color?
    private var customActiveColor: SwiftUI.Color?
    private var customIconColor: SwiftUI.Color?
    private var fillHorizontal = false
    private var fillVertical = false
    /// 버튼의 활성화 상태와 레이블을 설정합니다.
    ///
    /// - Parameters:
    ///   - active: 활성화 여부
    ///   - label: 활성화 상태일 때 표시할 레이블, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 수정된 버튼 인스턴스
    public func active(_ active: Bool, label: String? = nil) -> Self {
        var view = self
        view.active = active
        view.activeLabel = label
        return view
    }
    
    /// 버튼의 배경색을 설정합니다.
    ///
    /// - Parameter color: 적용할 배경색
    /// - Returns: 수정된 버튼 인스턴스
    public func backgroundColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customBackgroundColor = color
        return view
    }
    
    /// 버튼의 텍스트 색상을 설정합니다.
    ///
    /// - Parameter color: 적용할 텍스트 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func fontColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customFontColor = color
        return view
    }
    
    /// 버튼의 활성화 상태 색상을 설정합니다.
    ///
    /// - Parameter color: 활성화 상태일 때의 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func activeColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customActiveColor = color
        return view
    }
    
    /// 아이콘의 색상을 설정합니다.
    ///
    /// - Parameter color: 아이콘에 적용할 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func iconColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customIconColor = color
        return view
    }
}

extension FilterButton.Variant {
    var backgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.surfaceNeutralTertiary)
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
            .semantic(.surfaceDisablePrimary)
        case .outlined:
            .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.surfaceNeutralInverse)
        case .outlined:
            .semantic(.surfaceBrandPrimary).withAlphaComponent(.opacity5)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .solid:
            .semantic(.foregroundNeutralInverse)
        case .outlined:
            .semantic(.surfaceBrandPrimary)
        }
    }
    
    var activeArrowColor: UIColor {
        switch self {
        case .solid:
            .semantic(.foregroundNeutralInverse)
        case .outlined:
            .semantic(.foregroundNeutralPrimary)
        }
    }
}

private extension FilterButton {
    var isDisabled: Bool { isEnabled == false }

    var backgroundColor: SwiftUI.Color {
        if isDisabled {
            switch variant {
            case .solid:
                return .semantic(.surfaceDisablePrimary)
            case .outlined:
                return .clear
            }
        } else if active {
            return .semantic(.surfaceBrandSubtle)
        } else {
            switch variant {
            case .solid:
                return customBackgroundColor ?? .semantic(.surfaceNeutralTertiary)
            case .outlined:
                return .clear
            }
        }
    }
    
    var fontColor: SwiftUI.Color {
        if isDisabled {
            return .semantic(.foregroundDisablePrimary)
        } else if active {
            return activeContentColor
        } else {
            return customFontColor ?? .semantic(.foregroundNeutralPrimary)
        }
    }
    
    var iconColor: SwiftUI.Color {
        if isDisabled {
            return .semantic(.foregroundDisablePrimary)
        } else if active {
            return activeContentColor
        } else if let customIconColor {
            return customIconColor
        } else {
            switch variant {
            case .solid:
                return .semantic(.foregroundNeutralPrimary)
            case .outlined:
                return .semantic(.foregroundNeutralTertiary)
            }
        }
    }
    
    var activeContentColor: SwiftUI.Color {
        customActiveColor ?? .semantic(.surfaceBrandPrimary)
    }
    
    var borderColor: SwiftUI.Color {
        guard variant == .outlined else { return .clear }
        if isDisabled {
            return .semantic(.lineNeutralSecondary)
        } else if active {
            return (customActiveColor ?? .semantic(.surfaceBrandPrimary)).opacity(.opacity28)
        } else {
            return .semantic(.lineNeutralSecondary)
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
        case .medium: return .label2
        case .small: return .caption1
        case .xsmall: return .caption2
        }
    }

    var contentPadding: EdgeInsets {
        switch size {
        case .large: return EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 10)
        case .medium: return EdgeInsets(top: 9, leading: 10, bottom: 9, trailing: 8)
        case .small: return EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 6)
        case .xsmall: return EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 4)
        }
    }

    var textPadding: CGFloat { 2 }

    var cornerRadius: CGFloat {
        switch size {
        case .large: return 12.0
        case .medium: return 10.0
        case .small: return 10.0
        case .xsmall: return 8.0
        }
    }
}
