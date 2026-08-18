//
//  Chip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import SwiftUI

/// 칩 컴포넌트입니다.
///
/// 텍스트와 콘텐츠를 포함하는 칩 형태의 버튼입니다.
/// 다양한 크기와 스타일을 지원하며, 탭 이벤트를 처리할 수 있습니다.
///
/// ```swift
/// Chip(
///     variant: .solid,
///     size: .medium,
///     text: "액션"
/// )
/// .backgroundColor(.semantic(.surfaceBrandPrimary))
/// .fontColor(.semantic(.staticWhite))
/// .leadingContent {
///     Image.icon(.heart)
///         .resizable()
///         .renderingMode(.template)
///         .frame(width: 14, height: 14)
///         .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralPrimary))
/// }
///
/// // 비활성화
/// Chip(text: "필터")
///     .disabled(true)
/// ```
///
/// ## 콘텐츠 슬롯
///
/// 텍스트 앞뒤에 임의의 뷰를 하나씩 넣을 수 있는 슬롯입니다.
///
/// - ``leadingContent(_:)``: 텍스트 앞
/// - ``trailingContent(_:)``: 텍스트 뒤
///
/// 슬롯 뷰는 가공 없이 그대로 배치되므로 크기와 색상은 사용처에서 정합니다.
/// 시안상 슬롯은 정사각 아이콘 자리이며 권장 크기는 `large` 16, `medium`·`small` 14, `xsmall` 12입니다.
///
/// ```swift
/// Chip(text: "김티드")
///     .leadingContent {
///         Thumbnail(urlString: profileImageURL, ratio: .r1x1)
///             .width(14)
///     }
/// ```
///
/// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
/// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
/// 슬롯 뷰에는 색을 강제하지 않으므로, 비활성 상태의 색 변화가 필요하면 사용처에서 처리합니다.
public struct Chip: View {
    /// 칩의 외관을 결정하는 열거형입니다.
    public enum Variant {
        /// 배경색이 채워진 스타일
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
    
    // MARK: - Properties
    
    private let variant: Variant
    private let size: Size
    private let text: String
    private let handler: (() -> Void)?
            
    // MARK: - Initializer
    
    /// 칩을 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 칩의 외관 스타일, 생략하면 기본값으로 `.solid` 적용
    ///   - size: 칩의 크기, 생략하면 기본값으로 `.medium` 적용
    ///   - text: 칩에 표시할 텍스트
    ///   - handler: 칩 클릭 시 실행할 핸들러, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 구성된 칩 인스턴스
    public init(
        variant: Variant = .solid,
        size: Size = .medium,
        text: String,
        handler: (() -> Void)? = nil
    ) {
        self.variant = variant
        self.size = size
        self.text = text
        self.handler = handler
    }
    
    // MARK: - Body

    @Environment(\.isEnabled) private var isEnabled
    @State private var isPressed = false

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        content
            .frame(
            maxWidth: fillHorizontal ? .infinity : nil,
            maxHeight: fillVertical ? .infinity : nil
        )
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: 0.5)
                .stroke(borderColor, lineWidth: currentBorderWidth)
        )
        .contentShape(Rectangle())
        .background(
            Interaction(
                state: isPressed ? .pressed : .normal,
                variant: interactionVariant,
                color: interactionColor
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(active ? String(localized: "선택됨", bundle: .module) : "")
    }

    /// 칩의 내용 영역입니다(텍스트 + 선택적 슬롯 콘텐츠).
    private var content: some View {
        HStack(spacing: contentSpacing) {
            if let leadingContent {
                leadingContent()
            }

            Text(text)
                .paragraph(variant: typoVariant, weight: .medium, color: fontColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, textPadding)

            if let trailingContent {
                trailingContent()
            }
        }
        .padding(contentPadding)
    }

    // MARK: - Modifiers

    private var active = false
    private var customBackgroundColor: SwiftUI.Color?
    private var customFontColor: SwiftUI.Color?
    private var customActiveColor: SwiftUI.Color?
    private var customBorderColor: SwiftUI.Color?
    private var leadingContent: (() -> AnyView)?
    private var trailingContent: (() -> AnyView)?
    private var fillHorizontal = false
    private var fillVertical = false
    
    /// 칩의 선택 상태를 설정합니다.
    ///
    /// - Parameter active: 선택 상태 여부
    /// - Returns: 수정된 칩 인스턴스
    public func active(_ active: Bool = true) -> Self {
        var view = self
        view.active = active
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
    
    /// 칩의 테두리 색상을 설정합니다.
    ///
    /// > `outlined` variant에서만 적용됩니다. (`solid`는 테두리를 그리지 않습니다.)
    ///
    /// - Parameter color: 적용할 테두리 색상
    /// - Returns: 수정된 칩 인스턴스
    public func borderColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customBorderColor = color
        return view
    }

    /// 텍스트 앞에 표시할 콘텐츠를 지정합니다.
    ///
    /// 슬롯 뷰는 가공 없이 그대로 배치되므로 크기와 색상은 사용처에서 정합니다.
    /// 시안상 권장 크기는 `large` 16, `medium`·`small` 14, `xsmall` 12입니다.
    ///
    /// ```swift
    /// Chip(text: "김티드")
    ///     .leadingContent {
    ///         Image.icon(.bell)
    ///             .resizable()
    ///             .renderingMode(.template)
    ///             .frame(width: 14, height: 14)
    ///             .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralPrimary))
    ///     }
    /// ```
    ///
    /// - Parameter content: 표시할 뷰를 생성하는 클로저
    /// - Returns: 수정된 칩 인스턴스
    ///
    /// - Note: 4.0.0에서 제거된 `leadingImage(_:)`·`imageColor(_:)`를 대체합니다.
    ///   `leadingImage(Image.icon(.bell))`은 이 슬롯에서 아이콘을 직접 구성하는 형태로 옮겨집니다.
    public func leadingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var view = self
        view.leadingContent = { AnyView(content()) }
        return view
    }

    /// 텍스트 뒤에 표시할 콘텐츠를 지정합니다.
    ///
    /// 슬롯 뷰는 가공 없이 그대로 배치되므로 크기와 색상은 사용처에서 정합니다.
    /// 시안상 권장 크기는 `large` 16, `medium`·`small` 14, `xsmall` 12입니다.
    ///
    /// ```swift
    /// Chip(text: "김티드")
    ///     .trailingContent {
    ///         Image.icon(.closeThick)
    ///             .resizable()
    ///             .renderingMode(.template)
    ///             .frame(width: 14, height: 14)
    ///             .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralPrimary))
    ///     }
    /// ```
    ///
    /// - Parameter content: 표시할 뷰를 생성하는 클로저
    /// - Returns: 수정된 칩 인스턴스
    ///
    /// - Note: 4.0.0에서 제거된 `trailingImage(_:)`·`imageColor(_:)`를 대체합니다.
    ///   `trailingImage(Image.icon(.closeThick))`은 이 슬롯에서 아이콘을 직접 구성하는 형태로 옮겨집니다.
    public func trailingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var view = self
        view.trailingContent = { AnyView(content()) }
        return view
    }
}

private extension Chip {
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
            return customBorderColor ?? .semantic(.lineNeutralSecondary)
        }
    }
    
    var currentBorderWidth: CGFloat {
        variant == .outlined ? 1 : 0
    }

    /// 눌림 상태에 적용할 상호작용 강도입니다.
    ///
    /// `solid` 칩의 선택(active) 상태는 기본 강도(`.normal`), 그 외에는 약한 강도(`.light`)를 사용합니다.
    var interactionVariant: Interaction.Variant {
        variant == .solid && active ? .normal : .light
    }
    
    var interactionColor: Color.Semantic {
        variant == .solid && active ? .surfaceBrandPrimary : .foregroundNeutralPrimary
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .large: return .label1
        case .medium: return .label2
        case .small: return .caption1
        case .xsmall: return .caption2
        }
    }
    
    var contentPadding: EdgeInsets {
        switch size {
        case .large: return EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        case .medium: return EdgeInsets(top: 9, leading: 10, bottom: 9, trailing: 10)
        case .small: return EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        case .xsmall: return EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 6)
        }
    }
    
    var contentSpacing: CGFloat {
        switch size {
        case .large: return 2
        case .medium: return 2
        case .small: return 2
        case .xsmall: return 0
        }
    }
    
    var textPadding: CGFloat {
        2.0
    }
    
    var cornerRadius: CGFloat {
        switch size {
        case .large: return 12.0
        case .medium: return 10.0
        case .small: return 10.0
        case .xsmall: return 8.0
        }
    }
}
