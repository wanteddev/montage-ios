//
//  Select.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/13/24.
//

import SwiftUI

/// `Select` 컴포넌트는 사용자가 드롭다운 메뉴에서 하나 또는 여러 항목을 선택할 수 있는 UI 요소입니다.
/// 단일 선택 또는 다중 선택 모드를 지원하며, 여러 시각적 변형과 맞춤 설정 옵션을 제공합니다.
///
/// ```swift
/// @State private var items = [
///     .init(text: "Option 1"),
///     .init(text: "Option 2"),
///     .init(text: "Option 3")
/// ]
///
/// Select(
///     variant: .single(selectionType: .checkmark),
///     items: $items
/// )
/// .placeholder("선택하세요")
/// ```
public struct Select: View {
    // MARK: - Types

    /// 선택 모드를 나타내는 열거형입니다.
    public enum Variant {
        /// 단일 선택 모드
        /// - Parameters:
        ///   - selectionType: 선택 표시 방식, 생략하면 기본값으로 `.radio` 적용
        ///   - menuPrimaryButtonTitle: 확인 버튼 제목, 생략하면 기본값으로 `nil` 적용 (버튼 표시 안 함)
        case single(
            selectionType: SingleSelectionType = .radio, menuPrimaryButtonTitle: String? = nil)

        /// 다중 선택 모드
        /// - Parameters:
        ///   - render: 선택된 항목 표시 방식, 생략하면 기본값으로 `.text` 적용
        ///   - overflow: 선택된 항목이 여러 줄로 표시되는지 여부, 생략하면 기본값으로 `false` 적용
        ///   - menuPrimaryButtonTitle: 확인 버튼 제목
        case multiple(
            render: Render = .text, overflow: Bool = false, menuPrimaryButtonTitle: String)

        var isSingle: Bool {
            switch self {
            case .single:
                true
            case .multiple:
                false
            }
        }
    }

    /// Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.
    public struct Item: Equatable {
        /// 아이템 텍스트 내용
        public let text: String
        /// 아이템의 아이콘
        public let icon: Icon?
        /// 부정적 상태 여부 (오류나 경고를 나타낼 때 사용)
        public let isNegative: Bool
        /// 항목의 선택 여부
        public var isSelected: Bool

        /// 아이템 초기화
        /// - Parameters:
        ///   - text: 아이템 텍스트
        ///   - icon: 아이템 아이콘, 생략하면 기본값으로 `nil` 적용
        ///   - isNegative: 부정적 상태 여부, 생략하면 기본값으로 `false` 적용
        ///   - isSelected: 선택 여부, 생략하면 기본값으로 `false` 적용
        public init(
            text: String,
            icon: Icon? = nil,
            isNegative: Bool = false,
            isSelected: Bool = false
        ) {
            self.text = text
            self.icon = icon
            self.isNegative = isNegative
            self.isSelected = isSelected
        }
    }

    /// variant가 single일 때 아이템 선택 창에 아이템이 표시되는 방식을 결정하는 열거형입니다.
    public enum SingleSelectionType {
        /// 체크마크로 선택 표시
        case checkmark
        /// 라디오 버튼으로 선택 표시
        case radio
    }

    /// variant가 multiple일 때 컴포넌트에 표시될 내용의 형태를 결정하는 열거형입니다.
    public enum Render {
        /// 선택된 항목 텍스트만 표시
        case text
        /// 선택된 항목을 칩(chip) 형태로 표시
        case chip
    }

    /// 왼쪽에 표시될 컨텐트 타입입니다.
    public enum LeadingContent {
        /// 아이콘 표시
        /// - Parameter icon: 표시할 아이콘
        case icon(_ icon: Icon)
        /// 아이콘 버튼 표시
        /// - Parameter iconButton: 표시할 아이콘 버튼
        case iconButton(_ iconButton: IconButton)
        /// 사용자 정의 뷰 표시
        /// - Parameter content: 사용자 정의 뷰를 반환하는 클로저
        case custom(_ content: () -> any View)
    }

    /// Select 컴포넌트의 사이즈를 정의합니다.
    ///
    /// 사이즈에 따라 컨테이너 패딩, 모서리 반경, 최소 높이, 입력 타이포그래피,
    /// 선행 아이콘 크기가 함께 결정됩니다. `TextField`의 사이즈 정책과 동일합니다.
    public enum Size {
        /// 큰 사이즈 (최소 높이 48)
        case large
        /// 중간 사이즈 (최소 높이 40)
        case medium
    }

    // MARK: - Initializer

    private var customMenuPresented: Binding<Bool>?
    private let variant: Variant
    @Binding private var items: [Item]
    private let onTapItem: ((Select.Item) -> Void)?

    /// Select 컴포넌트 초기화
    /// - Parameters:
    ///   - menuPresented: 메뉴 표시 상태 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - variant: 컴포넌트의 시각적/기능적 변형
    ///   - items: 선택 가능한 항목 배열 (바인딩)
    ///   - onTapItem: 항목 선택 시 호출되는 클로저, 생략하면 기본값으로 `nil` 적용
    public init(
        menuPresented: Binding<Bool>? = nil,
        variant: Variant,
        items: Binding<[Item]>,
        onTapItem: ((Select.Item) -> Void)? = nil
    ) {
        customMenuPresented = menuPresented
        self.variant = variant
        _items = items
        self.onTapItem = onTapItem
    }

    // MARK: - Modifiers

    private var negative = false
    private var render: Render = .text
    private var placeholder = ""
    private var disable = false
    private var leadingContent: LeadingContent?
    private var menuResize: BottomSheet.Resize = .hug
    private var size: Size = .large

    /// Select 컴포넌트의 사이즈를 설정합니다.
    /// - Parameter size: 적용할 사이즈, 생략하면 기본값으로 `.large` 적용
    /// - Returns: 수정된 Select 인스턴스
    public func size(_ size: Size = .large) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// negative 상태 여부를 조정합니다.
    /// - Parameter negative: 부정적 상태 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 Select 인스턴스
    public func negative(_ negative: Bool = true) -> Self {
        var zelf = self
        zelf.negative = negative
        return zelf
    }

    /// 선택된 항목들이 없는 경우 placeholder를 표시합니다.
    /// - Parameter placeholder: 표시할 플레이스홀더 텍스트
    /// - Returns: 수정된 Select 인스턴스
    public func placeholder(_ placeholder: String) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }

    /// 활성화 여부를 조정합니다.
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 Select 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }

    /// 왼쪽 컨텐츠를 추가합니다.
    /// - Parameter content: 표시할 선행 콘텐츠
    /// - Returns: 수정된 Select 인스턴스
    public func leadingContent(_ content: LeadingContent?) -> Self {
        var zelf = self
        zelf.leadingContent = content
        return zelf
    }

    /// 메뉴의 높이 detent를 지정합니다.
    /// - Parameter menuResize: 메뉴 크기 조정 방식
    /// - Returns: 수정된 Select 인스턴스
    public func menuResize(_ menuResize: BottomSheet.Resize) -> Self {
        var zelf = self
        zelf.menuResize = menuResize
        return zelf
    }

    // MARK: - Body

    @Environment(\.colorScheme) private var colorScheme
    @State private var defaultMenuPresented = false
    @State private var bottomSheetContentHeight: CGFloat = .zero
    @State private var pureBottomSheetHeight: CGFloat = .zero

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        // spacing 0: 요소 사이 간격은 각 요소의 명시적 패딩으로만 준다.
        // (HStack spacing을 두면 leading→content 간격에 불필요하게 더해진다)
        HStack(alignment: .top, spacing: 0) {
            Group {
                switch leadingContent {
                case .icon(let icon):
                    Image.icon(icon)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralTertiary))
                        .padding(size.leadingIconPadding)
                        .frame(width: size.contentMinHeight, height: size.contentMinHeight)
                case .iconButton(let iconButton):
                    // leading 아이콘 버튼은 인터랙션 영역이 슬롯보다 크므로(large 32, medium 28),
                    // 슬롯(large 24×24, medium 20×24)에 담고 넘치는 인터랙션 영역은 밖으로 흘린다.
                    iconButton
                        .frame(width: size.contentMinHeight, height: .dimension24)
                case .custom(let content):
                    AnyView(content())
                        .frame(minHeight: size.contentMinHeight)
                default:
                    EmptyView()
                }
            }
            // 선행 콘텐츠와 content 영역 사이 간격. render=chip일 때 large 4/medium 3, 그 외 leading은 textHorizontalPadding.
            .padding(.trailing, leadingContent == nil ? 0 : (isRenderChip ? size.chipLeadingTrailingPadding : size.textHorizontalPadding))

            HStack {
                if selectedItems.isEmpty {
                    Text(placeholder)
                        .paragraph(
                            variant: size.inputVariant,
                            weight: .regular,
                            color: placeholderTextColor
                        )
                        .lineLimit(1)
                } else {
                    switch variant {
                    case .single:
                        if let text = selectedItems.first?.text {
                            Text(text)
                                .paragraph(
                                    variant: size.inputVariant,
                                    weight: .regular,
                                    color: textColor
                                )
                                .lineLimit(1)
                        }
                    case .multiple(let render, let overflow, _):
                        Group {
                            if render == .text {
                                Text(
                                    selectedItems.map { $0.text }.joined(
                                        separator: ", ")
                                )
                                .paragraph(
                                    variant: size.inputVariant,
                                    weight: .regular,
                                    color: textColor
                                )
                                .if(!overflow) {
                                    $0.lineLimit(1)
                                }
                            } else {
                                let chips = Chips(
                                    items: selectedItems,
                                    disable: disable,
                                    onTapItem: { item in
                                        let index = items.enumerated()
                                            .first { $0.element == item }?
                                            .offset
                                        if let index {
                                            items[index].isSelected = false
                                        }
                                    }
                                )
                                if overflow {
                                    FlowLayout(spacing: 4, lineSpacing: 4) {
                                        chips
                                    }
                                } else {
                                    HStack(spacing: 4) {
                                        chips
                                    }
                                    .modifier(
                                        GradientScrollEdgeModifier(gradientWidth: 40))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .frame(minHeight: size.contentMinHeight)
            // content 왼쪽 패딩은 leading이 없을 때만 준다(있으면 leading의 trailing 패딩이 간격을 담당).
            // 오른쪽 패딩은 chevron과의 간격으로 항상 유지. 이로써 leading 없을 때 텍스트-외곽선 large 16/medium 14.
            .padding(.leading, leadingContent == nil ? size.textHorizontalPadding : 0)
            .padding(.trailing, size.textHorizontalPadding)
            .contentShape(Rectangle())

            IconButton(
                variant: .normal(size: .small),
                icon: .chevronDownThickSmall
            ) {
                menuPresented.wrappedValue.toggle()
            }
            .iconColor(
                disable
                    ? SwiftUI.Color.semantic(.foregroundDisablePrimary) : .semantic(.foregroundNeutralTertiary)
            )
            .padding(.horizontal, 4)
            .frame(height: size.contentMinHeight)
            .rotationEffect(.degrees(menuPresented.wrappedValue ? 180 : 0))
        }
        .padding(.horizontal, size.containerPadding)
        // overflow일 때 상하단 간격(large 12, medium 8)을 컨테이너 세로 패딩으로 준다.
        // text 영역이 아니라 HStack 전체에 줘야 leading·첫 줄·chevron이 같은 상단선에 정렬된다.
        .padding(.vertical, size.containerPadding + (isOverflow ? size.overflowVerticalPadding : 0))
        .frame(minHeight: size.minHeight)
        // 둥근 표면을 배경 Shape로 직접 그려 `clipShape`의 오프스크린 마스킹을 제거한다.
        // 외형(둥근 모서리·머티리얼·테두리)은 동일하게 유지한다. (drop shadow 제거)
        .background {
            let surface = surfaceShape
            if disable {
                surface
                    .fill(SwiftUI.Color.semantic(.surfaceNeutralTertiary))
            } else {
                surface
                    .fill(
                        colorScheme == .light
                            ? SwiftUI.Color.atomic(.common100).opacity(0.8)
                            : SwiftUI.Color.atomic(.coolNeutral17).opacity(0.61)
                    )
                    .background(.ultraThinMaterial, in: surface)
            }
        }
        .overlay {
            surfaceShape
                .strokeBorder(strokeColor, lineWidth: 1)
        }
        // 메뉴가 열렸을 때 TextField와 동일하게 내부 border(primary 43%)에 더해
        // 외부 Focus Ring(primary 12%)을 그린다.
        .background { focusRing }
        .allowsHitTesting(disable == false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(placeholder)
        .accessibilityValue(selectedItems.map(\.text).joined(separator: ", "))
        .accessibilityAddTraits(.isButton)
        .onTapGesture {
            menuPresented.wrappedValue.toggle()
        }
        .if(customMenuPresented == nil) {
            $0.bottomSheet(
                isPresented: $defaultMenuPresented,
                resize: menuResize,
                actionAreaModel: actionAreaButtonTitle.map {
                    .init(
                        variant: .neutral(
                            main: .init(
                                text: $0,
                                action: {
                                    defaultMenuPresented.toggle()
                                }),
                            sub: .custom {
                                Button(
                                    variant: .outlined,
                                    color: .assistive,
                                    size: .large,
                                    icon: .refresh
                                ) {
                                    deselectAll()
                                }
                            }
                        ))
                }
            ) {
                menu
            }
        }
    }

    // MARK: - Private
    private var actionAreaButtonTitle: String? {
        switch variant {
        case .single(_, let primaryButtonTitle):
            primaryButtonTitle
        case .multiple(_, _, let primaryButtonTitle):
            primaryButtonTitle
        }
    }

    private var menuPresented: Binding<Bool> {
        customMenuPresented ?? $defaultMenuPresented
    }

    private var bottomSheetMaxHeight: CGFloat {
        pureBottomSheetHeight + bottomSheetContentHeight
    }

    private var maxDetentValue: CGFloat {
        (UIApplication.keyWindow?.safeAreaSize.height ?? 0) - 10
    }

    private var menu: some View {
        // BottomSheet가 스크롤 오프셋 변화마다 content를 재평가하므로,
        // 항목이 많을 때 eager 렌더링(VStack)은 스크롤 hitch를 유발한다
        LazyVStack(spacing: 4) {
            ForEach(items.indices, id: \.self) { index in
                Group {
                    let cell = ListCell(label: items[index].text) {
                        switch variant {
                        case .single(_, let primaryButtonTitle):
                            deselectAll()
                            if primaryButtonTitle == nil {
                                defaultMenuPresented.toggle()
                            }
                            items[index].isSelected.toggle()
                        case .multiple:
                            items[index].isSelected.toggle()
                        }
                        onTapItem?(items[index])
                    }

                    switch variant {
                    case .single(let selectionType, _):
                        switch selectionType {
                        case .checkmark:
                            // 체크 아이콘은 ListCell이 selected 상태에서 직접 그린다.
                            cell.selected(items[index].isSelected)
                        case .radio:
                            cell.leadingResources([.radio(checked: items[index].isSelected)])
                        }
                    case .multiple:
                        cell.leadingResources([.checkbox(checked: items[index].isSelected)])
                    }
                }
            }
        }
    }

    private var selectedItems: [Item] {
        items.filter(\.isSelected)
    }

    private func deselectAll() {
        items = items.map {
            var mutated = $0
            mutated.isSelected = false
            return mutated
        }
    }

    /// 표면(surface) 둥근 사각형 Shape입니다. 배경 채우기·그림자·테두리에서 공통으로 사용합니다.
    private var surfaceShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: size.cornerRadius)
    }

    private var strokeColor: SwiftUI.Color {
        if disable {
            .semantic(.lineNeutralSecondary)
        } else if negative {
            menuPresented.wrappedValue
                ? .semantic(.lineNegativeStrong) : .semantic(.lineNegativePrimary)
        } else {
            menuPresented.wrappedValue
                ? .semantic(.lineBrandStrong) : .semantic(.lineNeutralSecondary)
        }
    }

    private var focusRingColor: SwiftUI.Color {
        negative ? .semantic(.lineNegativeFocus) : .semantic(.lineBrandFocus)
    }

    @ViewBuilder
    private var focusRing: some View {
        if menuPresented.wrappedValue, disable == false {
            RoundedRectangle(cornerRadius: size.cornerRadius + .spacing4)
                .strokeBorder(focusRingColor, lineWidth: 4)
                .padding(-.spacing4)
        }
    }

    private var isRenderChip: Bool {
        if case .multiple(let render, _, _) = variant {
            return render == .chip
        }
        return false
    }

    private var isOverflow: Bool {
        if case .multiple(_, let overflow, _) = variant {
            return overflow
        }
        return false
    }

    private var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.foregroundDisablePrimary) : .semantic(.foregroundNeutralQuaternary)
    }

    private var textColor: SwiftUI.Color {
        disable ? .semantic(.foregroundNeutralTertiary) : .semantic(.foregroundNeutralPrimary)
    }

    // MARK: - Inner View

    private struct Chips: View {
        var items: [Select.Item]
        var disable: Bool
        var onTapItem: ((Select.Item) -> Void)?

        var body: some View {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                Montage.Chip(
                    variant: .outlined,
                    size: .xsmall,
                    text: item.text
                )
                .fontColor(fontColor(item))
                .imageColor(iconColor(item))
                .trailingImage(Image.icon(.closeThick))
                .modifying {
                    var mutated = $0
                    if let icon = item.icon {
                        mutated = mutated.leadingImage(Image.icon(icon))
                    }
                    if item.isNegative, disable == false {
                        mutated = mutated.borderColor(.semantic(.lineNegativePrimary))
                    }
                    return mutated
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapItem?(items[index])
                }
            }
        }

        /// 아이콘(leading/close) 색상입니다. disable은 foreground/disable/primary, negative는 foreground/negative/primary, 그 외 foreground/neutral/primary.
        private func iconColor(_ item: Select.Item) -> SwiftUI.Color {
            if disable {
                return .semantic(.foregroundDisablePrimary)
            } else if item.isNegative {
                return .semantic(.foregroundNegativePrimary)
            } else {
                return .semantic(.foregroundNeutralPrimary)
            }
        }

        /// 텍스트 색상입니다. disable/그 외는 foreground/neutral/primary, negative는 foreground/negative/primary.
        private func fontColor(_ item: Select.Item) -> SwiftUI.Color {
            if item.isNegative, disable == false {
                return .semantic(.foregroundNegativePrimary)
            } else {
                return .semantic(.foregroundNeutralPrimary)
            }
        }
    }
}

// MARK: - Size Tokens
private extension Select.Size {
    /// Container 내부 패딩
    var containerPadding: CGFloat {
        switch self {
        case .large: .spacing8
        case .medium: .spacing6
        }
    }

    /// 모서리 반경
    var cornerRadius: CGFloat {
        switch self {
        case .large: .radius14
        case .medium: .radius12
        }
    }

    /// Container 최소 높이
    var minHeight: CGFloat {
        switch self {
        case .large: .dimension48
        case .medium: .dimension40
        }
    }

    /// Content 영역 최소 높이 (선행/후행 아이콘 묶음 크기와 공유)
    var contentMinHeight: CGFloat {
        switch self {
        case .large: .dimension24
        case .medium: .dimension20
        }
    }

    /// 입력 타이포그래피 변형
    var inputVariant: Typography.Variant {
        switch self {
        case .large: .body2
        case .medium: .label1
        }
    }

    /// 선행 아이콘 묶음 내부 패딩 (아이콘 실제 크기 = contentMinHeight - 2 * leadingIconPadding)
    var leadingIconPadding: CGFloat {
        switch self {
        case .large: .spacing2
        case .medium: .spacing1
        }
    }

    /// 텍스트 영역 좌우 패딩. containerPadding과 합해 텍스트-외곽선 간격을 large 16, medium 14로 만든다.
    var textHorizontalPadding: CGFloat {
        switch self {
        case .large: .spacing8
        case .medium: .spacing8
        }
    }

    /// overflow일 때 콘텐츠 상하단에 더하는 세로 패딩. containerPadding과 합해 large 12, medium 8을 만든다.
    var overflowVerticalPadding: CGFloat {
        switch self {
        case .large: .spacing4
        case .medium: .spacing2
        }
    }

    /// render=chip일 때 선행 콘텐츠 우측에 더하는 패딩(large 4, medium 3).
    /// spacing 스케일에 3이 없어 medium은 리터럴을 사용한다.
    var chipLeadingTrailingPadding: CGFloat {
        switch self {
        case .large: .spacing4
        case .medium: 3
        }
    }
}
