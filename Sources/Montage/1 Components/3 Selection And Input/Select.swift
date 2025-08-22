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
///     variant: .single(.checkmark, nil),
///     placeholder: "선택하세요",
///     items: $items
/// )
/// ```
public struct Select: View {
    // MARK: - Types
    
    /// 다중 선택 가능여부를 나타내는 열거형입니다.
    public enum Variant {
        /// 단일 선택 모드
        /// - Parameters:
        ///   - selectionType: 선택 표시 방식 (체크마크 또는 라디오 버튼), 기본값은 .radio
        ///   - menuPrimaryButtonTitle: 확인 버튼 제목 (nil일 경우 버튼 표시 안 함)
        case single(selectionType: SingleSelectionType = .radio, menuPrimaryButtonTitle: String? = nil)
        
        /// 다중 선택 모드
        /// - Parameters:
        ///   - render: 선택된 항목 표시 방식 (텍스트 또는 칩), 기본값은 .text
        ///   - overflow: 선택된 항목이 여러 줄로 표시되는지 여부, 기본값은 false
        ///   - menuPrimaryButtonTitle: 확인 버튼 제목
        case multiple(render: Render = .text, overflow: Bool = false, menuPrimaryButtonTitle: String)
        
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
        /// 아이템의 아이콘 (선택 사항)
        public let icon: Icon?
        /// 부정적 상태 여부 (오류나 경고를 나타낼 때 사용)
        public let isNegative: Bool
        /// 항목의 선택 여부
        public var isSelected: Bool
        
        /// 아이템 초기화
        /// - Parameters:
        ///   - text: 아이템 텍스트
        ///   - icon: 아이템 아이콘 (기본값: nil)
        ///   - isNegative: 부정적 상태 여부 (기본값: false)
        ///   - isSelected: 선택 여부 (기본값: false)
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
        case icon(Icon)
        /// 아이콘 버튼 표시
        case iconButton(IconButton)
        /// 사용자 정의 뷰 표시
        case custom(() -> any View)
    }

    // MARK: - Initializer
    
    private var customMenuPresented: Binding<Bool>?
    private let variant: Variant
    @Binding private var items: [Item]
    private let onTapItem: ((Select.Item) -> Void)?
    
    /// Select 컴포넌트 초기화
    /// - Parameters:
    ///   - menuPresented: 메뉴 표시 상태 바인딩 (기본값: nil)
    ///   - variant: 컴포넌트의 시각적/기능적 변형
    ///   - items: 선택 가능한 항목 배열 (바인딩)
    ///   - onTapItem: 항목 선택 시 호출되는 클로저 (기본값: nil)
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
    private var heading = ""
    private var requiredBadge = false
    private var description = ""
    private var shadowBackgroundColor: SwiftUI.Color = .init(uiColor: UIColor.systemBackground)
    private var leadingContent: LeadingContent?
    private var menuResize: BottomSheetModal.Resize = .hug
    
    /// negative 상태 여부를 조정합니다.
    /// - Parameter negative: 부정적 상태 여부 (기본값: true)
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
    /// - Parameter disable: 비활성화 여부 (기본값: true)
    /// - Returns: 수정된 Select 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 제목을 추가합니다.
    /// - Parameter heading: 표시할 제목 텍스트
    /// - Returns: 수정된 Select 인스턴스
    public func heading(_ heading: String) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 필수 표시 노출 여부를 조정합니다.
    /// - Parameter requiredBadge: 필수 표시 여부 (기본값: true)
    /// - Returns: 수정된 Select 인스턴스
    public func requiredBadge(_ requiredBadge: Bool = true) -> Self {
        var zelf = self
        zelf.requiredBadge = requiredBadge
        return zelf
    }
    
    /// 설명을 추가합니다.
    /// - Parameter description: 표시할 설명 텍스트
    /// - Returns: 수정된 Select 인스턴스
    public func description(_ description: String) -> Self {
        var zelf = self
        zelf.description = description
        return zelf
    }
    
    /// shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.
    /// - Parameter shadowBackgroundColor: 설정할 배경색
    /// - Returns: 수정된 Select 인스턴스
    public func shadowBackgroundColor(_ shadowBackgroundColor: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.shadowBackgroundColor = shadowBackgroundColor
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
    public func menuResize(_ menuResize: BottomSheetModal.Resize) -> Self {
        var zelf = self
        zelf.menuResize = menuResize
        return zelf
    }
    
    // MARK: - Body
    
    @State private var contentSize: CGSize = .zero
    @State private var flowLayoutSize: CGSize = .zero
    @State private var defaultMenuPresented = false
    @State private var bottomSheetContentHeight: CGFloat = .zero
    @State private var pureBottomSheetHeight: CGFloat = .zero
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !heading.isEmpty {
                HStack(spacing: 4) {
                    Text(heading)
                        .typographyNew(
                            variant: .label1,
                            weight: .bold,
                            semantic: .labelNormal
                        )
                    if requiredBadge {
                        Text("*")
                            .typographyNew(
                                variant: .label1,
                                weight: .medium,
                                semantic: .statusNegative
                            )
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(shadowBackgroundColor)
                    .shadow(
                        color: .semantic(.staticBlack).opacity(0.03),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
                    .frame(
                        width: contentSize.width,
                        height: contentSize.height
                    )
                
                HStack(alignment: .top, spacing: 8) {
                    Group {
                        switch leadingContent {
                        case .icon(let icon):
                            Image.icon(icon)
                                .resizable()
                                .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                                .padding(1)
                                .frame(width: 24, height: 24)
                        case .iconButton(let iconButton):
                            iconButton
                                .frame(width: 24, height: 24)
                        case .custom(let content):
                            AnyView(content())
                                .frame(minHeight: 24)
                        default:
                            EmptyView()
                        }
                    }
                    
                    ZStack {
                        HStack {
                            if selectedItems.isEmpty {
                                Text(placeholder)
                                    .paragraphNew(
                                        variant: .body1,
                                        weight: .regular,
                                        color: placeholderTextColor
                                    )
                                    .lineLimit(1)
                            } else {
                                switch variant {
                                case .single:
                                    if let text = selectedItems.first?.text {
                                        Text(text)
                                            .paragraphNew(
                                                variant: .body1,
                                                weight: .regular,
                                                color: textColor
                                            )
                                            .lineLimit(1)
                                    }
                                case .multiple(let render, let overflow, _):
                                    Group {
                                        if render == .text {
                                            Text(selectedItems.map { $0.text }.joined(separator: ", "))
                                                .paragraphNew(
                                                    variant: .body1,
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
                                                .modifier(GradientScrollEdgeModifier(gradientWidth: 40))
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(minHeight: 24)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                    }
                    
                    if !selectedItems.isEmpty, negative {
                        Image.icon(.circleExclamationFill)
                            .resizable()
                            .padding(1)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(SwiftUI.Color.semantic(.statusNegative))
                    }
                    
                    IconButton(
                        variant: .normal(size: 16),
                        icon: .chevronDownThickSmall
                    ) {
                        menuPresented.wrappedValue.toggle()
                    }
                    .iconColor(disable ? SwiftUI.Color.semantic(.labelDisable) : .semantic(.labelAlternative))
                    .padding(.horizontal, 4)
                    .frame(height: 24)
                }
                .padding(.all, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(disable ? SwiftUI.Color.semantic(.interactionDisable) : .clear)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .strokeBorder(strokeColor, lineWidth: menuPresented.wrappedValue ? 2 : 1)
                }
                .shadow(
                    color: .semantic(.staticBlack).opacity(0.03),
                    radius: 2,
                    x: 0,
                    y: 1
                )
            }
            
            if !description.isEmpty {
                Text(description)
                    .typographyNew(
                        variant: .caption1,
                        weight: .regular,
                        semantic: negative ? .statusNegative : .labelAlternative
                    )
            }
        }
        .allowsHitTesting(disable == false)
        .onTapGesture {
            menuPresented.wrappedValue.toggle()
        }
        .if(customMenuPresented == nil) {
            $0.bottomSheetModal(
                isPresented: $defaultMenuPresented,
                resize: menuResize,
                actionAreaModel: actionAreaButtonTitle.map {
                    .init(variant: .neutral(
                        main: .init(text: $0, action: {
                            defaultMenuPresented.toggle()
                        }),
                        sub: .custom {
                            Button.outlined(
                                variant: .assistive,
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
        VStack(spacing: 4) {
            ForEach(items.indices, id: \.self) { index in
                Group {
                    let cell = Cell(title: items[index].text) {
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
                            cell.active(items[index].isSelected)
                                .trailingContent { active in
                                    Group {
                                        if active {
                                            Image.icon(.check)
                                                .resizable()
                                                .foregroundStyle(SwiftUI.Color.semantic(.primaryNormal))
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                }
                        case .radio:
                            cell.leadingContent {
                                Control.radio(checked: items[index].isSelected)
                            }
                        }
                    case .multiple:
                        cell.leadingContent {
                            Control.checkbox(checked: items[index].isSelected)
                        }
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
    
    private var strokeColor: SwiftUI.Color {
        if disable {
            .semantic(.lineNeutral)
        } else {
            if negative {
                .semantic(.statusNegative).opacity(0.28)
            } else {
                menuPresented.wrappedValue ? .semantic(.primaryNormal).opacity(0.43) : .semantic(.lineNeutral)
            }
        }
    }
    
    private var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.labelDisable) : .semantic(.labelAssistive)
    }
    
    private var textColor: SwiftUI.Color {
        disable ? .semantic(.labelAlternative) : .semantic(.labelNormal)
    }
    
    // MARK: - Inner View
    
    private struct Chips: View {
        var items: [Select.Item]
        var disable: Bool
        var onTapItem: ((Select.Item) -> Void)?
        
        var body: some View {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                Montage.ActionChip(
                    variant: .solid,
                    size: .xsmall,
                    text: item.text
                )
                .backgroundColor(backgroundColor(item))
                .fontColor(fontColor(item))
                .imageColor(iconColor(item))
                .trailingImage(Image.icon(.closeThick))
                .if(item.icon != nil) {
                    $0.leadingImage(Image.icon(item.icon!))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapItem?(items[index])
                }
            }
        }
        
        private func iconColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .semantic(.labelDisable) }
            if item.isNegative {
                return .semantic(.statusNegative)
            } else {
                return .semantic(.labelAlternative)
            }
        }
        
        private func backgroundColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .clear }
            if item.isNegative {
                return .semantic(.statusNegative).opacity(0.05)
            } else {
                return .clear
            }
        }
        
        private func fontColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .semantic(.labelDisable) }
            if item.isNegative {
                return .semantic(.statusNegative)
            } else {
                return .semantic(.labelAlternative)
            }
        }
    }
}
