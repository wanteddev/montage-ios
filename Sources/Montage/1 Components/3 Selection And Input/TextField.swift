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
///    .placeholder("이메일을 입력하세요")
///
/// // 아이콘과 오류 상태를 가진 필드
/// TextField(text: $inputText)
///    .icon(.person)
///    .status(.negative)
///
/// // 오른쪽 버튼이 있는 텍스트 필드
/// TextField(text: $inputText)
///    .trailingButton(
///        .init(
///            title: "인증",
///            handler: { verifyCode() }
///        )
///    )
///
/// // 사이즈를 지정한 텍스트 필드
/// TextField(text: $inputText)
///    .size(.medium)
/// ```
public struct TextField: View {
    // MARK: - Types

    /// 텍스트 필드의 사이즈를 정의합니다.
    ///
    /// 사이즈에 따라 패딩, 모서리 반경, 최소 높이, 입력 타이포그래피, 아이콘 크기가 함께 결정됩니다.
    public enum Size {
        /// 큰 사이즈 (최소 높이 48)
        case large
        /// 중간 사이즈 (최소 높이 40)
        case medium
    }

    /// 텍스트 필드의 상태를 정의합니다.
    public enum Status {
        /// 기본 상태
        case normal
        /// 유효한 입력 상태
        case positive
        /// 오류 상태
        case negative
    }

    /// 텍스트 필드의 오른쪽에 표시할 버튼의 속성을 정의합니다.
    ///
    /// 이 구조체를 사용하여 필드 내부 오른쪽에 표시될 버튼(Outlined 형태)의 텍스트와 동작을 정의할 수 있습니다.
    public struct TrailingButtonInfo {
        fileprivate let title: String
        fileprivate let disable: Bool
        fileprivate let handler: (() -> Void)?

        /// 트레일링 버튼을 초기화합니다.
        ///
        /// - Parameters:
        ///   - title: 버튼에 표시할 텍스트
        ///   - disable: 트레일링 버튼만 비활성화할지 여부, 생략하면 기본값으로 `false` 적용
        ///   - handler: 버튼 클릭 시 실행할 핸들러
        /// - Returns: 구성된 트레일링 버튼 인스턴스
        public init(
            title: String,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.title = title
            self.disable = disable
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
        ///   - numberOfSections: 섹션 수, 생략하면 기본값으로 `1` 적용
        ///   - sectionTitleAt: 섹션 제목을 반환하는 클로저, 생략하면 기본값으로 `nil` 적용
        ///   - numberOfItemsInSection: 각 섹션의 항목 수를 반환하는 클로저
        ///   - cellForItemAt: 각 항목의 뷰를 반환하는 클로저
        ///   - headerView: 헤더 뷰 클로저, 생략하면 기본값으로 `nil` 적용
        ///   - footerView: 푸터 뷰 클로저, 생략하면 기본값으로 `nil` 적용
        ///   - maxHeight: 자동완성 목록의 최대 높이, 생략하면 기본값으로 `400` 적용
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
    ///   - autoCompletionDataSource: 자동완성 데이터 소스를 바인딩, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 구성된 텍스트 필드 인스턴스
    public init(
        text: Binding<String>,
        autoCompletionDataSource: Binding<AutoCompletionDataSource?> = .constant(nil)
    ) {
        _text = text
        _autoCompletionDataSource = autoCompletionDataSource
    }
    
    // MARK: - Modifiers

    private var size: Size = .large
    private var status: Status = .normal
    private var disable = false
    private var placeholder: String? = nil
    private var icon: Icon? = nil
    private var trailingButton: TrailingButtonInfo? = nil
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var suggestions: Binding<[String]> = .constant([])
    private var customBackgroundColor: SwiftUI.Color?
    private var maxLength: Int?
    private var onTextChange: ((String) -> Void)?

    /// 텍스트 필드의 사이즈를 설정합니다.
    ///
    /// - Parameter size: 텍스트 필드의 사이즈
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

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

    /// 입력 가능한 최대 글자 수를 설정합니다.
    ///
    /// 입력/붙여넣기로 텍스트가 제한을 초과하면 앞에서부터 `limit` 글자만 남기고 잘립니다.
    /// 글자 수는 문자(grapheme cluster) 단위로 계산됩니다. `nil`이면 길이를 제한하지 않습니다.
    ///
    /// - Parameter limit: 최대 글자 수. `nil`이면 제한 없음
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func maxLength(_ limit: Int?) -> Self {
        var zelf = self
        // 음수가 들어오면 String.prefix(_:)가 런타임 트랩을 일으키므로 진입점에서 0 이상으로 정규화한다.
        zelf.maxLength = limit.map { max(0, $0) }
        return zelf
    }

    /// 텍스트가 변경될 때마다 호출할 클로저를 설정합니다.
    ///
    /// 변경된 전체 텍스트를 전달하므로 글자 수 계산(`text.count`), 유효성 검사 등 다양한 후처리에
    /// 사용할 수 있습니다. ``maxLength(_:)``으로 잘린 경우 잘린 뒤의 최종 텍스트가 전달됩니다.
    ///
    /// - Parameter handler: 변경된 텍스트를 전달받는 클로저
    /// - Returns: 수정된 텍스트 필드 인스턴스
    public func onTextChange(_ handler: @escaping (String) -> Void) -> Self {
        var zelf = self
        zelf.onTextChange = handler
        return zelf
    }

    // MARK: - Body
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.colorScheme) private var colorScheme
    @State private var textFieldGlobalFrame: CGRect = .zero
    @FocusState private var textFieldFocusState: Bool
    @State private var autoCompletionContentHeight: CGFloat = .zero
    @State private var fixAutocorrection = false

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        inputField
    }
}
        
// MARK: - Private

private extension TextField {
    var inputField: some View {
        HStack(spacing: .spacing4) {
            contentRow
                .frame(minHeight: size.contentMinHeight)

            if let trailingButton {
                TrailingButton(
                    size: size,
                    title: trailingButton.title,
                    disable: disable || trailingButton.disable,
                    handler: trailingButton.handler
                )
            }
        }
        .padding(.all, size.containerPadding)
        .frame(minHeight: size.minHeight)
        .onGeometryChange(
            for: CGRect.self,
            of: { proxy in
                guard autoCompletionDataSource != nil else { return .zero }
                return proxy.frame(in: .global)
            },
            action: { textFieldGlobalFrame = $0 }
        )
        .background { fieldBackground }
        .overlay {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .strokeBorder(fieldStrokeColor, lineWidth: 1)
        }
        .background { focusRing }
        .contentShape(RoundedRectangle(cornerRadius: size.cornerRadius))
        .onTapGesture {
            textFieldFocusState = true
        }
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
                    get: {
                        if autoCompletionDataSource == nil || autoCompletionContentHeight == 0 {
                            nil as String?
                        } else {
                            "\(String(describing: autoCompletionDataSource)),\(autoCompletionContentHeight)"
                        }
                    },
                    set: {
                        if $0 == nil {
                            autoCompletionDataSource = nil
                            autoCompletionContentHeight = 0
                        }
                    }
                ),
                dismissPolicy: .onTouchOutside,
                floatView: {
                    SwiftUI.ScrollView {
                        autoCompletionContent
                    }
                    .frame(
                        width: textFieldGlobalFrame.width,
                        height: min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0)
                    )
                    .background(SwiftUI.Color.semantic(.backgroundNormal))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(SwiftUI.Color.semantic(.lineAlternative))
                    }
                    .scrollDisabled(autoCompletionContentHeight <= autoCompletionDataSource?.maxHeight ?? 0)
                    .accessibilityIdentifier("autocomplete_container")
                    .position(
                        x: textFieldGlobalFrame.midX,
                        y: textFieldGlobalFrame.maxY - safeAreaInsets.top
                    )
                    .offset(
                        y: 8 + min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0) / 2
                    )
                }
            )
        )
    }

    @ViewBuilder
    var contentRow: some View {
        HStack(spacing: .spacing2) {
            if let icon {
                Image.icon(icon)
                    .resizable()
                    .frame(width: size.iconSize, height: size.iconSize)
                    .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                    .padding(size.iconPadding)
            }

            SwiftUI.TextField(
                "",
                text: $text,
                prompt: promptText
            )
            .autocorrectionDisabled(fixAutocorrection)
            .font(.font(variant: size.inputVariant, weight: .regular))
            .foregroundStyle(fieldTextColor)
            .focused($textFieldFocusState)
            .padding(.horizontal, .spacing4)
            // 실제 입력 텍스트가 보조 기술에 그대로 노출되도록 value는 덮어쓰지 않는다.
            // 필드의 용도는 placeholder로 라벨링하고, 상태 메시지(오류 등)는 hint로 전달한다.
            .accessibilityLabel(placeholder.map(Text.init) ?? Text(""))
            .accessibilityHint(accessibilityStatusDescription)
            .onChange(of: text) { newValue in
                // 제한 초과 시 앞에서부터 maxLength 글자만 남긴다(문자 단위). text를 다시 쓰면
                // onChange가 잘린 값으로 재호출되므로, onTextChange는 그때 최종 값으로 한 번만 불린다.
                if let maxLength, newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                    return
                }
                onTextChange?(newValue)
            }
            // text가 바뀌지 않아도 maxLength가 더 작아지면 기존 텍스트를 즉시 잘라낸다.
            // 최초 등장 시에도 이미 제한을 넘는 초기 텍스트를 정리한다.
            .onChange(of: maxLength) { _ in clampTextToMaxLength() }
            .onAppear { clampTextToMaxLength() }

            trailingArea
        }
        .padding(.horizontal, .spacing4)
    }

    /// 현재 `text`가 `maxLength`를 초과하면 앞에서부터 제한 글자 수만 남긴다.
    func clampTextToMaxLength() {
        guard let maxLength, text.count > maxLength else { return }
        text = String(text.prefix(maxLength))
    }

    var promptText: Text? {
        guard let placeholder else { return nil }
        return Text(placeholder)
            .typography(
                variant: size.inputVariant,
                weight: .regular,
                color: placeholderTextColor
            )
    }

    @ViewBuilder
    var trailingArea: some View {
        HStack(spacing: .spacing8) {
            if !text.isEmpty, textFieldFocusState {
                IconButton(
                    variant: .normal(size: size.clearButtonSize),
                    icon: .circleCloseFill
                ) {
                    text = ""
                    fixAutocorrection = true
                    Task { fixAutocorrection = false }
                }
                .iconColor(.semantic(.labelAssistive))
            } else if !text.isEmpty, let statusMark, let statusMarkColor {
                Image
                    .icon(statusMark)
                    .resizable()
                    .frame(width: size.iconSize, height: size.iconSize)
                    .foregroundStyle(statusMarkColor)
            }

            trailingContent()
        }
    }

    @ViewBuilder
    var fieldBackground: some View {
        // 둥근 표면을 배경 Shape로 직접 그려 `clipShape`의 오프스크린 마스킹을 제거하고,
        // 그림자는 pure shape(`.fill`)에 적용해 analytic으로 캐스팅한다(별도 오프스크린 패스 없음).
        // 외형(둥근 모서리·머티리얼·옅은 그림자)은 동일하게 유지된다.
        let surface = RoundedRectangle(cornerRadius: size.cornerRadius)
        if disable {
            surface
                .fill(SwiftUI.Color.semantic(.fillAlternative))
                .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
        } else {
            surface
                .fill(
                    colorScheme == .light
                        ? SwiftUI.Color.atomic(.common100).opacity(0.8)
                        : SwiftUI.Color.atomic(.coolNeutral17).opacity(0.61)
                )
                .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
                .background(.ultraThinMaterial, in: surface)
        }
    }

    @ViewBuilder
    var focusRing: some View {
        if textFieldFocusState, disable == false {
            RoundedRectangle(cornerRadius: size.cornerRadius + .spacing4)
                .strokeBorder(focusRingColor, lineWidth: 4)
                .padding(-.spacing4)
        }
    }

    var accessibilityStatusDescription: String {
        switch status {
        case .negative:
            String(localized: "오류", bundle: .module)
        case .positive, .normal:
            ""
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
                                                    .accessibilityIdentifier("autocomplete_item_\(section)_\(item)")
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
        // disable 상태에서는 status와 무관하게 normal과 동일한 border 색상을 사용한다. (negative 포함)
        if disable {
            .semantic(.lineNeutral)
        } else if textFieldFocusState {
            switch status {
            case .normal, .positive:
                .semantic(.linePrimaryStrong)
            case .negative:
                .semantic(.lineNegativeStrong)
            }
        } else {
            switch status {
            case .normal, .positive:
                .semantic(.lineNeutral)
            case .negative:
                .semantic(.lineNegativeNormal)
            }
        }
    }

    var focusRingColor: SwiftUI.Color {
        switch status {
        case .negative:
            .semantic(.interactionNegative)
        case .normal, .positive:
            .semantic(.interactionFocus)
        }
    }

    var statusMark: Icon? {
        switch status {
        case .positive:
            .circleCheckFill
        default:
            nil
        }
    }

    var statusMarkColor: SwiftUI.Color? {
        switch status {
        case .positive:
            .semantic(.statusPositive)
        default:
            nil
        }
    }

    var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.labelDisable) : .semantic(.labelAlternative)
    }
    
    var fieldTextColor: SwiftUI.Color {
        .semantic(.labelNormal)
    }
}

// MARK: - Size Tokens
private extension TextField.Size {
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

    /// Content 영역 최소 높이
    var contentMinHeight: CGFloat {
        switch self {
        case .large: .dimension24
        case .medium: .dimension20
        }
    }

    // clear button 크기
    var clearButtonSize: IconButton.NormalSize {
        switch self {
        case .large: .large
        case .medium: .medium
        }
    }
    
    /// 아이콘 크기
    var iconSize: CGFloat {
        switch self {
        case .large: .dimension20
        case .medium: .dimension18
        }
    }

    /// 아이콘 묶음 내부 패딩
    var iconPadding: CGFloat {
        switch self {
        case .large: .spacing2
        case .medium: .spacing1
        }
    }

    /// 입력 타이포그래피 변형
    var inputVariant: Typography.Variant {
        switch self {
        case .large: .body2
        case .medium: .label1
        }
    }

    /// 트레일링 버튼 좌우 패딩
    var trailingButtonPaddingHorizontal: CGFloat {
        switch self {
        case .large: .spacing12
        case .medium: .spacing10
        }
    }

    /// 트레일링 버튼 상하 패딩
    var trailingButtonPaddingVertical: CGFloat {
        switch self {
        case .large: .spacing8
        case .medium: .spacing6
        }
    }

    /// 트레일링 버튼 모서리 반경
    var trailingButtonRadius: CGFloat {
        switch self {
        case .large: .radius10
        case .medium: .radius8
        }
    }
}

// MARK: - Inner Views
private extension TextField {
    struct TrailingButton: View {
        private let size: Size
        private let title: String
        private let disable: Bool
        private let handler: (() -> Void)?

        init(size: Size, title: String, disable: Bool, handler: (() -> Void)?) {
            self.size = size
            self.title = title
            self.disable = disable
            self.handler = handler
        }

        @State private var isPressed = false

        var body: some View {
            Text(title)
                .paragraph(variant: .caption1, weight: .bold, semantic: textColor)
                .padding(.horizontal, size.trailingButtonPaddingHorizontal)
                .padding(.vertical, size.trailingButtonPaddingVertical)
                .background(
                    Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .labelNormal
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: size.trailingButtonRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: size.trailingButtonRadius)
                        .strokeBorder(SwiftUI.Color.semantic(.lineNeutral), lineWidth: 1)
                }
                .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: disable ? nil : handler))
                .allowsHitTesting(disable == false)
        }

        var textColor: Color.Semantic {
            disable ? .labelDisable : .labelNormal
        }
    }
}
