//
//  TextField.swift
//  Montage
//
//  Created by ahn sanghoon on 8/1/24.
//

import SwiftUI

/// 단일 라인 텍스트 입력을 위한 컴포넌트입니다.
///
/// 이 컴포넌트는 사용자가 텍스트를 입력할 수 있는 필드를 제공합니다.
/// 제목, 아이콘, 자동완성, 상태 표시 등 다양한 기능을 지원합니다.
///
/// ```swift
/// @State private var inputText = ""
///
/// // 기본 텍스트 필드
/// TextField(text: $inputText)
///    .heading("이메일")
///    .placeholder("이메일을 입력하세요")
///
/// // 아이콘이 있는 필수 입력 필드
/// TextField(text: $inputText)
///    .heading("아이디")
///    .requiredBadge(true)
///    .icon(.person)
///    .status(.negative(description: "올바른 아이디를 입력해주세요"))
///
/// // 오른쪽 버튼이 있는 텍스트 필드
/// TextField(text: $inputText)
///    .trailingButton(
///        .init(
///            variant: .primary,
///            title: "인증",
///            handler: { verifyCode() }
///        )
///    )
/// ```
public struct TextField: View {
    // MARK: - Types
    
    /// 텍스트 필드의 상태를 정의합니다.
    public enum Status {
        /// 기본 상태, 선택적으로 설명 텍스트 포함 가능
        ///
        /// - Parameter description: 설명 텍스트, 기본값은 빈 문자열
        case normal(description: String = "")
        /// 유효한 입력 상태, 선택적으로 설명 텍스트 포함 가능
        ///
        /// - Parameter description: 설명 텍스트, 기본값은 빈 문자열
        case positive(description: String = "")
        /// 오류 상태, 선택적으로 오류 설명 텍스트 포함 가능
        ///
        /// - Parameter description: 오류 설명 텍스트, 기본값은 빈 문자열
        case negative(description: String = "")
    }
    
    /// 텍스트 필드의 오른쪽에 표시할 버튼의 속성을 정의합니다.
    ///
    /// 이 구조체를 사용하여 오른쪽에 표시될 버튼의 스타일, 텍스트, 동작을 정의할 수 있습니다.
    public struct TrailingButtonInfo {
        fileprivate let variant: Button.Outlined.Variant
        fileprivate let title: String
        fileprivate let handler: (() -> Void)?
        
        /// 트레일링 버튼을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 버튼의 변형 스타일
        ///   - title: 버튼에 표시할 텍스트
        ///   - handler: 버튼 클릭 시 실행할 핸들러
        /// - Returns: 구성된 트레일링 버튼 인스턴스
        public init(
            variant: Button.Outlined.Variant,
            title: String,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.title = title
            self.handler = handler
        }
    }
    
    /// 텍스트 필드의 자동완성 기능을 위한 데이터 소스를 정의합니다.
    ///
    /// 이 구조체를 사용하여 자동완성 목록의 섹션, 항목, 레이아웃 등을 정의할 수 있습니다.
    public struct AutoCompletionDataSource: Equatable {
        public static func == (lhs: AutoCompletionDataSource, rhs: AutoCompletionDataSource) -> Bool {
            lhs.id == rhs.id
        }

        private let id = UUID()
        fileprivate let numberOfSections: Int
        fileprivate let sectionTitleAt: ((Int) -> String)?
        fileprivate let numberOfItemsInSection: (Int) -> Int
        fileprivate let cellForItemAt: (IndexPath) -> AnyView
        fileprivate let headerView: () -> AnyView
        fileprivate let footerView: () -> AnyView
        fileprivate let maxHeight: CGFloat
        
        /// 자동완성 데이터 소스를 초기화합니다.
        ///
        /// - Parameters:
        ///   - numberOfSections: 섹션 수, 기본값은 1
        ///   - sectionTitleAt: 섹션 제목을 반환하는 클로저
        ///   - numberOfItemsInSection: 각 섹션의 항목 수를 반환하는 클로저
        ///   - cellForItemAt: 각 항목의 뷰를 반환하는 클로저
        ///   - maxHeight: 자동완성 목록의 최대 높이, 기본값은 400
        /// - Returns: 구성된 자동완성 데이터 소스 인스턴스
        public init<V: View>(
            numberOfSections: Int = 1,
            sectionTitleAt: ((Int) -> String)? = nil,
            numberOfItemsInSection: @escaping (Int) -> Int,
            @ViewBuilder cellForItemAt: @escaping (IndexPath) -> V,
            headerView: (() -> any View)? = nil,
            footerView: (() -> any View)? = nil,
            maxHeight: CGFloat = 400
        ) {
            self.numberOfSections = numberOfSections
            self.sectionTitleAt = sectionTitleAt
            self.numberOfItemsInSection = numberOfItemsInSection
            self.cellForItemAt = { AnyView(cellForItemAt($0)) }
            self.headerView = headerView.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
            self.footerView = footerView.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
            self.maxHeight = maxHeight
        }
        
        /// 전체 항목 수를 반환합니다.
        public var totalNumberOfItems: Int {
            (0 ..< numberOfSections).map(numberOfItemsInSection).reduce(0, +)
        }
    }
    
    // MARK: - Initializer
    
    @Binding private var text: String
    @Binding private var autoCompletionDataSource: AutoCompletionDataSource?
    
    /// 텍스트 필드를 초기화합니다.
    ///
    /// - Parameters:
    ///   - text: 텍스트 필드의 값을 바인딩
    ///   - autoCompletionDataSource: 자동완성 데이터 소스를 바인딩, 기본값은 nil
    /// - Returns: 구성된 텍스트 필드 인스턴스
    public init(
        text: Binding<String>,
        autoCompletionDataSource: Binding<AutoCompletionDataSource?> = .constant(nil)
    ) {
        _text = text
        _autoCompletionDataSource = autoCompletionDataSource
    }
    
    // MARK: - Modifiers
    
    private var status: Status = .normal()
    private var disable = false
    private var heading: String? = nil
    private var requiredBadge = false
    private var placeholder: String? = nil
    private var icon: Icon? = nil
    private var trailingButton: TrailingButtonInfo? = nil
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var suggestions: Binding<[String]> = .constant([])
    private var customBackgroundColor: SwiftUI.Color?
    
    /// 텍스트 필드의 상태를 설정합니다.
    ///
    /// - Parameter status: 텍스트 필드의 상태
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func status(_ status: Status) -> Self {
        var zelf = self
        zelf.status = status
        return zelf
    }
    
    /// 텍스트 필드의 활성화 상태를 설정합니다.
    ///
    /// - Parameter disable: 비활성화 여부, `true`이면 비활성화
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func disable(_ disable: Bool) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 텍스트 필드 위에 표시할 제목을 설정합니다.
    ///
    /// - Parameter heading: 표시할 제목, nil이면 제목 표시 안함
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func heading(_ heading: String?) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.
    ///
    /// - Parameter requiredBadge: 필수 입력 뱃지 표시 여부
    /// - Returns: 수정된 텍스트 필드 인스턴스
    /// - Note: 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다.
    public func requiredBadge(_ requiredBadge: Bool) -> Self {
        var zelf = self
        zelf.requiredBadge = requiredBadge
        return zelf
    }
    
    /// 텍스트 필드에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.
    ///
    /// - Parameter placeholder: 표시할 플레이스홀더 텍스트
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func placeholder(_ placeholder: String?) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }
    
    /// 텍스트 필드 왼쪽에 표시할 아이콘을 설정합니다.
    ///
    /// - Parameter icon: 표시할 아이콘
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func icon(_ icon: Icon?) -> Self {
        var zelf = self
        zelf.icon = icon
        return zelf
    }
    
    /// 텍스트 필드 오른쪽에 표시할 버튼을 설정합니다.
    ///
    /// - Parameter trailingButton: 표시할 버튼의 속성
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func trailingButton(_ trailingButton: TrailingButtonInfo?) -> Self {
        var zelf = self
        zelf.trailingButton = trailingButton
        return zelf
    }
    
    /// 텍스트 필드 오른쪽에 표시할 커스텀 콘텐츠를 설정합니다.
    ///
    /// - Parameter trailingContent: 표시할 커스텀 콘텐츠를 생성하는 클로저
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func trailingContent<V: View>(@ViewBuilder _ trailingContent: @escaping () -> V) -> Self {
        var zelf = self
        zelf.trailingContent = { AnyView(trailingContent()) }
        return zelf
    }
    
    /// 텍스트 필드의 배경색을 설정합니다.
    ///
    /// - Parameter color: 설정할 배경색
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func backgroundColor(_ color: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBackgroundColor = color
        return zelf
    }
    
    // MARK: - Body
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var textFieldFrame: CGRect = .zero
    @FocusState private var textFieldFocusState: Bool
    @State private var autoCompletionContentHeight: CGFloat = .zero
    @State private var fixAutocorrection = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let heading {
                HStack(spacing: 4) {
                    Text(heading)
                        .paragraph(variant: .label1, weight: .bold, semantic: .labelNeutral)
                    if requiredBadge {
                        Text("*")
                            .typography(variant: .label1, weight: .medium, semantic: .statusNegative)
                    }
                }
            }
            
            inputField
            
            Group {
                switch status {
                case .positive(let caption), .negative(let caption), .normal(let caption):
                    if caption.isEmpty == false {
                        Text(caption)
                            .paragraph(
                                variant: .caption1,
                                color: captionTextColor
                            )
                    }
                }
            }
        }
    }
}
        
// MARK: - Private

private extension TextField {
    var inputField: some View {
        HStack(spacing: -1) {
            ZStack {
                HStack(spacing: 9) {
                    if let icon {
                        Image.icon(icon)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                    }
                    SwiftUI.TextField(
                        "",
                        text: $text,
                        prompt: {
                            if let placeholder {
                                Text(placeholder)
                                    .typography(
                                        variant: .body1,
                                        weight: .regular,
                                        color: placeholderTextColor
                                    )
                            } else {
                                nil
                            }
                        }()
                    )
                    .autocorrectionDisabled(fixAutocorrection)
                    .font(.font(variant: .body1, weight: .regular))
                    .foregroundStyle(fieldTextColor)
                    .focused($textFieldFocusState)
                    .frame(minHeight: 24)
                    .padding(.horizontal, 4)
                    
                    if !text.isEmpty, textFieldFocusState {
                        IconButton(
                            variant: .normal(size: 22),
                            icon: .circleCloseFill
                        ) {
                            text = ""
                            fixAutocorrection = true
                            Task { fixAutocorrection = false }
                        }
                        .iconColor(.semantic(.labelAssistive))
                    } else {
                        if let trailingIcon, let trailingIconColor {
                            Image
                                .icon(trailingIcon)
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(trailingIconColor)
                        }
                    }
                    
                    trailingContent()
                }
                .padding(.all, 12)
                .overlay {
                    if trailingButton == nil {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                    } else {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 12))
                            .strokeBorder(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                    }
                }
                .onGeometryChange(
                    for: CGRect.self,
                    of: { $0.frame(in: .global) },
                    action: { textFieldFrame = $0 }
                )
            }
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                textFieldFocusState = true
            }
            
            if let trailingButton {
                ZStack {
                    TrailingButton(
                        variant: trailingButton.variant,
                        title: trailingButton.title,
                        handler: trailingButton.handler
                    )
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 12, topTrailing: 12))
                        .strokeBorder(SwiftUI.Color.semantic(.lineNeutral), lineWidth: 1)
                        .clipShape(
                            Rectangle()
                                .offset(x: 1, y: .zero)
                        )
                        .frame(height: textFieldFrame.height)
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .frame(minHeight: 48)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
        .allowsHitTesting(disable == false)
        .overlay {
            autoCompletionContent.opacity(0)
                .onGeometryChange(
                    for: CGFloat.self,
                    of: { $0.size.height },
                    action: { autoCompletionContentHeight = $0 }
                )
        }
        .modifier(
            FloatModifier(
                isPresented: (autoCompletionDataSource?.totalNumberOfItems ?? 0) > 0 && textFieldFocusState,
                updatingValue: Binding(
                    get: { "\(String(describing: autoCompletionDataSource)),\(autoCompletionContentHeight)" },
                    set: { _ in }
                ),
                dismissPolicy: .onTouchOutside,
                onDismiss: {
                    textFieldFocusState = false
                    autoCompletionDataSource = nil
                },
                floatView: {
                    SwiftUI.ScrollView {
                        autoCompletionContent
                    }
                    .frame(
                        width: textFieldFrame.width,
                        height: min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0)
                    )
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(SwiftUI.Color.semantic(.lineAlternative))
                    }
                    .background(SwiftUI.Color.semantic(.backgroundNormal))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scrollDisabled(autoCompletionContentHeight <= autoCompletionDataSource?.maxHeight ?? 0)
                    .position(
                        x: textFieldFrame.midX,
                        y: textFieldFrame.maxY - safeAreaInsets.top
                    )
                    .offset(
                        y: 8 + min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0) / 2
                    )
                }
            )
        )
    }
    
    var backgroundColor: SwiftUI.Color {
        disable
        ? .semantic(.interactionDisable)
        : customBackgroundColor ?? .semantic(.backgroundNormal)
    }
    
    var captionTextColor: SwiftUI.Color {
        switch status {
        case .negative:
            .semantic(.statusNegative)
        default:
            .semantic(.labelAlternative)
        }
    }
    
    var autoCompletionContent: some View {
        Group {
            if let autoCompletionDataSource {
                let itemCount = autoCompletionDataSource.totalNumberOfItems
                VStack(alignment: .leading, spacing: 4) {
                    if itemCount > 0 {
                        autoCompletionDataSource.headerView()
                    }
                    LazyVStack(alignment: .leading, spacing: 4, pinnedViews: [.sectionHeaders]) {
                        ForEach(0 ..< autoCompletionDataSource.numberOfSections, id: \.self) { section in
                            Group {
                                let itemCount = autoCompletionDataSource.numberOfItemsInSection(section)
                                if itemCount > 0 {
                                    let header: some View = Group {
                                        if let title = autoCompletionDataSource.sectionTitleAt?(section) {
                                            HStack {
                                                Text(title)
                                                    .paragraph(
                                                        variant: .caption1,
                                                        weight: .bold,
                                                        semantic: .labelAlternative
                                                    )
                                                Spacer()
                                            }
                                            .padding(.horizontal, 1)
                                            .padding(.vertical, 4)
                                            .background(SwiftUI.Color.semantic(.backgroundElevated))
                                        }
                                    }
                                    Section(header: header) {
                                        VStack(spacing: 4) {
                                            ForEach(0 ..< itemCount, id: \.self) { item in
                                                let indexPath = IndexPath(item: item, section: section)
                                                autoCompletionDataSource.cellForItemAt(indexPath)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if itemCount > 0 {
                        autoCompletionDataSource.footerView()
                    }
                }
                .padding(.horizontal, itemCount == 0 ? 0 : 20)
                .padding(.vertical, itemCount == 0 ? 0 : 8)
            }
        }
    }
    
    var fieldStrokeColor: SwiftUI.Color {
        if textFieldFocusState {
            switch status {
            case .normal, .positive:
                .semantic(.primaryNormal).opacity(0.43)
            case .negative:
                .semantic(.statusNegative).opacity(0.43)
            }
        } else {
            switch status {
            case .normal, .positive:
                .semantic(.lineNeutral)
            case .negative:
                .semantic(.statusNegative).opacity(0.43)
            }
        }
    }
    
    var trailingIcon: Icon? {
        switch status {
        case .positive:
            .circleCheckFill
        case .negative:
            .circleExclamationFill
        default:
            nil
        }
    }
    
    var trailingIconColor: SwiftUI.Color? {
        switch status {
        case .positive:
            .semantic(.primaryNormal)
        case .negative:
            .semantic(.statusNegative)
        default:
            nil
        }
    }
    
    var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.labelDisable) : .semantic(.labelAssistive)
    }
    
    var fieldTextColor: SwiftUI.Color {
        disable ? .semantic(.labelAlternative) : .semantic(.labelNormal)
    }
}

// MARK: - Inner Views
private extension TextField {
    struct TrailingButton: View {
        private let variant: Button.Outlined.Variant
        private let title: String
        private let handler: (() -> Void)?
        
        init(variant: Button.Outlined.Variant, title: String, handler: (() -> Void)?) {
            self.variant = variant
            self.title = title
            self.handler = handler
        }
        
        @State private var isPressed = false
        
        var body: some View {
            Text(title)
                .paragraph(variant: .body1, weight: typoWeight, semantic: textColor)
                .padding(.horizontal, 19)
                .padding(.vertical, 12)
                .background(
                    Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .labelNormal
                    )
                )
                .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        }
        
        var textColor: Color.Semantic {
            switch variant {
            case .primary, .secondary:
                .primaryNormal
            case .assistive:
                .labelNormal
            }
        }
        
        var typoWeight: Typography.Weight {
            switch variant {
            case .primary, .secondary: .bold
            case .assistive: .medium
            }
        }
    }
}
