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
/// 작은 점 또는 임의의 문자열(숫자·"N" 등)을 표시할 수 있으며 다양한 크기와 위치를 지원합니다.
/// 주로 아이콘이나 버튼 주변에 새로운 알림이나 메시지가 있음을 나타내기 위해 사용됩니다.
///
/// ```swift
/// // 기본 점 형태 뱃지
/// PushBadge(variant: .dot)
///
/// // 문자열 표시 뱃지
/// PushBadge(variant: .text("N"))
///     .size(.small)
///
/// // 최대치 표기 뱃지 (99 초과 시 "99+")
/// PushBadge(variant: .maxCount(150))
///     .backgroundColor(.red)
///
/// // 배경과 분리하는 아웃라인 보더 적용 (아바타 등 겹침 배경에서 사용)
/// PushBadge(variant: .dot)
///     .outlineBorder()
/// ```
public struct PushBadge: View {
    // MARK: - Types

    /// 뱃지의 표시 형태를 정의하는 열거형입니다.
    public enum Variant: Equatable {
        /// 작은 점 형태의 뱃지
        case dot
        /// 임의의 문자열을 표시하는 뱃지
        /// - Parameter text: 표시할 문자열
        case text(_ text: String)
        /// 최대치를 적용해 숫자를 표시하는 뱃지
        /// - Parameters:
        ///   - count: 표시할 숫자
        ///   - max: 표기 상한, 생략하면 기본값으로 `99` 적용. `count`가 `max`를 초과하면 `"{max}+"`로 표시
        case maxCount(_ count: Int, max: Int = 99)
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
        /// - Parameter horizontalPosition: 수평 위치, 생략하면 기본값으로 `.center` 적용
        case top(_ horizontalPosition: HorizontalPosition = .center)
        
        /// 중앙 위치
        /// - Parameter horizontalPosition: 수평 위치, 생략하면 기본값으로 `.center` 적용
        case center(_ horizontalPosition: HorizontalPosition = .center)
        
        /// 하단 위치
        /// - Parameter horizontalPosition: 수평 위치, 생략하면 기본값으로 `.center` 적용
        case bottom(_ horizontalPosition: HorizontalPosition = .center)
        
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
    /// - Parameter variant: 뱃지의 표시 형태 (dot, text, maxCount)
    public init(variant: Variant) {
        self.variant = variant
    }
    
    // MARK: - Body
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        Group {
            switch variant {
            case .dot:
                Circle()
                    .frame(width: dotSize.width, height: dotSize.height)
                    .foregroundColor(backgroundColor)
                    .padding(outlineBorder ? (dotOutlineSize - dotSize.width) / 2 : 0)
                    .background {
                        if outlineBorder {
                            Circle().foregroundColor(outlineBorderColor)
                        }
                    }
            case .text(let text):
                textBadge(text)
            case .maxCount(let count, let max):
                textBadge(count > max ? "\(max)+" : "\(count)")
            }
        }
    }

    /// 문자열 뱃지(text·maxCount 공용) 본문을 구성합니다.
    @ViewBuilder
    private func textBadge(_ text: String) -> some View {
        Text(text)
            .font(font)
            .frame(minWidth: textMinSize.width)
            .frame(height: textMinSize.height)
            .foregroundStyle(fontColor)
            .padding(fontPadding)
            .background {
                RoundedRectangle(cornerRadius: .radiusFull)
                    .foregroundColor(backgroundColor)
            }
            .padding(outlineBorder ? textOutlineGap : 0)
            .background {
                if outlineBorder {
                    RoundedRectangle(cornerRadius: .radiusFull)
                        .foregroundColor(outlineBorderColor)
                }
            }
    }
    
    // MARK: - Modifiers
    private var size: Size = .xsmall
    private var fontColor: SwiftUI.Color = .semantic(.staticWhite)
    private var backgroundColor: SwiftUI.Color = .semantic(.surfaceBrandPrimary)
    private var outlineBorder = false
    private var outlineBorderColor: SwiftUI.Color = .semantic(.backgroundNeutralPrimary)
    
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

    /// 배경과 뱃지를 분리하는 아웃라인 보더를 설정합니다.
    ///
    /// 아바타 등 겹치는 배경 위에 뱃지를 얹을 때, 뱃지 주위에 배경색 테두리를 그려 시각적으로 분리합니다.
    /// 이 모디파이어를 호출하지 않으면 off이고, 인자 없이 호출하면 on이 됩니다.
    /// 테두리와 뱃지 사이 간격은 크기·형태별로 상이합니다.
    ///
    /// - Parameters:
    ///   - outlineBorder: 아웃라인 보더 표시 여부, 생략하면 기본값으로 `true` 적용
    ///   - color: 아웃라인 보더 색상, 생략하면 기본값으로 `.semantic(.backgroundNeutralPrimary)` 적용
    /// - Returns: 아웃라인 보더가 설정된 PushBadge
    public func outlineBorder(_ outlineBorder: Bool = true, color: SwiftUI.Color = .semantic(.backgroundNeutralPrimary)) -> Self {
        var zelf = self
        zelf.outlineBorder = outlineBorder
        zelf.outlineBorderColor = color
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

    /// dot 뱃지의 아웃라인 보더(원) 지름. dot을 뒤에서 감싸 배경과 분리한다.
    ///
    /// dot 지름(4/6/8)보다 크게 두어 상하좌우로 테두리가 드러나게 한다.
    /// (small은 dot과 동일한 6이면 테두리가 가려지므로 medium과 같은 1pt 간격 규칙에 맞춰 8로 둔다.)
    var dotOutlineSize: CGFloat {
        switch size {
        case .xsmall: 5
        case .small: 8
        case .medium: 10
        }
    }

    /// text·maxCount 뱃지의 아웃라인 보더 여백(뱃지 상하좌우로 이 값만큼 테두리가 확장된다).
    var textOutlineGap: CGFloat {
        switch size {
        case .xsmall: 1
        case .small: 1.5
        case .medium: 2
        }
    }
}

extension PushBadge {
    struct Modifier: ViewModifier {
        private let variant: Variant
        private let size: Size
        private let fontColor: SwiftUI.Color
        private let backgroundColor: SwiftUI.Color
        private let outlineBorder: Bool
        private let outlineBorderColor: SwiftUI.Color
        private let position: Position
        private let inset: CGSize

        init(
            variant: Variant = .dot,
            size: Size = .xsmall,
            fontColor: SwiftUI.Color = .semantic(.staticWhite),
            backgroundColor: SwiftUI.Color = .semantic(.surfaceBrandPrimary),
            outlineBorder: Bool = false,
            outlineBorderColor: SwiftUI.Color = .semantic(.backgroundNeutralPrimary),
            position: Position = .top(.trailing),
            inset: CGSize = .zero
        ) {
            self.variant = variant
            self.size = size
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
            self.outlineBorder = outlineBorder
            self.outlineBorderColor = outlineBorderColor
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
                    .outlineBorder(outlineBorder, color: outlineBorderColor)
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
                case .leading: inset.width
                case .center: CGFloat.zero
                case .trailing: -inset.width
                }
            }
            let height = switch position {
            case .top: inset.height
            case .center: CGFloat.zero
            case .bottom: -inset.height
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
    ///   - variant: 뱃지의 표시 형태, 생략하면 기본값으로 `.dot` 적용
    ///   - size: 뱃지 크기, 생략하면 기본값으로 `.xsmall` 적용
    ///   - fontColor: 텍스트 색상, 생략하면 기본값으로 `.semantic(.staticWhite)` 적용
    ///   - backgroundColor: 배경 색상, 생략하면 기본값으로 `.semantic(.surfaceBrandPrimary)` 적용
    ///   - outlineBorder: 배경과 분리하는 아웃라인 보더 표시 여부, 생략하면 기본값으로 `false` 적용
    ///   - outlineBorderColor: 아웃라인 보더 색상, 생략하면 기본값으로 `.semantic(.backgroundNeutralPrimary)` 적용
    ///   - position: 뱃지 위치, 생략하면 기본값으로 `.top(.trailing)` 적용
    ///   - inset: 부착 위치를 대상 안쪽으로 들이는 여백, 생략하면 기본값으로 `.zero` 적용
    /// - Returns: 뱃지가 적용된 뷰
    ///
    /// ```swift
    /// Button("메시지") { }
    ///     .pushBadge(variant: .maxCount(3), position: .top(.leading))
    ///
    /// Image.icon(.bell)
    ///     .pushBadge()  // 기본값: 우측 상단에 빨간 점
    /// ```
    public func pushBadge(
        variant: PushBadge.Variant = .dot,
        size: PushBadge.Size = .xsmall,
        fontColor: SwiftUI.Color = .semantic(.staticWhite),
        backgroundColor: SwiftUI.Color = .semantic(.surfaceBrandPrimary),
        outlineBorder: Bool = false,
        outlineBorderColor: SwiftUI.Color = .semantic(.backgroundNeutralPrimary),
        position: PushBadge.Position = .top(.trailing),
        inset: CGSize = .zero
    ) -> some View {
        modifier(
            PushBadge.Modifier(
                variant: variant,
                size: size,
                fontColor: fontColor,
                backgroundColor: backgroundColor,
                outlineBorder: outlineBorder,
                outlineBorderColor: outlineBorderColor,
                position: position,
                inset: inset
            )
        )
    }
}
