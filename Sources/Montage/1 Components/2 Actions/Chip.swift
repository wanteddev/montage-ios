//
//  Chip.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import SwiftUI

/// 칩 컴포넌트입니다.
///
/// 텍스트와 이미지를 포함하는 칩 형태의 버튼입니다.
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
/// .leadingImage(Image(systemName: "heart"))
///
/// // 비활성화
/// Chip(text: "필터")
///     .disabled(true)
/// ```
///
/// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
/// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
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
        .opacity(isDisabled ? 0.5 : 1.0)
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

    /// 칩의 내용 영역입니다. `iconOnly` 여부에 따라 아이콘 전용 정사각 뷰 또는 기본 뷰를 반환합니다.
    @ViewBuilder
    private var content: some View {
        if iconOnly {
            iconOnlyContent
        } else {
            defaultContent
        }
    }

    /// `iconOnly`일 때 표시하는 아이콘 전용 정사각 뷰입니다.
    @ViewBuilder
    private var iconOnlyContent: some View {
        if let image = leadingImage ?? trailingImage {
            image
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .foregroundStyle(imageColor)
                .frame(width: iconOnlySize, height: iconOnlySize)
        }
    }

    /// 기본(텍스트 + 선택적 아이콘) 내용 뷰입니다.
    private var defaultContent: some View {
        HStack(spacing: contentSpacing) {
            if let leadingImage {
                leadingImage
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(imageColor)
            }

            Text(text)
                .paragraph(variant: typoVariant, weight: .medium, color: fontColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, textPadding)

            if let trailingImage {
                trailingImage
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(imageColor)
            }
        }
        .padding(contentPadding)
    }

    // MARK: - Modifiers

    private var active = false
    private var iconOnly = false
    private var customBackgroundColor: SwiftUI.Color?
    private var customFontColor: SwiftUI.Color?
    private var customActiveColor: SwiftUI.Color?
    private var customImageColor: SwiftUI.Color?
    private var customBorderColor: SwiftUI.Color?
    private var leadingImage: Image?
    private var trailingImage: Image?
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

    /// 아이콘만 표시하는 정사각 형태 여부를 설정합니다.
    ///
    /// `true`이면 텍스트 없이 `leadingImage`(없으면 `trailingImage`)만 너비와 높이가 같은
    /// 정사각 형태로 중앙 정렬해 표시합니다. 표시할 이미지는 `leadingImage(_:)` 또는
    /// `trailingImage(_:)`로 지정합니다.
    ///
    /// - Parameter iconOnly: 아이콘 전용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 칩 인스턴스
    public func iconOnly(_ iconOnly: Bool = true) -> Self {
        var view = self
        view.iconOnly = iconOnly
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
    
    /// 이미지의 색상을 설정합니다.
    ///
    /// - Parameter color: 이미지에 적용할 색상
    /// - Returns: 수정된 칩 인스턴스
    public func imageColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customImageColor = color
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

    /// 칩의 좌측에 이미지를 추가합니다.
    ///
    /// - Parameter image: 표시할 이미지
    /// - Returns: 수정된 칩 인스턴스
    public func leadingImage(_ image: Image) -> Self {
        var view = self
        view.leadingImage = image
        return view
    }
    
    /// 칩의 우측에 이미지를 추가합니다.
    ///
    /// - Parameter image: 표시할 이미지
    /// - Returns: 수정된 칩 인스턴스
    public func trailingImage(_ image: Image) -> Self {
        var view = self
        view.trailingImage = image
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
    
    var imageColor: SwiftUI.Color {
        if isDisabled {
            return .semantic(.foregroundDisablePrimary)
        } else if active {
            return activeContentColor
        } else {
            return customImageColor ?? .semantic(.foregroundNeutralPrimary)
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
            return (customActiveColor ?? .semantic(.surfaceBrandPrimary)).opacity(0.28)
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
    
    var imageSize: CGFloat {
        switch size {
        case .large: return 16
        case .medium: return 14
        case .small: return 14
        case .xsmall: return 12
        }
    }

    /// `iconOnly`일 때 사용하는 정사각 한 변의 길이입니다(칩 높이와 동일).
    var iconOnlySize: CGFloat {
        switch size {
        case .large: return 40
        case .medium: return 36
        case .small: return 32
        case .xsmall: return 24
        }
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
