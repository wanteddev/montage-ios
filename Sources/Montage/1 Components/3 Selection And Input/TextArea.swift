//
//  TextArea.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/24/24.
//

import SwiftUI

/// 여러 줄의 텍스트 입력을 위한 컴포넌트입니다.
///
/// 이 컴포넌트는 사용자가 여러 줄의 텍스트를 입력할 수 있는 영역을 제공합니다.
/// 제목, 배지, 리사이즈 옵션, 캐릭터 카운터 등 다양한 기능을 지원합니다.
///
/// ```swift
/// @State private var longText = ""
/// @FocusState private var isFocused: Bool
///
/// // 기본 텍스트 영역
/// TextArea(text: $longText, focus: $isFocused)
///     .heading("의견")
///     .placeholder("의견을 입력해주세요")
///
/// // 문자 수 제한과 고정 크기를 가진 텍스트 영역
/// TextArea(text: $longText)
///     .resize(.fixed(min: 100, max: 200))
///     .bottomResources(
///         trailing: [.characterCount(limit: 100)]
///     )
///
/// // 필수 항목 표시와 설명이 있는 텍스트 영역
/// TextArea(text: $longText)
///     .heading("상세 설명")
///     .requiredBadge(true)
///     .description("최대한 자세히 작성해주세요")
/// ```
public struct TextArea: View {
    // MARK: - Types
    
    /// 텍스트 영역의 크기 조절 방식을 정의합니다.
    public enum Resize {
        /// 줄 수 제한이 없으며, 입력된 텍스트에 따라 영역이 자동으로 확장됩니다.
        case normal
        /// 최대 8줄까지 표시되며, 초과 부분은 스크롤할 수 있습니다.
        case limit
        /// 텍스트 영역의 최소 및 최대 높이를 지정합니다. 초과 부분은 스크롤할 수 있습니다.
        /// - Parameters:
        ///   - min: 최소 높이
        ///   - max: 최대 높이
        case fixed(min: CGFloat, max: CGFloat)
        
        var minHeight: CGFloat? {
            switch self {
            case .normal: 36.0
            case .limit: 36.0
            case .fixed(let min, _): min
            }
        }
        
        var maxHeight: CGFloat? {
            switch self {
            case .normal: .infinity
            case .limit: 102.0
            case .fixed(_, let max): max
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .normal, .limit: .center
            case .fixed: .topLeading
            }
        }
    }
    
    /// 텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.
    ///
    /// 다양한 종류의 컴포넌트를 텍스트 영역 하단에 배치할 수 있습니다.
    /// 문자 수 카운터, 버튼, 아이콘, 칩, 뱃지 등을 지원합니다.
    ///
    /// - Note: 문자 수 카운터는 좌/우측 중 하나에만 사용 가능합니다. 중복 사용 시 좌측이 우선 표시됩니다.
    public enum Resource {
        /// 요소의 배치 위치를 정의합니다.
        public enum Placement {
            /// 왼쪽에 배치
            case leading
            /// 오른쪽에 배치
            case trailing
        }
        
        /// 문자 수 카운터
        /// - Parameters:
        ///   - limit: 최대 문자 수 제한, 생략하면 기본값으로 `nil` 적용 (제한 없음)
        ///   - overflow: 최대 문자 수 초과 허용 여부, 생략하면 기본값으로 `false` 적용
        case characterCount(limit: Int? = nil, overflow: Bool = false)
        
        /// 텍스트 버튼
        /// - Parameters:
        ///   - placement: 버튼 위치, 생략하면 기본값으로 `.leading` 적용
        ///   - variant: 버튼 변형 스타일, 생략하면 기본값으로 `.assistive` 적용
        ///   - title: 버튼 텍스트
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case textButton(
            placement: Placement = .leading,
            variant: TextButton.Color? = .assistive,
            title: String,
            handler: (() -> Void)? = nil
        )
        
        /// 아이콘 버튼
        /// - Parameters:
        ///   - placement: 버튼 위치, 생략하면 기본값으로 `.leading` 적용
        ///   - variant: 버튼 변형 스타일, 생략하면 기본값으로 `.solid(size: .small)` 적용
        ///   - icon: 버튼 아이콘
        ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.labelAlternative)` 적용
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case iconButton(
            placement: Placement = .leading,
            variant: IconButton.Variant? = .solid(size: .small),
            icon: Icon,
            tintColor: SwiftUI.Color = .semantic(.labelAlternative),
            handler: (() -> Void)? = nil
        )
        
        /// 단순 아이콘
        /// - Parameters:
        ///   - icon: 표시할 아이콘
        ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.labelAssistive)` 적용
        case icon(
            _ icon: Icon,
            tintColor: SwiftUI.Color = .semantic(.labelAssistive)
        )
        
        /// 칩
        /// - Parameters:
        ///   - variant: 칩 변형 스타일, 생략하면 기본값으로 `.solid` 적용
        ///   - title: 칩 텍스트
        ///   - handler: 칩 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case chip(
            _ variant: Chip.Variant = .solid,
            title: String,
            handler: (() -> Void)? = nil
        )
        
        /// 필터 버튼
        /// - Parameters:
        ///   - variant: 버튼 변형 스타일, 생략하면 기본값으로 `.solid` 적용
        ///   - title: 버튼 텍스트
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case filterButton(
            _ variant: FilterButton.Variant = .solid,
            title: String,
            handler: (() -> Void)? = nil
        )
        
        /// 뱃지
        /// - Parameters:
        ///   - variant: 뱃지 변형 스타일, 생략하면 기본값으로 `.solid` 적용
        ///   - title: 뱃지 텍스트
        case badge(
            _ variant: ContentBadge.Variant = .solid,
            title: String
        )
        
        var isCharacterCount: Bool {
            if case .characterCount = self {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: - Initializer
    
    @Binding private var text: String
    private var exposedFocusState: FocusState<Bool>.Binding?
    
    /// 텍스트 영역을 초기화합니다.
    ///
    /// - Parameters:
    ///   - text: 텍스트 영역의 값을 바인딩
    ///   - focus: 텍스트 영역의 포커스 상태를 바인딩, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 구성된 텍스트 영역 인스턴스
    public init(
        text: Binding<String>,
        focus: FocusState<Bool>.Binding? = nil
    ) {
        _text = text
        exposedFocusState = focus
    }
    
    // MARK: - Modifiers
    
    private var resize: Resize = .normal
    private var negative = false
    private var disable = false
    private var heading: String? = nil
    private var requiredBadge = false
    private var description: String? = nil
    private var placeholder: String? = nil
    private var leadingResources: [Resource] = []
    private var trailingResources: [Resource] = []
    private var leadingResourceSpacing: CGFloat = 4
    private var trailingResourceSpacing: CGFloat = 4
    private var characterCounterLimit: Int?
    private var characterCounterOverflow: Bool = false
    
    /// 텍스트 영역의 크기 조절 방식을 설정합니다.
    ///
    /// - Parameter resize: 크기 조절 방식
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func resize(_ resize: Resize) -> Self {
        var zelf = self
        zelf.resize = resize
        return zelf
    }
    
    /// 텍스트 영역의 오류 상태를 설정합니다.
    ///
    /// 오류 상태일 때는 텍스트 영역이 적색 테두리로 강조됩니다.
    ///
    /// - Parameter negative: 오류 상태 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func negative(_ negative: Bool = true) -> Self {
        var zelf = self
        zelf.negative = negative
        return zelf
    }
    
    /// 텍스트 영역의 활성화 상태를 설정합니다.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 텍스트 영역 위에 표시할 제목을 설정합니다.
    ///
    /// - Parameter heading: 표시할 제목, nil이면 제목 표시 안함
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func heading(_ heading: String?) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.
    ///
    /// - Parameter requiredBadge: 필수 입력 뱃지 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 텍스트 영역 인스턴스
    /// - Note: 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다.
    public func requiredBadge(_ requiredBadge: Bool = true) -> Self {
        var zelf = self
        zelf.requiredBadge = requiredBadge
        return zelf
    }
    
    /// 텍스트 영역 하단에 표시할 UI 요소를 설정합니다.
    ///
    /// - Parameters:
    ///   - leadingResources: 왼쪽에 표시할 UI 요소 배열 (최대 3개)
    ///   - trailingResources: 오른쪽에 표시할 UI 요소 배열 (최대 3개)
    ///   - leadingResourceSpacing: 왼쪽 요소 간의 간격
    ///   - trailingResourceSpacing: 오른쪽 요소 간의 간격
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func bottomResources(
        leading leadingResources: [Resource] = [],
        trailing trailingResources: [Resource] = [],
        leadingResourceSpacing: CGFloat = 4,
        trailingResourceSpacing: CGFloat = 4
    ) -> Self {
        var zelf = self
        zelf.leadingResources = Array(leadingResources.prefix(3))
        zelf.leadingResourceSpacing = leadingResourceSpacing
        
        zelf.trailingResources = Array(trailingResources.prefix(3))
        zelf.trailingResourceSpacing = trailingResourceSpacing
        
        let bottomResources = zelf.leadingResources + zelf.filteredTrailingResources
        if let characterCounter = bottomResources.first(where: \.isCharacterCount),
           case let .characterCount(limit, overflow) = characterCounter {
            zelf.characterCounterLimit = limit
            zelf.characterCounterOverflow = overflow
        } else {
            zelf.characterCounterLimit = nil
            zelf.characterCounterOverflow = false
        }
        return zelf
    }
    
    /// 텍스트 영역 하단에 표시할 설명 텍스트를 설정합니다.
    ///
    /// - Parameter description: 표시할 설명 텍스트, nil이면 표시 안함
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func description(_ description: String?) -> Self {
        var zelf = self
        zelf.description = description
        return zelf
    }
    
    /// 텍스트 영역에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.
    ///
    /// - Parameter placeholder: 표시할 플레이스홀더 텍스트
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func placeholder(_ placeholder: String?) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }
    
    // MARK: - Body
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var typedCharacters = 0
    @FocusState private var internalFocusState
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let heading {
                HStack(spacing: 4) {
                    Text(heading)
                        .typography(variant: .label1, weight: .bold, semantic: .labelNeutral)
                    if requiredBadge {
                        Text("*")
                            .typography(variant: .label1, weight: .medium, semantic: .statusNegative)
                    }
                }
            }
            
            editor
            
            if let description {
                Text(description)
                    .typography(
                        variant: .caption1,
                        semantic: negative ? .statusNegative : .labelAlternative
                    )
            }
        }
    }
    
    // MARK: - Private
    
    var editor: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                UITextViewWrapper(text: $text)
                    .characterCountLimit(characterCounterLimit)
                    .characterCountOverflow(characterCounterOverflow)
                    .frameHeight(
                        minHeight: resize.minHeight,
                        maxHeight: resize.maxHeight
                    )
                    .frame(
                        minHeight: resize.minHeight,
                        maxHeight: resize.maxHeight,
                        alignment: resize.alignment
                    )
                    .foregroundStyle(editorTextColor)
                    .font(.font(variant: .body1Reading))
                    .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                    .if(!disable) {
                        $0.focused(focus)
                    }
                    .onChange(of: text) { _ in
                        typedCharacters = text.count
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, -4.5)
                    .padding(.top, -4)
                    .padding(.bottom, -6)
                    .onAppear {
                        typedCharacters = text.count
                    }
                    .onChange(of: characterCounterLimit) { limit in
                        updateText(limit: limit, overflow: characterCounterOverflow)
                    }
                    .onChange(of: characterCounterOverflow) { overflow in
                        updateText(limit: characterCounterLimit, overflow: overflow)
                    }
                
                if $text.wrappedValue.isEmpty, let placeholder {
                    Text(placeholder)
                        .paragraph(
                            variant: .body1Reading,
                            color: placeholderTextColor
                        )
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 4)
            
            if leadingResources.isEmpty == false || trailingResources.isEmpty == false {
                Bottom(
                    typedCharacters: $typedCharacters,
                    disable,
                    leadingResources,
                    leadingResourceSpacing,
                    filteredTrailingResources,
                    trailingResourceSpacing
                )
            }
        }
        .padding(.all, 12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(editorStrokeColor, lineWidth: focus.wrappedValue ? 2 : 1)
        }
        .background {
            if disable {
                SwiftUI.Color.semantic(.fillAlternative)
            } else {
                if colorScheme == .light {
                    SwiftUI.Color.atomic(.common100).opacity(0.6)
                        .background(.ultraThinMaterial)
                } else {
                    SwiftUI.Color.atomic(.coolNeutral17).opacity(0.61)
                        .background(.ultraThinMaterial)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .allowsHitTesting(disable == false)
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            focus.wrappedValue = true
        }
    }
    
    private var editorStrokeColor: SwiftUI.Color {
        if negative {
            SwiftUI.Color.semantic(.statusNegative).opacity(0.43)
        } else {
            focus.wrappedValue ? SwiftUI.Color.semantic(.primaryNormal).opacity(0.43) : SwiftUI.Color
                .semantic(.lineNormal)
        }
    }
    
    private var focus: FocusState<Bool>.Binding {
        exposedFocusState ?? $internalFocusState
    }
    
    private var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.labelDisable) : .semantic(.labelAssistive)
    }
    
    private var editorTextColor: SwiftUI.Color {
        disable ? .semantic(.labelAlternative) : .semantic(.labelNormal)
    }
    
    private var filteredTrailingResources: [Resource] {
        if leadingResources.contains(where: \.isCharacterCount) &&
            trailingResources.contains(where: \.isCharacterCount)
        {
            trailingResources.filter { $0.isCharacterCount == false }
        } else {
            trailingResources
        }
    }
    
    private func updateText(limit: Int?, overflow: Bool) {
        if !overflow && text.count > (limit ?? .max) {
            text = String(text.prefix(limit ?? .max))
        }
    }
    
    // MARK: - Inner View
    
    private struct Bottom: View {
        @Binding private var typedCharacters: Int
        
        private let disable: Bool
        private let leadingResources: [Resource]
        private let leadingResourceSpacing: CGFloat
        private let trailingResources: [Resource]
        private let trailingResourceSpacing: CGFloat
        
        init(
            typedCharacters: Binding<Int>,
            _ disable: Bool,
            _ leadingResources: [Resource],
            _ leadingResourceSpacing: CGFloat,
            _ trailingResources: [Resource],
            _ trailingResourceSpacing: CGFloat
        ) {
            _typedCharacters = typedCharacters
            self.disable = disable
            self.leadingResources = leadingResources
            self.leadingResourceSpacing = leadingResourceSpacing
            self.trailingResources = trailingResources
            self.trailingResourceSpacing = trailingResourceSpacing
        }
        
        var body: some View {
            HStack {
                if leadingResources.isEmpty == false {
                    HStack(spacing: leadingResourceSpacing) {
                        ForEach(leadingResources.indices, id: \.self) { index in
                            component(leadingResources[index])
                        }
                    }
                }
                Spacer()
                if trailingResources.isEmpty == false {
                    HStack(spacing: trailingResourceSpacing) {
                        ForEach(trailingResources.indices, id: \.self) { index in
                            component(trailingResources[index])
                        }
                    }
                }
            }
        }
        
        @ViewBuilder
        func component(_ resource: Resource) -> some View {
            switch resource {
            case .characterCount(let limit, let overflow):
                HStack(spacing: 0) {
                    Text(String(typedCharacters))
                        .paragraph(
                            variant: .label2,
                            weight: .medium,
                            semantic: disable ? .labelDisable : (
                                overflow && typedCharacters > (limit ?? .max)
                                ? .statusNegative
                                : .labelAlternative
                            )
                        )
                    if let limit {
                        Text("/\(String(limit))")
                            .paragraph(
                                variant: .label2,
                                weight: .medium,
                                semantic: disable ? .labelDisable : .labelAlternative
                            )
                    }
                }
                .padding(.horizontal, 4)
            case let .textButton(placement, variant, title, handler):
                TextButton(
                    color: {
                        if let variant {
                            variant
                        } else {
                            switch placement {
                            case .leading: .assistive
                            case .trailing: .primary
                            }
                        }
                    }(),
                    size: .medium,
                    text: title,
                    handler: handler
                )
                .frame(maxHeight: 24)
                .padding(.horizontal, 4)
            case let .iconButton(placement, variant, icon, tintColor, handler):
                IconButton(
                    variant: {
                        if let variant {
                            variant
                        } else {
                            switch placement {
                            case .leading: .outlined(size: .medium)
                            case .trailing: .solid(size: .small)
                            }
                        }
                    }(),
                    icon: icon,
                    handler: handler
                )
                .iconColor(tintColor)
            case let .icon(icon, tintColor):
                Image.icon(icon)
                    .resizable()
                    .foregroundColor(tintColor)
                    .frame(width: 22, height: 22)
            case let .chip(variant, title, handler):
                Chip(
                    variant: variant,
                    size: .small,
                    text: title,
                    handler: handler
                )
            case let .filterButton(variant, title, handler):
                FilterButton(
                    variant: variant,
                    size: .small,
                    text: title,
                    handler: handler
                )
            case let .badge(variant, title):
                ContentBadge(variant: variant, text: title)
                    .size(.medium)
                    .colorStyle(.neutral())
            }
        }
    }
    
    struct UITextViewWrapper: UIViewRepresentable {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.delegate = context.coordinator
            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            if uiView.text != text {
                uiView.text = text
            }
            if context.coordinator.parent.text != text {
                DispatchQueue.main.async {
                    context.coordinator.parent.text = text
                }
            }
            context.coordinator.parent.limit = limit
            context.coordinator.parent.overflow = overflow
            context.coordinator.minHeight = minHeight
            context.coordinator.maxHeight = maxHeight
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UITextViewDelegate {
            var parent: UITextViewWrapper
            var minHeight: CGFloat?
            var maxHeight: CGFloat?
            private var heightConstraint: NSLayoutConstraint?
            
            init(_ parent: UITextViewWrapper) {
                self.parent = parent
            }
            
            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if let limit = parent.limit, !parent.overflow {
                    let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
                    if newText.count > limit {
                        return false
                    }
                }
                return true
            }

            func textViewDidBeginEditing(_ textView: UITextView) {
                textView.isScrollEnabled = textView.contentSize.height > (maxHeight ?? .greatestFiniteMagnitude)
            }
            
            func textViewDidChange(_ textView: UITextView) {
                let parentText = parent.text
                textView.isScrollEnabled = textView.contentSize.height > (maxHeight ?? .greatestFiniteMagnitude)
                parent.text = textView.text
                // Binding된 값이 변하지 않으면, TextView에 Binding된 값 표시
                if parentText == parent.text {
                    textView.text = parentText
                }
            }
        }
        
        public func sizeThatFits(
            _ proposal: ProposedViewSize,
            uiView: UIViewType,
            context _: Context
        ) -> CGSize? {
            var newSize = uiView.sizeThatFits(
                CGSize(width: proposal.width ?? uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            )
            newSize.height = min(max(newSize.height, minHeight ?? 0), maxHeight ?? .greatestFiniteMagnitude)
            return CGSize(
                width: proposal.width ?? uiView.bounds.width,
                height: newSize.height
            )
        }
        
        private var limit: Int?
        private var overflow: Bool = false
        private var minHeight: CGFloat?
        private var maxHeight: CGFloat?
        
        func characterCountLimit(_ limit: Int?) -> Self {
            var zelf = self
            zelf.limit = limit
            return zelf
        }
        
        func characterCountOverflow(_ overflow: Bool) -> Self {
            var zelf = self
            zelf.overflow = overflow
            return zelf
        }
        
        func frameHeight(minHeight: CGFloat?, maxHeight: CGFloat?) -> Self {
            var zelf = self
            zelf.minHeight = minHeight
            zelf.maxHeight = maxHeight
            return zelf
        }
    }
    
    class CustomTextView: UITextView {
        override var intrinsicContentSize: CGSize {
            sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        }
    }
}
