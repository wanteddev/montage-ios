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
        // 뱃지는 아이콘·아바타 위에 얹히는 오버레이인데 대상은 Dynamic Type으로 커지지 않는다.
        // 접근성 단계까지 확대하면 뱃지가 대상을 덮어버리므로 표준 최대치인 xxxLarge에서 멈춘다.
        // (하위 뷰인 ``TextBadge``의 스케일 계수가 이 제한을 반영하도록 바깥에서 건다.)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }

    /// 문자열 뱃지(text·maxCount 공용) 본문을 구성합니다.
    private func textBadge(_ text: String) -> TextBadge {
        TextBadge(
            text: text,
            size: size,
            fontColor: fontColor,
            backgroundColor: backgroundColor,
            outlineBorder: outlineBorder,
            outlineBorderColor: outlineBorderColor
        )
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

/// text·maxCount 뱃지의 본문.
///
/// 한 글자일 때는 최소 너비 + 좌우 패딩 대신 ``badgeSize`` 정사각형으로 고정한다. 글자 폭이
/// 최소 너비를 넘으면(한글 한 글자, `M`, `W` 등) 뱃지가 그만큼 늘어나 디자인 스펙인 정원에서
/// 벗어나기 때문이다.
///
/// ``PushBadge``가 아닌 별도 뷰로 분리한 이유는 Dynamic Type 제한 때문이다. `@ScaledMetric`은
/// 선언된 뷰가 물려받은 환경으로 값이 정해지므로, 같은 뷰의 body에서 `dynamicTypeSize(_:)`를
/// 걸면 폰트에만 적용되고 배율에는 반영되지 않아 글자와 상자가 어긋난다.
private struct TextBadge: View {
    let text: String
    let size: PushBadge.Size
    let fontColor: SwiftUI.Color
    let backgroundColor: SwiftUI.Color
    let outlineBorder: Bool
    let outlineBorderColor: SwiftUI.Color

    /// 뱃지 크기를 폰트와 같은 배율로 키우기 위한 스케일 계수.
    ///
    /// 폰트는 ``Typography/Variant/textStyle`` 기준으로 스케일되는데 뱃지 크기·패딩이 고정값이면
    /// 큰 글자에서 텍스트가 잘리거나 정원이 캡슐로 늘어난다. ``size``에 따라 쓰는 텍스트 스타일이
    /// 다르므로 두 배율을 모두 선언해두고 ``typeScale``에서 골라 쓴다.
    @ScaledMetric(relativeTo: .caption2) private var captionScale: CGFloat = 1
    @ScaledMetric(relativeTo: .footnote) private var footnoteScale: CGFloat = 1

    var body: some View {
        // 빈 문자열도 정사각형으로 처리해 폭이 0에 가까운 조각 뱃지가 생기지 않게 한다.
        let isSingleCharacter = text.count <= 1
        let scaledBadgeSize = badgeSize * typeScale

        Text(text)
            .typography(variant: typographyVariant, weight: .bold, color: fontColor)
            .frame(minWidth: isSingleCharacter ? scaledBadgeSize : textMinSize.width * typeScale)
            .frame(height: isSingleCharacter ? scaledBadgeSize : textMinSize.height * typeScale)
            .padding(isSingleCharacter ? EdgeInsets() : scaledFontPadding)
            .background {
                RoundedRectangle(cornerRadius: .radiusFull)
                    .foregroundColor(backgroundColor)
            }
            .padding(outlineBorder ? textOutlineGap * typeScale : 0)
            .background {
                if outlineBorder {
                    RoundedRectangle(cornerRadius: .radiusFull)
                        .foregroundColor(outlineBorderColor)
                }
            }
    }

    /// 뱃지 문자열에 적용할 타이포그래피 변형. 폰트와 자간이 여기서 함께 결정된다.
    private var typographyVariant: Typography.Variant {
        switch size {
        case .xsmall, .small: .caption2
        case .medium: .label1
        }
    }

    /// ``typographyVariant``의 텍스트 스타일에 대응하는 Dynamic Type 배율.
    private var typeScale: CGFloat {
        switch size {
        case .xsmall, .small: captionScale
        case .medium: footnoteScale
        }
    }

    /// 뱃지의 전체 크기(한 글자일 때의 정사각 한 변).
    ///
    /// 두 글자 이상일 때의 높이(``textMinSize``의 height + ``fontPadding`` 상하)와 같은 값이다.
    private var badgeSize: CGFloat {
        switch size {
        case .xsmall: 16
        case .small: 20
        case .medium: 24
        }
    }

    private var fontPadding: EdgeInsets {
        switch size {
        case .xsmall: .init(top: 1, leading: 4, bottom: 1, trailing: 4)
        case .small: .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        case .medium: .init(top: 2, leading: 7, bottom: 2, trailing: 7)
        }
    }

    /// Dynamic Type 배율을 적용한 ``fontPadding``.
    private var scaledFontPadding: EdgeInsets {
        let padding = fontPadding
        return .init(
            top: padding.top * typeScale,
            leading: padding.leading * typeScale,
            bottom: padding.bottom * typeScale,
            trailing: padding.trailing * typeScale
        )
    }

    /// 두 글자 이상일 때의 텍스트 영역 최소 크기.
    ///
    /// 한 글자일 때는 이 값 대신 ``badgeSize`` 정사각형을 쓴다.
    private var textMinSize: CGSize {
        switch size {
        case .xsmall: .init(width: 8, height: 14)
        case .small: .init(width: 8, height: 14)
        case .medium: .init(width: 10, height: 20)
        }
    }

    /// 아웃라인 보더 여백(뱃지 상하좌우로 이 값만큼 테두리가 확장된다).
    private var textOutlineGap: CGFloat {
        switch size {
        case .xsmall: 1
        case .small: 1.5
        case .medium: 2
        }
    }
}

private extension PushBadge {
    var dotSize: CGSize {
        switch size {
        case .xsmall: .init(width: 4, height: 4)
        case .small: .init(width: 6, height: 6)
        case .medium: .init(width: 8, height: 8)
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
