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
/// 사이즈, 리사이즈 옵션, 하단 리소스 등 다양한 기능을 지원합니다.
///
/// ```swift
/// @State private var longText = ""
/// @FocusState private var isFocused: Bool
///
/// // 기본 텍스트 영역
/// TextArea(text: $longText, focus: $isFocused)
///     .placeholder("의견을 입력해주세요")
///
/// // 중간 사이즈와 고정 크기를 가진 텍스트 영역
/// TextArea(text: $longText)
///     .size(.medium)
///     .resize(.fixed(min: 108, max: 200))
///
/// // 입력 글자 수를 추적하는 텍스트 영역
/// @State private var characterCount = 0
/// TextArea(text: $longText)
///     .maxLength(100)
///     .onTextChange { characterCount = $0.count }
/// ```
public struct TextArea: View {
    // MARK: - Types

    /// 텍스트 영역의 사이즈를 정의합니다.
    ///
    /// 사이즈에 따라 모서리 반경, 최소 콘텐츠 높이, 입력 타이포그래피, 하단 리소스 크기가 함께 결정됩니다.
    public enum Size {
        /// 큰 사이즈 (입력 `body2`, 최소 콘텐츠 높이 48)
        case large
        /// 중간 사이즈 (입력 `label1`, 최소 콘텐츠 높이 44)
        case medium
    }

    /// 텍스트 영역의 크기 조절 방식을 정의합니다.
    public enum Resize {
        /// 줄 수 제한이 없으며, 입력된 텍스트에 따라 영역이 자동으로 확장됩니다. 최소 높이는 2줄 기준입니다.
        case normal
        /// 최대 6줄까지 표시되며, 초과 부분은 스크롤할 수 있습니다. 최소 높이는 2줄 기준입니다.
        case limit
        /// 텍스트 영역의 최소 및 최대 높이를 지정합니다. 초과 부분은 스크롤할 수 있습니다.
        /// - Parameters:
        ///   - min: 최소 높이
        ///   - max: 최대 높이
        case fixed(min: CGFloat, max: CGFloat)

        var alignment: Alignment {
            switch self {
            case .normal, .limit: .center
            case .fixed: .topLeading
            }
        }
    }

    /// 텍스트 영역 하단(Bottom Content)에 표시할 수 있는 UI 요소를 정의합니다.
    ///
    /// 프리셋(``button``·``iconButton``·``icon``·``contentBadge``·``segmentedControl``·
    /// ``primaryIconButton``)과 임의 뷰(``slot(_:)``)를 지원합니다. 각 요소의 크기는 TextArea의
    /// ``Size``에 따라 자동으로 조정됩니다.
    ///
    /// - Note: 디자인 가이드 기준 `button`·`primaryIconButton`은 trailing 전용으로 권장됩니다.
    public enum Resource {
        /// 텍스트 버튼(Outlined)
        /// - Parameters:
        ///   - color: 버튼 색상, 생략하면 기본값으로 `.assistive` 적용
        ///   - title: 버튼 텍스트
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case button(
            color: Button.Color = .assistive,
            title: String,
            handler: (() -> Void)? = nil
        )

        /// 아이콘 버튼(배경 없음)
        /// - Parameters:
        ///   - icon: 버튼 아이콘
        ///   - tintColor: 아이콘 색상, 생략하면 기본값으로 `.semantic(.labelAlternative)` 적용
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case iconButton(
            icon: Icon,
            tintColor: SwiftUI.Color = .semantic(.labelAlternative),
            handler: (() -> Void)? = nil
        )

        /// Primary 아이콘 버튼(Solid)
        /// - Parameters:
        ///   - icon: 버튼 아이콘
        ///   - handler: 버튼 클릭 핸들러, 생략하면 기본값으로 `nil` 적용
        case primaryIconButton(
            icon: Icon,
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

        /// 콘텐츠 뱃지
        /// - Parameters:
        ///   - variant: 뱃지 변형 스타일, 생략하면 기본값으로 `.solid` 적용
        ///   - title: 뱃지 텍스트
        case contentBadge(
            _ variant: ContentBadge.Variant = .solid,
            title: String
        )

        /// 세그먼트 컨트롤(아이콘 전용). Bottom Content 전용 크기로 렌더링되며 정방형 아이콘만 받습니다.
        ///
        /// 아이콘만 노출되므로 VoiceOver 사용자를 위해 세그먼트별 `accessibilityLabels`를 함께 전달하는 것을 권장합니다.
        /// 라벨을 생략하거나 개수가 부족하면 해당 세그먼트는 아이콘 이름으로 대체됩니다.
        /// - Parameters:
        ///   - selectedIndex: 선택된 세그먼트 인덱스 바인딩
        ///   - icons: 세그먼트 아이콘 배열
        ///   - accessibilityLabels: 세그먼트별 VoiceOver 라벨 배열, 생략하면 기본값으로 `[]` 적용
        ///   - onSelect: 선택 변경 핸들러, 생략하면 기본값으로 `nil` 적용
        case segmentedControl(
            selectedIndex: Binding<Int>,
            icons: [Icon],
            accessibilityLabels: [String] = [],
            onSelect: ((Int) -> Void)? = nil
        )

        /// 임의 뷰. `.slot { ... }` 팩토리로 생성합니다.
        case slotView(() -> AnyView)

        /// 임의 뷰를 Bottom Content에 배치합니다.
        ///
        /// - Parameter content: 표시할 뷰를 생성하는 클로저
        /// - Returns: 구성된 리소스
        public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Resource {
            .slotView { AnyView(content()) }
        }

        /// leading(왼쪽)에 배치할 수 있는 리소스인지 여부. `button`·`primaryIconButton`은 trailing 전용입니다.
        public var isLeadingAllowed: Bool {
            switch self {
            case .button, .primaryIconButton: false
            default: true
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

    private var size: Size = .large
    private var resize: Resize = .normal
    private var negative = false
    private var disable = false
    private var placeholder: String? = nil
    private var leadingResources: [Resource] = []
    private var trailingResources: [Resource] = []
    private var leadingResourceSpacing: CGFloat = 4
    private var trailingResourceSpacing: CGFloat = 4
    private var maxLength: Int?
    private var inputTransform: ((String) -> String)?
    private var onTextChange: ((String) -> Void)?

    /// 텍스트 영역의 사이즈를 설정합니다.
    ///
    /// - Parameter size: 텍스트 영역의 사이즈
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// 텍스트 영역의 크기 조절 방식을 설정합니다.
    ///
    /// - Parameter resize: 크기 조절 방식
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func resize(_ resize: Resize) -> Self {
        var zelf = self
        zelf.resize = resize
        return zelf
    }

    /// 최대 글자 수를 설정합니다.
    ///
    /// 카운터 UI를 표시하지 않고 입력 길이만 제한합니다. 사후 변형이 아닌 입력 단계에서
    /// 제한하므로 UITextView의 텍스트와 UndoManager가 일관되게 유지되며, 초과 입력/붙여넣기는
    /// 허용분만 잘라서 삽입됩니다.
    ///
    /// - Parameter limit: 최대 글자 수, nil이면 제한 없음
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func maxLength(_ limit: Int?) -> Self {
        var zelf = self
        // 음수가 들어오면 String.prefix(_:)가 런타임 트랩을 일으키므로 진입점에서 0 이상으로 정규화한다.
        zelf.maxLength = limit.map { max(0, $0) }
        return zelf
    }

    /// 입력되는 텍스트를 입력 시점에 변환할 클로저를 설정합니다.
    ///
    /// 사용자가 입력하거나 붙여넣는 텍스트(replacement) 조각에 적용됩니다. emoji 제거 등
    /// 도메인별 정규화에 사용합니다. 사후 변형이 아닌 입력 단계에서 적용되므로 UITextView의
    /// 텍스트와 UndoManager가 일관되게 유지됩니다.
    ///
    /// - Parameter transform: 입력 조각을 변환하는 클로저, nil이면 변환하지 않음
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func inputTransform(_ transform: ((String) -> String)?) -> Self {
        var zelf = self
        zelf.inputTransform = transform
        return zelf
    }

    /// 텍스트가 변경될 때마다 호출할 클로저를 설정합니다.
    ///
    /// 변경된 전체 텍스트를 전달하므로 글자 수 계산(`text.count`), 유효성 검사 등 다양한 후처리에
    /// 사용할 수 있습니다.
    ///
    /// - Parameter handler: 변경된 텍스트를 전달받는 클로저
    /// - Returns: 수정된 텍스트 영역 인스턴스
    public func onTextChange(_ handler: @escaping (String) -> Void) -> Self {
        var zelf = self
        zelf.onTextChange = handler
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

    /// 텍스트 영역 하단에 표시할 UI 요소를 설정합니다.
    ///
    /// - Parameters:
    ///   - leadingResources: 왼쪽에 표시할 UI 요소 배열 (최대 3개)
    ///   - trailingResources: 오른쪽에 표시할 UI 요소 배열 (최대 3개)
    ///   - leadingResourceSpacing: 왼쪽 요소 간의 간격
    ///   - trailingResourceSpacing: 오른쪽 요소 간의 간격
    /// - Returns: 수정된 텍스트 영역 인스턴스
    /// - Note: `button`·`primaryIconButton`은 디자인 가이드상 trailing 전용이므로 leading에 전달되면 무시됩니다.
    public func bottomResources(
        leading leadingResources: [Resource] = [],
        trailing trailingResources: [Resource] = [],
        leadingResourceSpacing: CGFloat = 4,
        trailingResourceSpacing: CGFloat = 4
    ) -> Self {
        var zelf = self
        // leading 전용 제약: trailing 전용 프리셋은 걸러낸다.
        zelf.leadingResources = Array(leadingResources.filter(\.isLeadingAllowed).prefix(3))
        zelf.leadingResourceSpacing = leadingResourceSpacing

        zelf.trailingResources = Array(trailingResources.prefix(3))
        zelf.trailingResourceSpacing = trailingResourceSpacing
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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @FocusState private var internalFocusState

    /// 최소로 보장하는 줄 수.
    private let minRows = 2
    /// `.limit`에서 허용하는 최대 줄 수.
    private let maxRows = 6

    /// 입력 폰트(사이즈별 `body2`/`label1`)의 한 줄 높이. `UIFont.font`이 Dynamic Type 스케일 폰트를
    /// 반환하므로 글자 크기 설정에 따라 값이 달라진다. UITextView는 디자인 lineSpacing이 아닌 폰트의
    /// 자연 줄높이로 렌더링하므로, 정확한 줄 수를 맞추려면 이 값을 기준으로 높이를 계산해야 한다.
    private var lineHeightUnit: CGFloat {
        UIFont.font(variant: size.inputVariant).lineHeight
    }

    /// UITextView 기본 `textContainerInset`(상·하 각 8pt)의 합.
    private var verticalContainerInset: CGFloat { 16 }

    /// 지정한 줄 수가 온전히 보이도록 하는 프레임 높이.
    private func height(forRows rows: Int) -> CGFloat {
        ceil(lineHeightUnit * CGFloat(rows) + verticalContainerInset)
    }

    /// resize 방식에 따른 최소 높이. `.normal`/`.limit`은 **2줄 기준**이며 폰트 줄높이로 계산되어
    /// Dynamic Type 변경에도 항상 정확히 2줄을 보장한다. `.fixed`는 호출자가 지정한 픽셀값을 그대로 쓴다.
    private var resolvedMinHeight: CGFloat? {
        _ = dynamicTypeSize // Dynamic Type 변경 시 높이 재계산을 위한 의존성 등록
        switch resize {
        case .normal, .limit:
            return height(forRows: minRows)
        case .fixed(let min, _):
            return min
        }
    }

    /// resize 방식에 따른 최대 높이. `.limit`은 폰트 줄높이 기준 6줄로 계산되어 Dynamic Type 변경에도
    /// 항상 정확히 6줄을 유지한다.
    private var resolvedMaxHeight: CGFloat? {
        _ = dynamicTypeSize
        switch resize {
        case .normal: return .infinity
        case .limit: return height(forRows: maxRows)
        case .fixed(_, let max): return max
        }
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        editor
    }

    // MARK: - Private

    var editor: some View {
        VStack(spacing: size.contentBottomGap) {
            ZStack(alignment: .topLeading) {
                UITextViewWrapper(text: $text, inputVariant: size.inputVariant)
                    .inputLimit(maxLength)
                    .inputTransform(inputTransform)
                    .frameHeight(
                        minHeight: resolvedMinHeight,
                        maxHeight: resolvedMaxHeight
                    )
                    .frame(
                        minHeight: resolvedMinHeight,
                        maxHeight: resolvedMaxHeight,
                        alignment: resize.alignment
                    )
                    .foregroundStyle(editorTextColor)
                    .font(.font(variant: size.inputVariant))
                    .lineSpacing(size.inputVariant.lineSpacing)
                    .if(!disable) {
                        $0.focused(focus)
                    }
                    .onChange(of: text) { newValue in
                        onTextChange?(newValue)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, -4.5)
                    .padding(.top, -4)
                    .padding(.bottom, -6)
                    .onAppear {
                        onTextChange?(text)
                    }

                if $text.wrappedValue.isEmpty, let placeholder {
                    Text(placeholder)
                        .paragraph(
                            variant: size.inputVariant,
                            color: placeholderTextColor
                        )
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, size.contentPaddingX)

            if leadingResources.isEmpty == false || trailingResources.isEmpty == false {
                Bottom(
                    size,
                    disable,
                    leadingResources,
                    leadingResourceSpacing,
                    trailingResources,
                    trailingResourceSpacing
                )
            }
        }
        .padding(.all, size.containerPadding)
        // fill 배경은 자체적으로 cornerRadius로 clip한다. 최상위에 clipShape을 걸면 테두리 바깥으로
        // 그려지는 focusRing(-4 padding)이 함께 잘리므로 여기서만 clip한다.
        .background { editorBackground }
        .overlay {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .strokeBorder(editorStrokeColor, lineWidth: 1)
        }
        // focusRing은 어떤 clip보다 뒤(=바깥)에 그려져야 테두리 밖으로 번질 수 있다.
        .background { focusRing }
        .allowsHitTesting(disable == false)
        .contentShape(RoundedRectangle(cornerRadius: size.cornerRadius))
        .onTapGesture {
            focus.wrappedValue = true
        }
        .accessibilityValue(negative ? String(localized: "오류", bundle: .module) : "")
    }

    @ViewBuilder
    private var editorBackground: some View {
        Group {
            if disable {
                SwiftUI.Color.semantic(.fillAlternative)
            } else {
                if colorScheme == .light {
                    SwiftUI.Color.atomic(.common100).opacity(0.8)
                        .background(.ultraThinMaterial)
                } else {
                    SwiftUI.Color.atomic(.coolNeutral17).opacity(0.61)
                        .background(.ultraThinMaterial)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }

    /// 포커스 시 테두리 바깥에 표시되는 4px Focus Ring. TextField와 동일한 메커니즘이며,
    /// negative 상태에서는 빨간 ring을 사용한다.
    @ViewBuilder
    private var focusRing: some View {
        if focus.wrappedValue, disable == false {
            RoundedRectangle(cornerRadius: size.cornerRadius + 4)
                .strokeBorder(focusRingColor, lineWidth: 4)
                .padding(-4)
        }
    }

    private var focusRingColor: SwiftUI.Color {
        negative
            ? SwiftUI.Color.semantic(.interactionNegative)
            : SwiftUI.Color.semantic(.interactionFocus)
    }

    private var editorStrokeColor: SwiftUI.Color {
        if disable {
            SwiftUI.Color.semantic(.lineAlternative)
        } else if negative {
            SwiftUI.Color.semantic(.lineNegativeStrong)
        } else if focus.wrappedValue {
            SwiftUI.Color.semantic(.linePrimaryStrong)
        } else {
            SwiftUI.Color.semantic(.lineNeutral)
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

    // MARK: - Inner View

    private struct Bottom: View {
        private let size: Size
        private let disable: Bool
        private let leadingResources: [Resource]
        private let leadingResourceSpacing: CGFloat
        private let trailingResources: [Resource]
        private let trailingResourceSpacing: CGFloat

        init(
            _ size: Size,
            _ disable: Bool,
            _ leadingResources: [Resource],
            _ leadingResourceSpacing: CGFloat,
            _ trailingResources: [Resource],
            _ trailingResourceSpacing: CGFloat
        ) {
            self.size = size
            self.disable = disable
            self.leadingResources = leadingResources
            self.leadingResourceSpacing = leadingResourceSpacing
            self.trailingResources = trailingResources
            self.trailingResourceSpacing = trailingResourceSpacing
        }

        // Bottom Content는 내부 요소 높이에 맞춰 가변되며(고정 minHeight 없음), 요소는 하단 정렬한다.
        var body: some View {
            HStack(alignment: .bottom) {
                if leadingResources.isEmpty == false {
                    HStack(spacing: leadingResourceSpacing) {
                        ForEach(leadingResources.indices, id: \.self) { index in
                            component(leadingResources[index])
                        }
                    }
                }
                Spacer(minLength: 0)
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
            case let .button(color, title, handler):
                Button(
                    variant: .outlined,
                    color: color,
                    size: size.buttonSize,
                    text: title,
                    handler: handler
                )
            case let .iconButton(icon, tintColor, handler):
                IconButton(
                    variant: .normal(size: size.normalIconButtonSize),
                    icon: icon,
                    handler: handler
                )
                .iconColor(tintColor)
            case let .primaryIconButton(icon, handler):
                Button(
                    variant: .solid,
                    color: .primary,
                    size: size.buttonSize,
                    icon: icon,
                    handler: handler
                )
            case let .icon(icon, tintColor):
                Image.icon(icon)
                    .resizable()
                    .foregroundColor(tintColor)
                    .frame(width: size.resourceIconSize, height: size.resourceIconSize)
            case let .contentBadge(variant, title):
                ContentBadge(variant: variant, text: title)
                    .size(size.contentBadgeSize)
                    .colorStyle(.neutral())
            case let .segmentedControl(selectedIndex, icons, accessibilityLabels, onSelect):
                BottomSegmentedControl(
                    selectedIndex: selectedIndex,
                    icons: icons,
                    accessibilityLabels: accessibilityLabels,
                    size: size,
                    onSelect: onSelect
                )
            case let .slotView(content):
                content()
            }
        }
    }

    /// Bottom Content 전용 아이콘 세그먼트 컨트롤.
    ///
    /// 표준 ``SegmentedControl``과 달리 정방형 아이콘만 받으며, TextArea의 ``Size``에 맞춰
    /// 더 작은 크기로 렌더링된다. 선택 스타일(elevated 배경 + shadow)은 표준 컨트롤과 동일하다.
    private struct BottomSegmentedControl: View {
        @Binding private var selectedIndex: Int
        private let icons: [Icon]
        private let accessibilityLabels: [String]
        private let size: Size
        private let onSelect: ((Int) -> Void)?

        init(
            selectedIndex: Binding<Int>,
            icons: [Icon],
            accessibilityLabels: [String],
            size: Size,
            onSelect: ((Int) -> Void)?
        ) {
            _selectedIndex = selectedIndex
            self.icons = icons
            self.accessibilityLabels = accessibilityLabels
            self.size = size
            self.onSelect = onSelect
        }

        private let containerRadius: CGFloat = 8
        private let segmentRadius: CGFloat = 6
        private let inset: CGFloat = 2

        private var segmentSide: CGFloat { size.segmentControlHeight - inset * 2 }

        var body: some View {
            HStack(spacing: 0) {
                ForEach(icons.indices, id: \.self) { index in
                    segment(index)
                }
            }
            // 선택 인디케이터는 표준 SegmentedControl과 동일하게 단일 뷰가 offset으로 슬라이드한다.
            .background(alignment: .leading) { indicator }
            .padding(inset)
            .background {
                RoundedRectangle(cornerRadius: containerRadius)
                    .foregroundStyle(SwiftUI.Color.semantic(.fillNormal))
            }
        }

        private var indicator: some View {
            ZStack {
                RoundedRectangle(cornerRadius: segmentRadius)
                    .foregroundStyle(SwiftUI.Color.semantic(.backgroundElevated))
                RoundedRectangle(cornerRadius: segmentRadius)
                    .foregroundStyle(SwiftUI.Color.semantic(.staticWhite).opacity(0.28))
            }
            .shadow(color: .semantic(.staticBlack).opacity(0.08), radius: segmentRadius)
            .frame(width: segmentSide, height: segmentSide)
            .offset(x: segmentSide * CGFloat(selectedIndex))
        }

        @ViewBuilder
        private func segment(_ index: Int) -> some View {
            Image.icon(icons[index])
                .resizable()
                .frame(width: size.resourceIconSize, height: size.resourceIconSize)
                .foregroundColor(.semantic(index == selectedIndex ? .labelNormal : .labelAlternative))
                .frame(width: segmentSide, height: segmentSide)
                .contentShape(RoundedRectangle(cornerRadius: segmentRadius))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                    onSelect?(index)
                }
                // 아이콘만 노출되므로 VoiceOver에서 의미·조작 가능 여부를 알 수 있도록 라벨과 버튼/선택 trait를 부여한다.
                .accessibilityElement()
                .accessibilityLabel(accessibilityLabel(index))
                .accessibilityAddTraits(.isButton)
                .accessibilityAddTraits(index == selectedIndex ? .isSelected : [])
        }

        /// 세그먼트의 VoiceOver 라벨. 명시적 라벨이 없으면 아이콘 이름으로 대체한다.
        private func accessibilityLabel(_ index: Int) -> String {
            if index < accessibilityLabels.count, !accessibilityLabels[index].isEmpty {
                return accessibilityLabels[index]
            }
            return icons[index].rawValue
        }
    }

    struct UITextViewWrapper: UIViewRepresentable {
        @Binding var text: String
        let inputVariant: Typography.Variant

        init(text: Binding<String>, inputVariant: Typography.Variant) {
            _text = text
            self.inputVariant = inputVariant
        }

        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            // 디자인 폰트(Pretendard)를 Dynamic Type 스케일과 함께 적용한다. UIFont.font은 이미
            // UIFontMetrics 스케일 폰트를 반환하므로, adjustsFontForContentSizeCategory를 켜면 실행 중
            // 글자 크기 변경에도 자동으로 갱신된다.
            textView.font = UIFont.font(variant: inputVariant)
            textView.adjustsFontForContentSizeCategory = true
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.delegate = context.coordinator
            return textView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            // 사이즈(=입력 타이포그래피) 변경에 반응하도록 폰트를 갱신한다.
            uiView.font = UIFont.font(variant: inputVariant)

            // inputLimit 인터페이스의 구현 책임: 현재 텍스트가 제한을 초과하면(예: 외부에서 inputLimit을
            // 축소한 경우) 잘라낸다. 입력 시점 제한(shouldChangeTextIn)이 막지 못하는 경로를 보완한다.
            let effectiveText = inputLimit.map { String(text.prefix($0)) } ?? text
            if effectiveText != text {
                DispatchQueue.main.async { text = effectiveText }
            }

            if uiView.text != effectiveText {
                // 외부(코드)에서 텍스트가 교체되는 경우. 직접 대입은 UITextView의 UndoManager와
                // 동기화되지 않아 stale operation이 남고, 이후 Undo 시 저장된 range가 현재 길이를
                // 벗어나 out-of-bounds 크래시(LIVE-1014)를 유발하므로 undo 기록을 비운다.
                // 사용자 입력으로 인한 길이 제한은 shouldChangeTextIn에서 처리되어 이 경로를
                // 타지 않으므로 일반 타이핑의 undo/redo에는 영향을 주지 않는다.
                uiView.text = effectiveText
                uiView.undoManager?.removeAllActions()
            }
            if context.coordinator.parent.text != effectiveText {
                DispatchQueue.main.async {
                    context.coordinator.parent.text = effectiveText
                }
            }
            context.coordinator.parent.inputLimit = inputLimit
            context.coordinator.parent.inputTransform = inputTransform
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
                let currentText = textView.text ?? ""
                // Undo 등으로 전달된 range가 현재 텍스트 범위를 벗어나면 차단한다.
                // (out-of-bounds 크래시 방어 — Range 변환 실패가 곧 범위 초과를 의미)
                guard let swiftRange = Range(range, in: currentText) else { return false }

                // 입력 변환(emoji 제거 등)·길이 제한을 입력 시점에 적용해 UITextView가 항상
                // 정규화된 텍스트만 보유하도록 한다. 사후 변형을 하지 않으므로 textStorage와
                // UndoManager가 일관되게 유지되어 LIVE-1014(Undo 시 out-of-bounds) 크래시를 방지한다.
                var sanitized = parent.inputTransform?(text) ?? text
                if let maxLength = parent.inputLimit {
                    let lengthWithoutRange = currentText.count
                        - currentText.distance(from: swiftRange.lowerBound, to: swiftRange.upperBound)
                    let remaining = max(0, maxLength - lengthWithoutRange)
                    if sanitized.count > remaining {
                        sanitized = String(sanitized.prefix(remaining))
                    }
                }

                // 변형이 없으면 시스템 기본 입력을 허용한다(UITextView가 직접 처리 → undo 일관).
                if sanitized == text {
                    return true
                }

                // 삽입할 내용이 없고 지울 범위도 없으면(예: 길이 초과로 입력이 전부 잘린 경우)
                // 실질 변화가 없으므로 입력만 차단한다. 빈 replace를 호출하면 텍스트는 그대로면서
                // undo 기록만 쌓여 이후 Undo/Redo가 무반응이 된다.
                if sanitized.isEmpty, range.length == 0 {
                    return false
                }

                // 변형이 있으면 해당 범위에 직접 삽입(undo에 일관 기록)하고 시스템 입력은 차단한다.
                if let textRange = textView.textRange(for: range) {
                    textView.replace(textRange, withText: sanitized)
                    // replace + return false 경로에서는 캐럿이 삽입 시작 위치에 머무른다. UIKit이
                    // 델리게이트 반환 이후 selection을 복원하므로, 다음 런루프에서 삽입된 텍스트의
                    // 끝(시작 offset + 삽입 길이)으로 캐럿을 이동시킨다.
                    let caretOffset = range.location + (sanitized as NSString).length
                    DispatchQueue.main.async {
                        if let caret = textView.position(from: textView.beginningOfDocument, offset: caretOffset) {
                            textView.selectedTextRange = textView.textRange(from: caret, to: caret)
                        }
                    }
                }
                return false
            }

            func textViewDidChange(_ textView: UITextView) {
                let parentText = parent.text
                parent.text = textView.text
                // Binding된 값이 변하지 않으면, TextView에 Binding된 값 표시
                if parentText == parent.text {
                    textView.text = parentText
                }
                // sizeThatFits 반환 높이가 maxHeight에서 포화되면 SwiftUI가 sizeThatFits를
                // 재호출하지 않아 스크롤 토글 기회가 사라진다. 매 입력마다 호출되는 이 시점에서
                // 무제한 높이로 측정한 콘텐츠 높이로 스크롤 여부를 직접 갱신한다.
                let fit = textView.sizeThatFits(
                    CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
                ).height
                textView.isScrollEnabled = fit > (maxHeight ?? .greatestFiniteMagnitude)
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

            // isScrollEnabled는 여기서 설정하지 않는다. SwiftUI는 레이아웃 협상 과정에서
            // sizeThatFits를 비정상 width(예: 9, .infinity)로도 호출하는데, 그때의 측정값으로
            // 스크롤을 토글하면 textViewDidChange에서 올바르게 켠 값을 false로 덮어쓴다.
            // 스크롤 토글은 실제 bounds.width가 보장되는 textViewDidChange에서만 수행한다.
            newSize.height = min(max(newSize.height, minHeight ?? 0), maxHeight ?? .greatestFiniteMagnitude)
            return CGSize(
                width: proposal.width ?? uiView.bounds.width,
                height: newSize.height
            )
        }

        private var minHeight: CGFloat?
        private var maxHeight: CGFloat?
        private var inputLimit: Int?
        private var inputTransform: ((String) -> String)?

        func inputLimit(_ limit: Int?) -> Self {
            var zelf = self
            zelf.inputLimit = limit
            return zelf
        }

        func inputTransform(_ transform: ((String) -> String)?) -> Self {
            var zelf = self
            zelf.inputTransform = transform
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

// MARK: - Size Tokens

private extension TextArea.Size {
    /// 모서리 반경
    var cornerRadius: CGFloat {
        switch self {
        case .large: .radius14
        case .medium: .radius12
        }
    }

    /// Container 내부 패딩 (사이즈 공통 12)
    var containerPadding: CGFloat { .spacing12 }

    /// 콘텐츠 영역 ↔ Bottom Content 간격 (사이즈 공통 12)
    var contentBottomGap: CGFloat { .spacing12 }

    /// 콘텐츠 영역 좌우 패딩 (사이즈 공통 4)
    var contentPaddingX: CGFloat { .spacing4 }

    /// 입력 타이포그래피 변형
    var inputVariant: Typography.Variant {
        switch self {
        case .large: .body2
        case .medium: .label1
        }
    }

    /// Bottom Content 단순 아이콘 / iconButton 아이콘 크기.
    var resourceIconSize: CGFloat {
        switch self {
        case .large: 20
        case .medium: 18
        }
    }

    /// Bottom Content 텍스트 버튼 크기. Large=32, Medium=28 높이에 대응.
    var buttonSize: Button.Size {
        switch self {
        case .large: .small
        case .medium: .xsmall
        }
    }

    /// 배경 없는 아이콘 버튼 크기. Large=32(아이콘20), Medium=28(아이콘18).
    var normalIconButtonSize: IconButton.NormalSize {
        switch self {
        case .large: .large
        case .medium: .medium
        }
    }

    /// Bottom 전용 아이콘 세그먼트 컨트롤의 컨테이너 높이. Large=32, Medium=28.
    var segmentControlHeight: CGFloat {
        switch self {
        case .large: 32
        case .medium: 28
        }
    }

    /// Bottom Content 콘텐츠 뱃지 크기.
    var contentBadgeSize: ContentBadge.Size {
        switch self {
        case .large: .medium
        case .medium: .small
        }
    }
}

private extension UITextView {
    /// NSRange를 UITextRange로 변환한다. 범위가 유효하지 않으면 nil을 반환한다.
    func textRange(for nsRange: NSRange) -> UITextRange? {
        guard let start = position(from: beginningOfDocument, offset: nsRange.location),
              let end = position(from: start, offset: nsRange.length) else { return nil }
        return textRange(from: start, to: end)
    }
}
