//
//  Cell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

/// 텍스트와 콘텐츠를 포함하는 리스트 아이템 컴포넌트입니다.
///
/// `Cell`은 앱 내에서 리스트 형태로 정보를 표시할 때 사용되는 기본 컴포넌트입니다.
/// 타이틀, 부가 설명, 좌측 콘텐츠, 우측 콘텐츠 등을 포함할 수 있으며 다양한 스타일로 커스터마이징할 수 있습니다.
///
/// ```swift
/// // 기본 셀
/// Cell(title: "기본 셀")
///
/// // 추가 설명이 있는 셀
/// Cell(title: "설명이 있는 셀")
///     .caption("부가 설명 텍스트")
///
/// // 리딩 콘텐츠와 액티브 상태의 셀
/// Cell(title: "커스텀 셀")
///     .leadingContent {
///         Image.icon(.user)
///             .frame(width: 24, height: 24)
///     }
///     .active(true)
///     .chevron(true)
///     .onTap {
///         print("셀이 탭되었습니다")
///     }
/// ```
///
/// - Note: `Cell`은 인터랙션 효과, 구분선, 강조 표시 등 다양한 시각적 요소를 지원합니다.
public struct Cell: View {
    // MARK: - Types
    /// 상하 여백을 나타내는 열거형입니다.
    ///
    /// 셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.
    ///
    /// ```swift
    /// Cell(title: "넓은 여백이 있는 셀")
    ///     .verticalPadding(.large)
    /// ```
    public enum VerticalPadding {
        /// 여백 없음 (0pt)
        case none
        /// 작은 여백 (8pt)
        case small
        /// 중간 여백 (12pt)
        case medium
        /// 큰 여백 (16pt)
        case large
        
        var length: CGFloat {
            switch self {
            case .none: 0
            case .small: 8
            case .medium: 12
            case .large: 16
            }
        }
    }
    
    // MARK: - Initializer
    
    private let title: String
    private let onTap: (() -> Void)?
    
    /// 셀 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - title: 셀에 표시할 제목 텍스트
    ///   - onTap: 셀을 탭했을 때 실행할 클로저
    public init(
        title: String,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.onTap = onTap
    }
    
    // MARK: - Body
    @State private var isPressed = false
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                HStack(alignment: verticalAlignment, spacing: 8) {
                    if let leadingContent {
                        AnyView(leadingContent())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            titleView
                        }
                        .frame(minHeight: 24)
                        .if(textEllipsis) {
                            $0.lineLimit(2)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let caption {
                            Text(caption)
                                .paragraph(
                                    variant: .label2,
                                    semantic: .labelAlternative
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if let trailingContent {
                        AnyView(trailingContent(active))
                    }
                    
                    VStack {
                        Image.icon(.chevronRightTightSmall)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                            .frame(width: 8, height: 16)
                            .padding(.vertical, 4)
                    }
                    .frame(maxHeight: .infinity)
                    .if(chevron)
                }
            }
            .padding(.vertical, verticalPadding.length)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.semantic(.lineAlternative))
                .background()
                .if(divider)
        }
        .padding(.horizontal, fillWidth ? 20 : 0)
        .modifier(CellInteractionModifier(
            pressed: $isPressed,
            fillWidth: fillWidth,
            interactionPadding: interactionPadding
        ))
        .contentShape(Rectangle())
        .allowsHitTesting(disable == false)
        .opacity(disable ? 0.43 : 1)
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: onTap))
    }
    
    // MARK: - Modifiers
    
    private var titleTypography: (variant: Typography.Variant, weight: Typography.Weight, color: Color.Semantic) = (.body1, .regular, .labelNormal)
    private var verticalPadding: VerticalPadding = .medium
    private var fillWidth = false
    private var textEllipsis = false
    private var caption: String? = nil
    private var disable = false
    private var active = false
    private var divider = false
    private var chevron = false
    private var leadingContent: (() -> any View)? = nil
    private var trailingContent: ((Bool) -> any View)? = nil
    private var interactionPadding: CGFloat = 12
    private var verticalAlignment: VerticalAlignment = .top
    private var highlightText: String? = nil
    
    /// 타이틀 텍스트의 `variant` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - variant: 적용할 Typography 변형 스타일
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `.body1`입니다.
    public func titleVariant(_ variant: Typography.Variant) -> Self {
        var zelf = self
        zelf.titleTypography.variant = variant
        return zelf
    }
    
    /// 타이틀 텍스트의 `weight` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - weight: 적용할 텍스트 두께
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `.regular`입니다.
    public func titleWeight(_ weight: Typography.Weight) -> Self {
        var zelf = self
        zelf.titleTypography.weight = weight
        return zelf
    }
    
    /// 타이틀 텍스트의 `color` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - color: 적용할 텍스트 색상
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `.labelNormal`입니다.
    public func titleColor(_ color: Color.Semantic) -> Self {
        var zelf = self
        zelf.titleTypography.color = color
        return zelf
    }
    
    /// 상하 여백의 크기를 조정합니다.
    ///
    /// - Parameters:
    ///   - verticalPadding: 적용할 상하 여백 크기
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `.medium` 입니다.
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 셀 내 콘텐츠의 수직 정렬을 조정합니다.
    ///
    /// - Parameters:
    ///   - verticalAlignment: 적용할 수직 정렬 방식
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `.top`입니다.
    public func verticalAlign(_ verticalAlignment: VerticalAlignment) -> Self {
        var zelf = self
        zelf.verticalAlignment = verticalAlignment
        return zelf
    }
    
    /// 셀의 좌우 여백 사용 여부를 설정합니다.
    ///
    /// `true`로 설정하면 좌우 20포인트의 여백이 적용됩니다.
    ///
    /// - Parameters:
    ///   - fillWidth: 좌우 여백 적용 여부
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func fillWidth(_ fillWidth: Bool = true) -> Self {
        var zelf = self
        zelf.fillWidth = fillWidth
        return zelf
    }
    
    /// 타이틀 텍스트의 생략 처리 여부를 설정합니다.
    ///
    /// `true`로 설정하면 타이틀 텍스트가 2줄로 제한되고, 초과 텍스트는 생략됩니다.
    ///
    /// - Parameters:
    ///   - textEllipsis: 텍스트 생략 처리 여부
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다. `false`인 경우 좌우 콘텐츠는 상단 정렬됩니다.
    public func textEllipsis(_ textEllipsis: Bool = true) -> Self {
        var zelf = self
        zelf.textEllipsis = textEllipsis
        return zelf
    }
    
    /// 셀에 부가 설명(캡션)을 추가합니다.
    ///
    /// 캡션은 타이틀 아래에 작은 글씨로 표시되는 부가 설명 텍스트입니다.
    ///
    /// - Parameters:
    ///   - caption: 표시할 캡션 텍스트 (nil 설정 시 캡션 제거)
    /// - Returns: 수정된 Cell 인스턴스
    public func caption(_ caption: String? = nil) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }
    
    /// 셀의 비활성화 상태를 설정합니다.
    ///
    /// 비활성화된 셀은 탭 이벤트를 받지 않으며, 시각적으로 흐리게 표시됩니다.
    ///
    /// - Parameters:
    ///   - disable: 비활성화 여부
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }

    /// 셀을 활성화 상태로 설정합니다.
    ///
    /// 활성화된 셀은 타이틀 텍스트의 색상이 `primaryNormal`로 변경되고, 텍스트 두께가 medium으로 설정됩니다.
    /// `trailingContent` 클로저의 파라미터로 활성화 상태 여부가 전달됩니다.
    ///
    /// - Parameters:
    ///   - active: 활성화 여부 
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func active(_ active: Bool = true) -> Self {
        var zelf = self
        zelf.active = active
        return zelf
    }
    
    /// 셀 하단에 구분선을 추가합니다.
    ///
    /// - Parameters:
    ///   - divider: 구분선 표시 여부 
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func divider(_ divider: Bool = true) -> Self {
        var zelf = self
        zelf.divider = divider
        return zelf
    }
    
    /// 셀 우측에 화살표(chevron) 아이콘을 추가합니다.
    ///
    /// 주로 탭했을 때 다른 화면으로 이동하는 셀에 사용됩니다.
    ///
    /// - Parameters:
    ///   - chevron: 화살표 표시 여부 
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func chevron(_ chevron: Bool = true) -> Self {
        var zelf = self
        zelf.chevron = chevron
        return zelf
    }
    
    /// 셀 좌측에 추가 콘텐츠를 표시합니다.
    ///
    /// 아이콘, 이미지, 기타 커스텀 뷰 등을 셀 타이틀 앞에 배치할 수 있습니다.
    ///
    /// - Parameters:
    ///   - contents: 표시할 콘텐츠를 생성하는 클로저
    /// - Returns: 수정된 Cell 인스턴스
    public func leadingContent(_ contents: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.leadingContent = contents
        return zelf
    }
    
    /// 셀 우측에 추가 콘텐츠를 표시합니다.
    ///
    /// 배지, 스위치, 토글 등 추가 UI 요소를 셀 타이틀 뒤에 배치할 수 있습니다.
    /// 클로저 파라미터를 통해 셀의 활성화 상태를 전달받을 수 있습니다.
    ///
    /// - Parameters:
    ///   - contents: 표시할 콘텐츠를 생성하는 클로저 (활성화 상태를 파라미터로 받음)
    /// - Returns: 수정된 Cell 인스턴스
    public func trailingContent(_ contents: ((Bool) -> any View)? = nil) -> Self {
        var zelf = self
        zelf.trailingContent = contents
        return zelf
    }
    
    /// 셀의 인터랙션 효과 영역의 좌우 패딩을 조정합니다.
    ///
    /// - Parameters:
    ///   - padding: 적용할 패딩 값 (포인트 단위)
    /// - Returns: 수정된 Cell 인스턴스
    ///
    /// - Note: 기본값은 12입니다.
    public func interactionPadding(_ padding: CGFloat) -> Self {
        var zelf = self
        zelf.interactionPadding = padding
        return zelf
    }
    
    /// 타이틀의 특정 텍스트를 강조 표시합니다.
    ///
    /// 지정한 문자열과 일치하는 부분을 굵은 글씨(bold)로 강조 표시합니다.
    /// 대소문자를 구분하지 않으며, 첫 번째로 일치하는 부분만 강조됩니다.
    ///
    /// - Parameters:
    ///   - text: 강조할 텍스트 문자열
    /// - Returns: 수정된 Cell 인스턴스
    public func highlight(_ text: String) -> Self {
        var zelf = self
        zelf.highlightText = text
        return zelf
    }
}

// MARK: - Private
extension Cell {
    private var normalTitleColor: Color.Semantic {
        if disable {
            .labelAlternative
        } else {
            active ? .primaryNormal : titleTypography.color
        }
    }
    
    private var titleView: some View {
        Group {
            if let highlightText {
                let attributedString: AttributedString = {
                    var string = AttributedString(stringLiteral: title)
                    string.font = .font(variant: titleTypography.variant, weight: active ? .medium : titleTypography.weight)
                    string.foregroundColor = .semantic(normalTitleColor)
                    guard let range = string.range(of: highlightText, options: .caseInsensitive) else {
                        return string
                    }
                    string[range].font = .font(variant: titleTypography.variant, weight: .bold)
                    string[range].foregroundColor = .semantic(normalTitleColor)
                    return string
                }()
                
                Text(attributedString)
                    .tracking(titleTypography.variant.tracking)
                    .adjustLineHeight(variant: titleTypography.variant)
            } else {
                Text(title)
                    .paragraph(
                        variant: titleTypography.variant,
                        weight: active ? .medium : titleTypography.weight,
                        semantic: normalTitleColor
                    )
            }
        }
    }
}
