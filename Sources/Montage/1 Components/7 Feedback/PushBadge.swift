//
//  PushBadge.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/26.
//

import Pretendard
import SwiftUI

/// 푸시 알림이나 알림 표시를 위한 뱃지 컴포넌트입니다.
///
/// 작은 점, 'N' 표시, 또는 숫자를 표시할 수 있으며 다양한 크기와 위치를 지원합니다.
/// 주로 아이콘이나 버튼 주변에 새로운 알림이나 메시지가 있음을 나타내기 위해 사용됩니다.
///
/// ```swift
/// // 기본 점 형태 뱃지
/// PushBadge(variant: .dot)
///
/// // 'N' 표시 뱃지
/// PushBadge(variant: .new)
///     .size(.small)
///
/// // 숫자 표시 뱃지
/// PushBadge(variant: .number(5))
///     .backgroundColor(.red)
/// ```
public struct PushBadge: View {
    // MARK: - Types
    
    /// 뱃지의 표시 형태를 정의하는 열거형입니다.
    public enum Variant: Equatable {
        /// 작은 점 형태의 뱃지
        case dot
        /// 'N' 문자를 표시하는 뱃지
        case new
        /// 특정 숫자를 표시하는 뱃지
        case number(Int)
    }
    
    /// 뱃지의 크기를 정의하는 열거형입니다.
    public enum Size {
        /// 가장 작은 크기
        case xsmall
        /// 중간 크기
        case small
        /// 큰 크기
        case medium
    }
    
    /// 뱃지의 위치를 정의하는 열거형입니다.
    ///
    /// 수직 위치(top, center, bottom)와 수평 위치(leading, center, trailing)를 함께 지정할 수 있습니다.
    ///
    /// ```swift
    /// // 우측 상단에 위치
    /// someView.pushBadge(position: .top(.trailing))
    /// 
    /// // 좌측 하단에 위치
    /// someView.pushBadge(position: .bottom(.leading))
    /// ```
    public enum Position {
        /// 상단 위치
        /// - Parameter horizontalPosition: 수평 위치 (기본값: center)
        case top(HorizontalPosition = .center)
        
        /// 중앙 위치
        /// - Parameter horizontalPosition: 수평 위치 (기본값: center)
        case center(HorizontalPosition = .center)
        
        /// 하단 위치
        /// - Parameter horizontalPosition: 수평 위치 (기본값: center)
        case bottom(HorizontalPosition = .center)
        
        /// 수평 위치를 정의하는 열거형입니다.
        public enum HorizontalPosition {
            /// 좌측 정렬
            case leading
            /// 중앙 정렬
            case center
            /// 우측 정렬
            case trailing
        }
    }
    
    // MARK: - Initializer
    
    private let variant: Variant
    
    /// PushBadge를 초기화합니다.
    ///
    /// - Parameter variant: 뱃지의 표시 형태 (dot, new, number)
    public init(variant: Variant) {
        self.variant = variant
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch variant {
            case .dot:
                Circle()
                    .frame(width: dotSize.width, height: dotSize.height)
                    .foregroundColor(backgroundColor)
            case .new:
                Text("N")
                    .font(font)
                    .frame(minWidth: textMinSize.width)
                    .frame(height: textMinSize.height)
                    .foregroundStyle(fontColor)
                    .padding(fontPadding)
                    .background {
                        Circle()
                            .foregroundColor(backgroundColor)
                    }
            case .number(let number):
                Text("\(number)")
                    .font(font)
                    .frame(minWidth: textMinSize.width)
                    .frame(height: textMinSize.height)
                    .foregroundStyle(fontColor)
                    .padding(fontPadding)
                    .background {
                        RoundedRectangle(cornerRadius: 1000)
                            .foregroundColor(backgroundColor)
                    }
            }
        }
    }
    
    // MARK: - Modifiers
    private var size: Size = .xsmall
    private var fontColor: SwiftUI.Color = .semantic(.staticWhite)
    private var backgroundColor: SwiftUI.Color = .semantic(.primaryNormal)
    
    /// 뱃지의 크기를 설정합니다.
    ///
    /// - Parameter size: 뱃지 크기
    /// - Returns: 크기가 변경된 PushBadge
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 텍스트 색상을 설정합니다.
    ///
    /// - Parameter color: 텍스트 색상
    /// - Returns: 텍스트 색상이 변경된 PushBadge
    public func fontColor(_ color: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.fontColor = color
        return zelf
    }
    
    /// 배경 색상을 설정합니다.
    ///
    /// - Parameter color: 배경 색상
    /// - Returns: 배경 색상이 변경된 PushBadge
    public func backgroundColor(_ color: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.backgroundColor = color
        return zelf
    }
}

private extension PushBadge {
    var font: Font? {
        switch size {
        case .xsmall, .small: .font(variant: .caption2, weight: .bold)
        case .medium: .font(variant: .label1, weight: .bold)
        }
    }
    
    var fontPadding: EdgeInsets {
        switch size {
        case .xsmall: .init(top: 1, leading: 4, bottom: 1, trailing: 4)
        case .small: .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        case .medium: .init(top: 2, leading: 7, bottom: 2, trailing: 7)
        }
    }
    
    var dotSize: CGSize {
        switch size {
        case .xsmall: .init(width: 4, height: 4)
        case .small: .init(width: 6, height: 6)
        case .medium: .init(width: 8, height: 8)
        }
    }
    
    var textMinSize: CGSize {
        switch size {
        case .xsmall: .init(width: 8, height: 14)
        case .small: .init(width: 8, height: 14)
        case .medium: .init(width: 10, height: 20)
        }
    }
}

extension PushBadge {
    struct Modifier: ViewModifier {
        private let variant: Variant
        private let size: Size
        private let fontColor: SwiftUI.Color
        private let backgroundColor: SwiftUI.Color
        private let position: Position
        private let inset: CGSize
        
        init(
            variant: Variant = .dot,
            size: Size = .xsmall,
            fontColor: SwiftUI.Color = .semantic(.staticWhite),
            backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
            position: Position = .top(.trailing),
            inset: CGSize = .zero
        ) {
            self.variant = variant
            self.size = size
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
            self.position = position
            self.inset = inset
        }
        
        @State private var contentSize: CGSize = .zero

        func body(content: Content) -> some View {
            ZStack {
                content
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: {
                        contentSize = $0
                    })
                PushBadge(variant: variant)
                    .size(size)
                    .fontColor(fontColor)
                    .backgroundColor(backgroundColor)
                    .offset(anchorPosition)
                    .offset(offset)
            }
        }
        
        private var anchorPosition: CGSize {
            let width = switch position {
            case .top(let horizontalAlignment),
                    .center(let horizontalAlignment),
                    .bottom(let horizontalAlignment):
                switch horizontalAlignment {
                case .leading: -contentSize.width / 2
                case .center: CGFloat.zero
                case .trailing: contentSize.width / 2
                }
            }
            let height = switch position {
            case .top: -contentSize.height / 2
            case .center: CGFloat.zero
            case .bottom: contentSize.height / 2
            }
            return .init(width: width, height: height)
        }
        
        private var offset: CGSize {
            let width = switch position {
            case .top(let horizontalAlignment),
                    .center(let horizontalAlignment),
                    .bottom(let horizontalAlignment):
                switch horizontalAlignment {
                case .leading: inset.width / 2
                case .center: CGFloat.zero
                case .trailing: -inset.width / 2
                }
            }
            let height = switch position {
            case .top: inset.height / 2
            case .center: CGFloat.zero
            case .bottom: -inset.height / 2
            }
            return .init(width: width, height: height)
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 푸시 알림 뱃지를 표시합니다.
    ///
    /// 뷰의 특정 위치에 알림 또는 메시지 표시용 뱃지를 추가합니다.
    ///
    /// - Parameters:
    ///   - variant: 뱃지의 표시 형태 (기본값: .dot)
    ///   - size: 뱃지 크기 (기본값: .xsmall)
    ///   - fontColor: 텍스트 색상 (기본값: staticWhite)
    ///   - backgroundColor: 배경 색상 (기본값: primaryNormal)
    ///   - position: 뱃지 위치 (기본값: .top(.trailing))
    ///   - inset: 위치 조정을 위한 여백 (기본값: .zero)
    /// - Returns: 뱃지가 적용된 뷰
    ///
    /// ```swift
    /// Button("메시지") { }
    ///     .pushBadge(variant: .number(3), position: .top(.leading))
    ///
    /// Image.icon(.bell)
    ///     .pushBadge()  // 기본값: 우측 상단에 빨간 점
    /// ```
    public func pushBadge(
        variant: PushBadge.Variant = .dot,
        size: PushBadge.Size = .xsmall,
        fontColor: SwiftUI.Color = .semantic(.staticWhite),
        backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
        position: PushBadge.Position = .top(.trailing),
        inset: CGSize = .zero
    ) -> some View {
        modifier(
            PushBadge.Modifier(
                variant: variant,
                size: size,
                fontColor: fontColor,
                backgroundColor: backgroundColor,
                position: position,
                inset: inset
            )
        )
    }
}
