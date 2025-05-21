//
//  Action.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import Pretendard
import SwiftUI

/// 액션 칩 컴포넌트입니다.
///
/// 텍스트와 이미지를 포함하는 칩 형태의 버튼입니다.
/// 다양한 크기와 스타일을 지원하며, 탭 이벤트를 처리할 수 있습니다.
///
/// ```swift
/// ActionChip(
///     variant: .solid,
///     size: .medium,
///     text: "액션"
/// )
/// .backgroundColor(.semantic(.primary))
/// .fontColor(.semantic(.staticWhite))
/// .leadingImage(Image(systemName: "heart"))
/// ```
///
/// - Note: 기본적으로 8pt의 패딩과 12pt의 모서리 반경을 가집니다.
public struct ActionChip: View {
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
    
    // MARK: - Properties
    
    public let variant: Variant
    public let size: Size
    public let text: String
    public let handler: (() -> Void)?
            
    // MARK: - Initializer
    
    /// 액션 칩을 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 칩의 외관 스타일, 기본값은 `.solid`
    ///   - size: 칩의 크기, 기본값은 `.medium`
    ///   - text: 칩에 표시할 텍스트
    ///   - handler: 칩 클릭 시 실행할 핸들러, 기본값은 `nil`
    /// - Returns: 구성된 액션 칩 인스턴스
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
    
    @State private var isPressed = false
    
    public var body: some View {
        HStack(spacing: contentSpacing) {
            if let leadingImage = leadingImage {
                leadingImage
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(imageColor)
            }
            
            Text(text)
                .montage(variant: typoVariant, weight: .medium, color: fontColor)
                .padding(.horizontal, textPadding)
            
            if let trailingImage = trailingImage {
                trailingImage
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(imageColor)
            }
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
                .stroke(borderColor, lineWidth: currentBorderWidth)
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
        .modifier(PressActionDetectingModifier(isPressed: $isPressed) {
            handler?()
        })
        .disabled(disable)
    }
    
    // MARK: - Modifiers
    
    private var disable = false
    private var active = false
    private var customBackgroundColor: SwiftUI.Color?
    private var customFontColor: SwiftUI.Color?
    private var customActiveColor: SwiftUI.Color?
    private var customImageColor: SwiftUI.Color?
    private var leadingImage: Image?
    private var trailingImage: Image?
    private var fillHorizontal = false
    private var fillVertical = false
    
    /// 칩의 비활성화 여부를 설정합니다.
    ///
    /// - Parameter disable: 비활성화 여부
    /// - Returns: 수정된 칩 인스턴스
    public func disabled(_ disable: Bool = true) -> Self {
        var view = self
        view.disable = disable
        return view
    }
    
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
    
    /// 이미지의 색상을 설정합니다.
    ///
    /// - Parameter color: 이미지에 적용할 색상
    /// - Returns: 수정된 칩 인스턴스
    /// - Note: 기본값은 `.semantic(.labelAlternative)`입니다.
    public func imageColor(_ color: SwiftUI.Color) -> Self {
        var view = self
        view.customImageColor = color
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

private extension ActionChip {
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
    
    var imageColor: SwiftUI.Color {
        if disable {
            return .semantic(.labelDisable)
        } else if active {
            return activeContentColor
        } else {
            return customImageColor ?? .semantic(.labelAlternative)
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
    
    var currentBorderWidth: CGFloat {
        variant == .outlined ? 1 : 0
    }
    
    var imageSize: CGFloat {
        switch size {
        case .large: return 16
        case .medium: return 14
        case .small: return 14
        case .xsmall: return 12
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .large: return .body2
        case .medium: return .label1
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
        case .large: return 3
        case .medium: return 3
        case .small: return 2
        case .xsmall: return 2
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
        case .medium: return 8.0
        case .small: return 8.0
        case .xsmall: return 6.0
        }
    }
}
