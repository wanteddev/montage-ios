//
//  ListCell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

/// 텍스트와 콘텐츠를 포함하는 리스트 아이템 컴포넌트입니다.
///
/// `ListCell`은 앱 내에서 리스트 형태로 정보를 표시할 때 사용되는 기본 컴포넌트입니다.
/// 라벨, 부가 설명과 함께 네 종류의 콘텐츠 슬롯(``leadingResources(_:)``, ``labelTrailingResources(_:)``,
/// ``trailingResources(_:)``, ``extraResources(_:)``)을 제공하며 다양한 스타일로 커스터마이징할 수 있습니다.
///
/// ```swift
/// // 기본 셀
/// ListCell(label: "기본 셀")
///
/// // 추가 설명이 있는 셀
/// ListCell(label: "설명이 있는 셀")
///     .description("부가 설명 텍스트")
///
/// // 리딩 요소와 선택 상태의 셀
/// ListCell(label: "커스텀 셀", onTap: {
///     print("셀이 탭되었습니다")
/// })
/// .leadingResources([.icon(.person)])
/// .selected(true)
/// .chevron(true)
/// ```
///
/// ## 콘텐츠 슬롯
///
/// 네 슬롯은 셀 안에서 각각 다음 위치를 차지하며, 슬롯마다 여러 요소를 나열할 수 있습니다.
/// 슬롯에 넣을 수 있는 요소는 ``Resource``에 슬롯별로 정의되어 있어, 다른 슬롯 전용 요소를 넘기면 컴파일되지 않습니다.
///
/// - ``leadingResources(_:)``: 라벨 앞, 항목 간 간격 8
/// - ``labelTrailingResources(_:)``: 라벨 바로 뒤, 항목 간 간격 4
/// - ``trailingResources(_:)``: 셀 오른쪽 끝, 항목 간 간격 8
/// - ``extraResources(_:)``: 설명 아래, 항목 간 간격 6
///
/// ```swift
/// ListCell(label: "김티드")
///     .description("iOS 개발자")
///     .labelTrailingResources([.contentBadge(title: "신규")])
///     .extraResources([.contentBadge(.outlined, title: "서울")])
///     .trailingResources([.value("값")])
/// ```
///
/// 목록에 없는 구성이 필요하면 각 슬롯 타입의 `slot(_:)` 팩토리로 임의 뷰를 넣을 수 있습니다.
///
/// ```swift
/// ListCell(label: "커스텀")
///     .trailingResources([.slot { MyCustomView() }])
/// ```
///
/// ## 비활성화
///
/// 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다. 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지
/// 함께 비활성 스타일로 표시됩니다. 비활성 셀은 탭 이벤트를 받지 않으며 라벨·설명·콘텐츠 슬롯에
/// `foregroundDisablePrimary` 색상이 적용됩니다.
///
/// ```swift
/// ListCell(label: "비활성 셀")
///     .disabled(true)
/// ```
///
/// - Note: 콘텐츠 슬롯에는 전경색으로 전달되므로, 슬롯 안에서 색상을 직접 지정한 뷰에는 적용되지 않습니다.
public struct ListCell: View {
    // MARK: - Types
    /// 상하 여백을 나타내는 열거형입니다.
    ///
    /// 셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.
    public enum VerticalPadding: Equatable {
        /// 여백 없음
        case none
        /// 작은 여백 (8)
        case small
        /// 중간 여백 (12)
        case medium
        /// 큰 여백 (16)
        case large
        /// 직접 지정한 여백
        ///
        /// 정해진 네 단계로 표현할 수 없는 간격이 필요할 때만 사용합니다.
        case custom(CGFloat)

        var length: CGFloat {
            switch self {
            case .none: 0
            case .small: 8
            case .medium: 12
            case .large: 16
            case .custom(let length): length
            }
        }
    }

    /// 셀 내 콘텐츠의 수직 정렬을 나타내는 열거형입니다.
    public enum VerticalAlign: Equatable {
        /// 첫 행에 맞춰 정렬
        case top
        /// 셀 높이의 중앙에 정렬
        case center

        var alignment: VerticalAlignment {
            switch self {
            case .top: .top
            case .center: .center
            }
        }
    }

    // MARK: - Constants

    /// 행 콘텐츠(leading·라벨·trailing)의 최소 높이입니다.
    private static let rowMinHeight: CGFloat = 24

    /// 라벨 행의 상하 패딩입니다.
    ///
    /// leading·trailing 콘텐츠(22)가 24 컨테이너 안에서 중앙정렬되며 생기는 1pt 오프셋과 맞추기 위한 값으로,
    /// 이 패딩이 없으면 라벨이 2줄 이상일 때 첫 줄과 아이콘이 1pt 어긋납니다.
    /// Spacing 토큰 스케일(전부 짝수)에 없는 값이라 토큰이 아닌 고정값을 사용합니다.
    private static let labelRowPadding: CGFloat = 1

    /// 라벨 행에 들어가는 콘텐츠의 고정 높이입니다.
    private static let labelContentHeight: CGFloat = 22

    /// 선택 상태를 나타내는 체크 아이콘의 크기입니다.
    private static let selectedCheckSize: CGFloat = 22

    // MARK: - Initializer

    private let label: String
    private let onTap: (() -> Void)?

    /// 셀 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - label: 셀에 표시할 제목 텍스트
    ///   - onTap: 셀을 탭했을 때 실행할 클로저, 생략하면 기본값으로 `nil` 적용
    public init(
        label: String,
        onTap: (() -> Void)? = nil
    ) {
        self.label = label
        self.onTap = onTap
    }

    // MARK: - Body
    @Environment(\.isEnabled) private var isEnabled
    @State private var isPressed = false

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .bottom) {
            row
                .padding(.vertical, verticalPadding.length)

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.semantic(.lineNeutralPrimaryOpaque))
                .background()
                .if(divider)
        }
        .if(interactionEnabled) {
            $0.modifier(ListCellInteractionModifier(
                pressed: $isPressed,
                outset: interactionOutset,
                radius: resolvedInteractionRadius
            ))
        }
        .contentShape(Rectangle())
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: onTap))
        .accessibilityElement(children: .combine)
        .if(onTap != nil) { $0.accessibilityAddTraits(.isButton) }
        // 선택 상태는 체크 아이콘으로만 표현되는데 children을 combine하므로
        // 트레이트로 따로 전달하지 않으면 보조 기술이 선택 여부를 알 수 없다.
        .if(selected) { $0.accessibilityAddTraits(.isSelected) }
    }

    // MARK: - Modifiers

    private var labelTypography: (variant: Typography.Variant, weight: Typography.Weight, color: Color.Semantic) = (.body2, .medium, .foregroundNeutralPrimary)
    private var verticalPadding: VerticalPadding = .medium
    private var textEllipsis = false
    private var descriptionText: String? = nil
    private var selected = false
    private var divider = false
    private var chevron = false
    private var leadingResources: [Resource.Leading] = []
    private var labelTrailingResources: [Resource.LabelTrailing] = []
    private var trailingResources: [Resource.Trailing] = []
    private var extraResources: [Resource.Extra] = []
    private var interactionOutset: CGFloat = 12
    private var interactionRadius: CGFloat? = nil
    private var verticalAlignment: VerticalAlign = .top
    private var highlightText: String? = nil

    /// 라벨 텍스트의 `variant` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - variant: 적용할 Typography 변형 스타일
    /// - Returns: 수정된 ListCell 인스턴스
    public func labelVariant(_ variant: Typography.Variant) -> Self {
        var zelf = self
        zelf.labelTypography.variant = variant
        return zelf
    }

    /// 라벨 텍스트의 `weight` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - weight: 적용할 텍스트 두께
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Note: `selected`가 `true`인 셀은 이 값과 무관하게 `bold`로 표시됩니다.
    public func labelWeight(_ weight: Typography.Weight) -> Self {
        var zelf = self
        zelf.labelTypography.weight = weight
        return zelf
    }

    /// 라벨 텍스트의 `color` 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - color: 적용할 텍스트 색상
    /// - Returns: 수정된 ListCell 인스턴스
    public func labelColor(_ color: Color.Semantic) -> Self {
        var zelf = self
        zelf.labelTypography.color = color
        return zelf
    }

    /// 상하 여백의 크기를 조정합니다.
    ///
    /// 정해진 네 단계(`none`·`small`·`medium`·`large`)로 표현할 수 없는 간격은
    /// ``VerticalPadding/custom(_:)``으로 직접 지정할 수 있습니다.
    ///
    /// - Parameters:
    ///   - verticalPadding: 적용할 상하 여백 크기
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Note: 여백이 `0`인 셀은 인터랙션 효과를 표시하지 않습니다.
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }

    /// 셀 내 콘텐츠의 수직 정렬을 조정합니다.
    ///
    /// 라벨이 2줄 이상일 때 leading·labelTrailing·trailing 콘텐츠를 첫 행에 맞출지, 셀 중앙에 맞출지 정합니다.
    ///
    /// - Parameters:
    ///   - verticalAlignment: 적용할 수직 정렬 방식, 생략하면 기본값으로 `.top` 적용
    /// - Returns: 수정된 ListCell 인스턴스
    public func verticalAlign(_ verticalAlignment: VerticalAlign) -> Self {
        var zelf = self
        zelf.verticalAlignment = verticalAlignment
        return zelf
    }

    /// 인터랙션 효과(hover·pressed 배경)가 셀 경계 바깥으로 확장되는 정도를 설정합니다.
    ///
    /// 메뉴처럼 좌우 여백이 있는 컨테이너 안에서는 기본값 `12`를 그대로 사용해 여백까지 배경을 넓히고,
    /// 셀이 화면 폭을 그대로 채우는 목록에서는 `0`을 지정합니다.
    ///
    /// - Parameters:
    ///   - outset: 좌우로 확장할 크기 (포인트 단위), 생략하면 기본값으로 `12` 적용
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Note: 모서리 둥글기는 ``interactionRadius(_:)``로 따로 정하며 `outset`과 독립적으로 동작합니다.
    ///
    /// - Note: 4.0.0에서 제거된 `fillWidth(_:)`·`interactionPadding(_:)`을 대체합니다.
    ///   `fillWidth(true)`는 `interactionOutset(0)`, `fillWidth(false)`는 `interactionOutset(12)`에 대응하며,
    ///   `fillWidth(true)`가 적용하던 셀 좌우 20포인트 여백은 더 이상 자동으로 붙지 않으므로 필요하면 사용처에서 직접 지정합니다.
    public func interactionOutset(_ outset: CGFloat = 12) -> Self {
        var zelf = self
        zelf.interactionOutset = outset
        return zelf
    }

    /// 인터랙션 효과 영역의 모서리 둥글기를 설정합니다.
    ///
    /// 지정하지 않으면 ``interactionOutset(_:)``이 `0`보다 클 때 `16`, 그 외에는 `0`이 적용됩니다.
    ///
    /// - Parameters:
    ///   - radius: 적용할 모서리 반경 (포인트 단위)
    /// - Returns: 수정된 ListCell 인스턴스
    public func interactionRadius(_ radius: CGFloat) -> Self {
        var zelf = self
        zelf.interactionRadius = radius
        return zelf
    }

    /// 텍스트의 생략 처리 여부를 설정합니다.
    ///
    /// `true`로 설정하면 라벨과 설명이 각각 한 줄로 제한되고, 초과 텍스트는 말줄임 처리됩니다.
    /// `false`인 경우 두 텍스트 모두 줄 수 제한 없이 줄바꿈됩니다.
    ///
    /// - Parameters:
    ///   - textEllipsis: 텍스트 생략 처리 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ListCell 인스턴스
    public func textEllipsis(_ textEllipsis: Bool = true) -> Self {
        var zelf = self
        zelf.textEllipsis = textEllipsis
        return zelf
    }

    /// 셀에 부가 설명을 추가합니다.
    ///
    /// 설명은 라벨 아래에 작은 글씨로 표시되는 부가 설명 텍스트입니다.
    ///
    /// - Parameters:
    ///   - description: 표시할 설명 텍스트, 생략하면 기본값으로 `nil` 적용 (nil 설정 시 설명 제거)
    /// - Returns: 수정된 ListCell 인스턴스
    public func description(_ description: String? = nil) -> Self {
        var zelf = self
        zelf.descriptionText = description
        return zelf
    }

    /// 셀을 선택된 상태로 설정합니다.
    ///
    /// 선택된 셀은 라벨 텍스트의 색상이 `surfaceBrandPrimary`로 변경되고, 텍스트 두께가 bold로 설정되며,
    /// trailing 영역에 체크 아이콘이 표시됩니다.
    /// ``chevron(_:)``을 켠 셀에서는 화살표가 체크 아이콘 오른쪽에 그대로 남습니다.
    ///
    /// - Parameters:
    ///   - selected: 선택 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Important: 체크 아이콘은 ``trailingResources(_:)`` 자리를 대신 차지하므로 둘을 함께 표시할 수 없습니다.
    ///   선택 상태와 별개의 우측 콘텐츠가 필요하면 ``labelTrailingResources(_:)`` 또는 ``extraResources(_:)``를 사용하세요.
    public func selected(_ selected: Bool = true) -> Self {
        var zelf = self
        zelf.selected = selected
        return zelf
    }

    /// 셀 하단에 구분선을 추가합니다.
    ///
    /// - Parameters:
    ///   - divider: 구분선 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ListCell 인스턴스
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
    ///   - chevron: 화살표 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 ListCell 인스턴스
    public func chevron(_ chevron: Bool = true) -> Self {
        var zelf = self
        zelf.chevron = chevron
        return zelf
    }

    /// 셀 좌측에 표시할 요소를 지정합니다.
    ///
    /// 아이콘, 체크박스, 아바타, 썸네일 등을 셀 라벨 앞에 배치할 수 있습니다.
    /// 여러 개를 넘기면 8포인트 간격으로 가로 배치됩니다.
    ///
    /// ```swift
    /// ListCell(label: "김티드")
    ///     .leadingResources([
    ///         .checkbox(checked: isChecked),
    ///         .avatar(profileImageURL, variant: .person)
    ///     ])
    /// ```
    ///
    /// - Parameters:
    ///   - resources: 표시할 요소 목록
    /// - Returns: 수정된 ListCell 인스턴스
    public func leadingResources(_ resources: [Resource.Leading]) -> Self {
        var zelf = self
        zelf.leadingResources = resources
        return zelf
    }

    /// 라벨 행의 오른쪽 끝에 표시할 요소를 지정합니다.
    ///
    /// 배지나 인증 아이콘처럼 라벨에 딸린 요소를 배치할 때 사용합니다.
    /// 여러 개를 넘기면 4포인트 간격으로 가로 배치되며, 높이가 22포인트로 고정되어 행 높이를 늘리지 않습니다.
    ///
    /// ```swift
    /// ListCell(label: "김티드")
    ///     .labelTrailingResources([.contentBadge(title: "신규")])
    /// ```
    ///
    /// - Parameters:
    ///   - resources: 표시할 요소 목록
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Note: 라벨이 2줄 이상일 때 표시 위치는 ``verticalAlign(_:)``을 따릅니다.
    public func labelTrailingResources(_ resources: [Resource.LabelTrailing]) -> Self {
        var zelf = self
        zelf.labelTrailingResources = resources
        return zelf
    }

    /// 셀 우측에 표시할 요소를 지정합니다.
    ///
    /// 값 텍스트, 배지, 버튼, 스위치 등을 셀 오른쪽 끝에 배치할 수 있습니다.
    /// 여러 개를 넘기면 8포인트 간격으로 가로 배치됩니다.
    ///
    /// ```swift
    /// ListCell(label: "알림 받기")
    ///     .trailingResources([.switch(checked: isOn, onSelect: { isOn = $0 })])
    /// ```
    ///
    /// - Parameters:
    ///   - resources: 표시할 요소 목록
    /// - Returns: 수정된 ListCell 인스턴스
    ///
    /// - Important: ``selected(_:)``가 `true`인 셀은 체크 아이콘이 이 자리를 대신 차지해 요소가 표시되지 않습니다.
    public func trailingResources(_ resources: [Resource.Trailing]) -> Self {
        var zelf = self
        zelf.trailingResources = resources
        return zelf
    }

    /// 설명 아래에 표시할 요소를 지정합니다.
    ///
    /// 셀 폭을 모두 사용하며, 여러 개를 넘기면 6포인트 간격으로 가로 배치됩니다.
    ///
    /// ```swift
    /// ListCell(label: "김티드")
    ///     .description("iOS 개발자")
    ///     .extraResources([
    ///         .contentBadge(.outlined, title: "서울"),
    ///         .contentBadge(.outlined, title: "5년차")
    ///     ])
    /// ```
    ///
    /// - Parameters:
    ///   - resources: 표시할 요소 목록
    /// - Returns: 수정된 ListCell 인스턴스
    public func extraResources(_ resources: [Resource.Extra]) -> Self {
        var zelf = self
        zelf.extraResources = resources
        return zelf
    }

    /// 라벨의 특정 텍스트를 강조 표시합니다.
    ///
    /// 지정한 문자열과 일치하는 부분을 굵은 글씨(bold)로 강조 표시합니다.
    /// 대소문자를 구분하지 않으며, 첫 번째로 일치하는 부분만 강조됩니다.
    ///
    /// - Parameters:
    ///   - text: 강조할 텍스트 문자열
    /// - Returns: 수정된 ListCell 인스턴스
    public func highlight(_ text: String) -> Self {
        var zelf = self
        zelf.highlightText = text
        return zelf
    }
}

// MARK: - Private
extension ListCell {
    private var isDisabled: Bool { isEnabled == false }

    /// 인터랙션 효과 적용 여부.
    ///
    /// 상하 여백이 없는 셀은 배경이 텍스트에 바짝 붙어 눌림 표현이 오히려 노이즈가 되므로 사용하지 않는다.
    /// `custom(0)`도 `none`과 결과가 같으므로 케이스가 아닌 실제 여백 값으로 판단한다.
    private var interactionEnabled: Bool {
        verticalPadding.length > 0
    }

    private var resolvedInteractionRadius: CGFloat {
        interactionRadius ?? (interactionOutset > 0 ? 16 : 0)
    }

    private var resolvedLabelColor: Color.Semantic {
        if isDisabled {
            .foregroundDisablePrimary
        } else {
            selected ? .surfaceBrandPrimary : labelTypography.color
        }
    }

    private var resolvedDescriptionColor: Color.Semantic {
        isDisabled ? .foregroundDisablePrimary : .foregroundNeutralTertiary
    }

    private var chevronColor: Color.Semantic {
        isDisabled ? .foregroundDisablePrimary : .foregroundNeutralQuaternary
    }

    private var selectedCheckColor: Color.Semantic {
        isDisabled ? .foregroundDisablePrimary : .surfaceBrandPrimary
    }

    private var row: some View {
        HStack(alignment: verticalAlignment.alignment, spacing: 0) {
            if leadingResources.isEmpty == false {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(Array(leadingResources.enumerated()), id: \.offset) { _, resource in
                        resource.view
                    }
                }
                .frame(minHeight: Self.rowMinHeight)
                .padding(.trailing, 8)
            }

            VStack(alignment: .leading, spacing: 0) {
                labelRow

                if let descriptionText {
                    Text(descriptionText)
                        .paragraph(
                            variant: .label2,
                            semantic: resolvedDescriptionColor
                        )
                        .if(textEllipsis) {
                            $0.lineLimit(1)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if extraResources.isEmpty == false {
                    HStack(alignment: .center, spacing: 6) {
                        ForEach(Array(extraResources.enumerated()), id: \.offset) { _, resource in
                            resource.view
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // 선택된 셀은 체크 아이콘이 trailing 자리를 대신 차지한다.
            if selected {
                Image.icon(.check)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(SwiftUI.Color.semantic(selectedCheckColor))
                    .frame(width: Self.selectedCheckSize, height: Self.selectedCheckSize)
                    .frame(minHeight: Self.rowMinHeight)
                    .padding(.leading, 8)
            } else if trailingResources.isEmpty == false {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(Array(trailingResources.enumerated()), id: \.offset) { _, resource in
                        resource.view
                    }
                }
                .frame(minHeight: Self.rowMinHeight)
                .padding(.leading, 8)
            }

            if chevron {
                Image.icon(.chevronRightTightSmall)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(SwiftUI.Color.semantic(chevronColor))
                    .frame(width: 8, height: 16)
                    .frame(minHeight: Self.rowMinHeight)
                    .padding(.leading, 8)
            }
        }
        // 슬롯 콘텐츠에는 비활성일 때만 색을 강제하고, 그 외에는 사용처가 지정한 색을 그대로 둔다.
        // 자기 색을 직접 그리는 컴포넌트(ContentBadge·Switch 등)는 이 전경색을 따르지 않는다.
        .if(isDisabled) {
            $0.foregroundStyle(SwiftUI.Color.semantic(.foregroundDisablePrimary))
        }
    }

    private var labelRow: some View {
        HStack(alignment: verticalAlignment.alignment, spacing: 0) {
            Group {
                labelView
            }
            .if(textEllipsis) {
                $0.lineLimit(1)
            }
            .fixedSize(horizontal: false, vertical: true)
            // labelTrailing이 없을 때만 라벨이 행을 채운다.
            // 있을 때는 라벨이 hug해서 짧으면 요소가 바로 옆에 붙고, 길면 아래 Spacer가 0으로 줄며
            // 요소 자리를 뺀 남은 폭에서 줄바꿈된다.
            .if(labelTrailingResources.isEmpty) {
                $0.frame(maxWidth: .infinity, alignment: .leading)
            }

            if labelTrailingResources.isEmpty == false {
                HStack(alignment: .center, spacing: 4) {
                    ForEach(Array(labelTrailingResources.enumerated()), id: \.offset) { _, resource in
                        resource.view
                    }
                }
                // 라벨이 길어져도 요소는 축소되지 않는다.
                .fixedSize(horizontal: true, vertical: false)
                .frame(height: Self.labelContentHeight)
                .padding(.leading, 4)

                Spacer(minLength: 0)
            }
        }
        .padding(.vertical, Self.labelRowPadding)
        .frame(minHeight: Self.rowMinHeight)
    }

    private var labelView: some View {
        Group {
            if let highlightText {
                let attributedString: AttributedString = {
                    var string = AttributedString(stringLiteral: label)
                    string.font = .font(variant: labelTypography.variant, weight: selected ? .bold : labelTypography.weight)
                    string.foregroundColor = .semantic(resolvedLabelColor)
                    guard let range = string.range(of: highlightText, options: .caseInsensitive) else {
                        return string
                    }
                    string[range].font = .font(variant: labelTypography.variant, weight: .bold)
                    string[range].foregroundColor = .semantic(resolvedLabelColor)
                    return string
                }()

                Text(attributedString)
                    .tracking(labelTypography.variant.tracking)
                    .adjustLineHeight(variant: labelTypography.variant)
            } else {
                Text(label)
                    .paragraph(
                        variant: labelTypography.variant,
                        weight: selected ? .bold : labelTypography.weight,
                        semantic: resolvedLabelColor
                    )
            }
        }
    }
}

// MARK: - Resource
extension ListCell {
    /// ``ListCell``의 각 슬롯에 표시할 요소들의 Namespace입니다.
    ///
    /// 슬롯마다 쓸 수 있는 요소가 다르므로 슬롯별로 타입을 나눠 두었습니다.
    /// 예를 들어 ``Trailing/switch(checked:onSelect:)``는 ``ListCell/trailingResources(_:)``에만 넘길 수 있고,
    /// ``ListCell/leadingResources(_:)``에 넘기면 컴파일되지 않습니다.
    ///
    /// 미리 정의된 요소는 크기와 정렬이 셀 스펙(행 최소 높이 24)에 맞춰 고정됩니다.
    /// 목록에 없는 구성이 필요하면 각 타입의 `slot(_:)` 팩토리를 사용합니다.
    ///
    /// - Important: `slot(_:)`으로 넣은 뷰에는 이 크기 제약이 적용되지 않습니다.
    ///   행 높이가 밀리지 않게 하려면 사용처에서 `frame(...)`이나 `fixedSize(...)`로 크기를 직접 정해야 합니다.
    public enum Resource {
        /// 셀 좌측(``ListCell/leadingResources(_:)``)에 표시할 요소입니다.
        public enum Leading {
            /// 아이콘 (22×22)
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.foregroundNeutralTertiary)` 적용
            case icon(
                _ icon: Icon,
                tintColor: SwiftUI.Color = .semantic(.foregroundNeutralTertiary)
            )

            /// 배경이 있는 큰 아이콘 (컨테이너 36×36 / 아이콘 20×20)
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.foregroundNeutralSecondary)` 적용
            case largeIcon(
                _ icon: Icon,
                tintColor: SwiftUI.Color = .semantic(.foregroundNeutralSecondary)
            )

            /// 체크박스
            /// - Parameters:
            ///   - checked: 선택 여부
            ///   - onSelect: 선택 변경 핸들러, 생략하면 기본값으로 `nil` 적용
            case checkbox(checked: Bool, onSelect: ((Bool) -> Void)? = nil)

            /// 라디오
            /// - Parameters:
            ///   - checked: 선택 여부
            ///   - onSelect: 선택 변경 핸들러, 생략하면 기본값으로 `nil` 적용
            case radio(checked: Bool, onSelect: ((Bool) -> Void)? = nil)

            /// 아바타 (40×40)
            /// - Parameters:
            ///   - imageUrl: 표시할 이미지의 URL 문자열
            ///   - variant: 아바타 유형
            case avatar(_ imageUrl: String, variant: Avatar.Variant)

            /// 썸네일 (56×56 정사각, 둥근 모서리·테두리 적용)
            /// - Parameter imageUrl: 표시할 이미지의 URL 문자열
            case thumbnail(_ imageUrl: String)

            /// 임의 뷰. ``slot(_:)`` 팩토리로 생성합니다.
            case slotView(() -> AnyView)

            /// 목록에 없는 구성을 직접 배치합니다.
            ///
            /// - Parameter content: 표시할 뷰를 생성하는 클로저
            /// - Returns: 구성된 요소
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Leading {
                .slotView { AnyView(content()) }
            }
        }

        /// 셀 우측(``ListCell/trailingResources(_:)``)에 표시할 요소입니다.
        public enum Trailing {
            /// 값 텍스트
            /// - Parameter text: 표시할 텍스트
            case value(_ text: String)

            /// 아이콘 (22×22)
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.foregroundNeutralSecondary)` 적용
            case icon(
                _ icon: Icon,
                tintColor: SwiftUI.Color = .semantic(.foregroundNeutralSecondary)
            )

            /// 아이콘 버튼 (배경 없음)
            /// - Parameters:
            ///   - icon: 버튼 아이콘
            ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
            case iconButton(_ icon: Icon, handler: (() -> Void)? = nil)

            /// 텍스트 버튼
            /// - Parameters:
            ///   - title: 버튼 텍스트
            ///   - color: 버튼 색상, 생략하면 기본값으로 `.assistive` 적용
            ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
            case textButton(
                title: String,
                color: TextButton.Color = .assistive,
                handler: (() -> Void)? = nil
            )

            /// 버튼 (Solid / Small)
            /// - Parameters:
            ///   - title: 버튼 텍스트
            ///   - color: 버튼 색상, 생략하면 기본값으로 `.assistive` 적용
            ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
            case button(
                title: String,
                color: Button.Color = .assistive,
                handler: (() -> Void)? = nil
            )

            /// 콘텐츠 배지
            /// - Parameters:
            ///   - variant: 배지 변형 스타일, 생략하면 기본값으로 `.solid` 적용
            ///   - title: 배지 텍스트
            case contentBadge(_ variant: ContentBadge.Variant = .solid, title: String)

            /// 스위치
            /// - Parameters:
            ///   - checked: 켜짐 여부
            ///   - onSelect: 값 변경 핸들러, 생략하면 기본값으로 `nil` 적용
            case `switch`(checked: Bool, onSelect: ((Bool) -> Void)? = nil)

            /// 임의 뷰. ``slot(_:)`` 팩토리로 생성합니다.
            case slotView(() -> AnyView)

            /// 목록에 없는 구성을 직접 배치합니다.
            ///
            /// - Parameter content: 표시할 뷰를 생성하는 클로저
            /// - Returns: 구성된 요소
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Trailing {
                .slotView { AnyView(content()) }
            }
        }

        /// 라벨 행 오른쪽 끝(``ListCell/labelTrailingResources(_:)``)에 표시할 요소입니다.
        public enum LabelTrailing {
            /// 콘텐츠 배지
            /// - Parameters:
            ///   - variant: 배지 변형 스타일, 생략하면 기본값으로 `.solid` 적용
            ///   - title: 배지 텍스트
            case contentBadge(_ variant: ContentBadge.Variant = .solid, title: String)

            /// 아이콘 (22×22)
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.surfaceBrandPrimary)` 적용
            case icon(
                _ icon: Icon,
                tintColor: SwiftUI.Color = .semantic(.surfaceBrandPrimary)
            )

            /// 임의 뷰. ``slot(_:)`` 팩토리로 생성합니다.
            case slotView(() -> AnyView)

            /// 목록에 없는 구성을 직접 배치합니다.
            ///
            /// - Parameter content: 표시할 뷰를 생성하는 클로저
            /// - Returns: 구성된 요소
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> LabelTrailing {
                .slotView { AnyView(content()) }
            }
        }

        /// 설명 아래(``ListCell/extraResources(_:)``)에 표시할 요소입니다.
        public enum Extra {
            /// 텍스트
            /// - Parameter text: 표시할 텍스트
            case text(_ text: String)

            /// 콘텐츠 배지
            /// - Parameters:
            ///   - variant: 배지 변형 스타일, 생략하면 기본값으로 `.solid` 적용
            ///   - title: 배지 텍스트
            case contentBadge(_ variant: ContentBadge.Variant = .solid, title: String)

            /// 임의 뷰. ``slot(_:)`` 팩토리로 생성합니다.
            case slotView(() -> AnyView)

            /// 목록에 없는 구성을 직접 배치합니다.
            ///
            /// - Parameter content: 표시할 뷰를 생성하는 클로저
            /// - Returns: 구성된 요소
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Extra {
                .slotView { AnyView(content()) }
            }
        }
    }
}

// MARK: - Resource Rendering
extension ListCell.Resource {
    /// 슬롯 아이콘의 한 변 크기.
    fileprivate static var iconSize: CGFloat { 22 }
    /// ``Leading/largeIcon(_:tintColor:)`` 컨테이너의 한 변 크기.
    fileprivate static var largeIconContainerSize: CGFloat { 36 }
    /// ``Leading/largeIcon(_:tintColor:)`` 안쪽 아이콘의 한 변 크기.
    fileprivate static var largeIconSize: CGFloat { 20 }
    /// ``Leading/largeIcon(_:tintColor:)`` 컨테이너의 모서리 반경.
    fileprivate static var largeIconCornerRadius: CGFloat { 12 }
    /// ``Leading/thumbnail(_:)``의 한 변 크기.
    fileprivate static var thumbnailSize: CGFloat { 56 }

    /// 지정한 크기의 템플릿 아이콘을 만든다.
    fileprivate static func iconView(
        _ icon: Icon,
        tintColor: SwiftUI.Color,
        size: CGFloat
    ) -> some View {
        Image.icon(icon)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(tintColor)
            .frame(width: size, height: size)
    }
}

extension ListCell.Resource.Leading {
    @ViewBuilder
    var view: some View {
        switch self {
        case let .icon(icon, tintColor):
            ListCell.Resource.iconView(icon, tintColor: tintColor, size: ListCell.Resource.iconSize)
        case let .largeIcon(icon, tintColor):
            ListCell.Resource.iconView(icon, tintColor: tintColor, size: ListCell.Resource.largeIconSize)
                .frame(
                    width: ListCell.Resource.largeIconContainerSize,
                    height: ListCell.Resource.largeIconContainerSize
                )
                .background(
                    RoundedRectangle(cornerRadius: ListCell.Resource.largeIconCornerRadius)
                        .fill(SwiftUI.Color.semantic(.surfaceNeutralSecondary))
                )
        case let .checkbox(checked, onSelect):
            Checkbox(checked: checked, onSelect: onSelect)
        case let .radio(checked, onSelect):
            Radio(checked: checked, onSelect: onSelect)
        case let .avatar(imageUrl, variant):
            Avatar(imageUrl, variant: variant, size: .medium)
        case let .thumbnail(imageUrl):
            Thumbnail(urlString: imageUrl, ratio: .r1x1)
                .width(ListCell.Resource.thumbnailSize)
                .radius()
                .border()
        case let .slotView(content):
            content()
        }
    }
}

extension ListCell.Resource.Trailing {
    @ViewBuilder
    var view: some View {
        switch self {
        case let .value(text):
            Text(text)
                .paragraph(variant: .body2, semantic: .foregroundNeutralTertiary)
        case let .icon(icon, tintColor):
            ListCell.Resource.iconView(icon, tintColor: tintColor, size: ListCell.Resource.iconSize)
        case let .iconButton(icon, handler):
            IconButton(variant: .normal(size: .small), icon: icon, handler: handler)
        case let .textButton(title, color, handler):
            TextButton(color: color, size: .small, text: title, handler: handler)
        case let .button(title, color, handler):
            Button(variant: .solid, color: color, size: .small, text: title, handler: handler)
        case let .contentBadge(variant, title):
            ContentBadge(variant: variant, text: title)
        case let .switch(checked, onSelect):
            Switch(checked: checked, onSelect: onSelect)
        case let .slotView(content):
            content()
        }
    }
}

extension ListCell.Resource.LabelTrailing {
    @ViewBuilder
    var view: some View {
        switch self {
        case let .contentBadge(variant, title):
            ContentBadge(variant: variant, text: title)
        case let .icon(icon, tintColor):
            ListCell.Resource.iconView(icon, tintColor: tintColor, size: ListCell.Resource.iconSize)
        case let .slotView(content):
            content()
        }
    }
}

extension ListCell.Resource.Extra {
    @ViewBuilder
    var view: some View {
        switch self {
        case let .text(text):
            Text(text)
                .paragraph(variant: .label2, semantic: .foregroundNeutralTertiary)
        case let .contentBadge(variant, title):
            ContentBadge(variant: variant, text: title)
        case let .slotView(content):
            content()
        }
    }
}
