//
//  FormControl.swift
//  Montage
//
//  Created by 김삼열 on 6/30/26.
//

import SwiftUI

/// 입력 컨트롤에 제목(Label)과 도움말(Message)을 붙여 주고, 라벨 ↔ 입력 ↔ 메시지의 접근성 연결을
/// 자동으로 처리하는 래퍼(wrapper) 컴포넌트입니다.
///
/// FormControl은 단독으로 값을 입력받지 않습니다. 내부 슬롯(`input`)에 실제 입력 컴포넌트를
/// 조합해 사용하며, 라벨·필수 표시(`*`)·도움말/에러 메시지·액세서리(글자 수 카운트 등)를
/// 일관된 레이아웃으로 감싸 줍니다.
///
/// 슬롯 클로저는 현재 ``Context``(크기·상태)를 전달받습니다. 입력 컴포넌트가 이를 반영하면
/// FormControl의 `.size(_:)`·`.status(_:)` 한 번 설정만으로 내부 입력까지 일관되게 그려집니다.
///
/// ```swift
/// FormControl { context in
///     TextField(text: $email)
///         .size(context.size == .medium ? .medium : .large)
///         .status(context.status.textFieldStatus)
///         .placeholder("이메일을 입력하세요")
/// }
/// .label("이메일", required: true)
/// .message("회사 이메일을 입력해 주세요.")
///
/// // 에러 상태 — FormControl에만 .status(.negative)를 주면 메시지 색과 입력 상태가 함께 바뀐다.
/// FormControl { context in
///     TextField(text: $email).status(context.status.textFieldStatus)
/// }
/// .size(.medium)
/// .status(.negative)
/// .label("이메일", required: true)
/// .message("올바른 이메일 형식이 아닙니다.")
/// .accessory {
///     Text("\(email.count)/100")
///         .typography(variant: .caption1, weight: .regular, semantic: .labelAlternative)
/// }
///
/// // 라벨을 입력 왼쪽에 배치
/// FormControl { _ in
///     TextField(text: $name)
/// }
/// .labelPlacement(.leading)
/// .label("이름")
/// ```
public struct FormControl: View {
    /// FormControl의 크기입니다. 라벨 타이포그래피를 결정합니다.
    public enum Size {
        /// 큰 크기 (라벨 `label1`)
        case large
        /// 중간 크기 (라벨 `label2`)
        case medium
    }

    /// FormControl의 상태입니다. 메시지의 색을 결정합니다.
    public enum Status {
        /// 기본 상태. 메시지는 도움말 색(`labelAlternative`)으로 표시됩니다.
        case normal
        /// 성공 상태. 메시지는 기본 도움말과 동일한 색(`labelAlternative`)으로 표시됩니다.
        case positive
        /// 에러 상태. 메시지는 강조 색(`statusNegative`)으로 표시됩니다.
        case negative
    }

    /// 라벨의 위치입니다.
    public enum LabelPlacement {
        /// 라벨을 입력 위에 세로로 배치합니다. (기본)
        case top
        /// 라벨을 입력의 leading 쪽에 가로로 배치하고, 입력 슬롯의 세로 중앙에 맞춥니다.
        case leading
    }

    private let input: (Context) -> AnyView

    /// 입력 슬롯 클로저에 전달되는 FormControl의 현재 상태 컨텍스트입니다.
    ///
    /// 슬롯 입력 컴포넌트가 FormControl의 ``Size``·``Status``를 그대로 반영하도록
    /// 현재 값을 묶어 전달합니다. 향후 항목이 추가돼도 클로저 시그니처는 바뀌지 않습니다.
    public struct Context {
        /// 현재 FormControl 크기.
        public let size: Size
        /// 현재 FormControl 상태.
        public let status: Status
    }

    private var size: Size = .large
    private var status: Status = .normal
    private var labelPlacement: LabelPlacement = .top
    private var labelText: String?
    private var isRequired: Bool = false
    private var messageText: String?
    private var accessoryView: AnyView?
    private var explicitLabelWidth: CGFloat?

    /// ``FormControlGroup``이 주입하는 공유 라벨 컬럼 폭. leading 배치에서 라벨 폭을 이 값으로 맞춘다.
    @Environment(\.formLabelColumnWidth) private var columnLabelWidth

    /// ``inputFirstLineHeight``의 Dynamic Type 스케일 기준값(크기별). 입력 슬롯의 첫 줄 높이는 글자
    /// 크기에 따라 커지므로(입력 폰트가 `UIFontMetrics` 곡선으로 스케일), 라벨 정렬 기준도 같은 곡선으로
    /// 커지도록 입력 폰트 variant의 텍스트 스타일(large `.body2`→`.subheadline`, medium `.label1`→`.footnote`)에
    /// 맞춰 스케일한다. 기본 글자 크기에서는 48/40 그대로다.
    @ScaledMetric(relativeTo: .subheadline) private var scaledLargeFirstLineHeight: CGFloat = .dimension48
    @ScaledMetric(relativeTo: .footnote) private var scaledMediumFirstLineHeight: CGFloat = .dimension40

    /// 입력 컴포넌트를 슬롯으로 받아 FormControl을 생성합니다.
    ///
    /// 클로저는 현재 ``Context``(크기·상태)를 전달받으므로, 입력 컴포넌트가 FormControl의
    /// 크기·상태를 그대로 반영할 수 있습니다. (예: FormControl에 `.status(.negative)`만
    /// 설정하면 내부 입력도 에러 상태로 그릴 수 있음)
    ///
    /// - Parameter input: 현재 ``Context``를 받아 감쌀 입력 컴포넌트를 반환하는 뷰 빌더
    public init<Input: View>(@ViewBuilder input: @escaping (Context) -> Input) {
        self.input = { AnyView(input($0)) }
    }

    /// 크기를 설정합니다.
    ///
    /// - Parameter size: FormControl 크기. 생략하면 기본값으로 `.large` 적용
    /// - Returns: 수정된 FormControl 컴포넌트
    public func size(_ size: Size) -> Self {
        modifying { $0.size = size }
    }

    /// 상태를 설정합니다.
    ///
    /// - Parameter status: FormControl 상태. 생략하면 기본값으로 `.normal` 적용
    /// - Returns: 수정된 FormControl 컴포넌트
    public func status(_ status: Status) -> Self {
        modifying { $0.status = status }
    }

    /// 라벨 위치를 설정합니다.
    ///
    /// - Parameter placement: 라벨 위치. 생략하면 기본값으로 `.top` 적용
    /// - Returns: 수정된 FormControl 컴포넌트
    public func labelPlacement(_ placement: LabelPlacement) -> Self {
        modifying { $0.labelPlacement = placement }
    }

    /// 라벨 텍스트와 필수 표시 여부를 설정합니다.
    ///
    /// - Parameters:
    ///   - text: 라벨 텍스트. `nil`이거나 비어 있으면 라벨을 표시하지 않습니다.
    ///   - required: 필수 입력 표시(`*`) 여부. 생략하면 기본값으로 `false` 적용
    /// - Returns: 수정된 FormControl 컴포넌트
    public func label(_ text: String?, required: Bool = false) -> Self {
        modifying {
            $0.labelText = text
            $0.isRequired = required
        }
    }

    /// 도움말/에러 메시지를 설정합니다.
    ///
    /// - Parameter text: 메시지 텍스트. `nil`이거나 비어 있으면 메시지를 표시하지 않습니다.
    /// - Returns: 수정된 FormControl 컴포넌트
    ///
    /// - Note: 메시지 색은 ``status(_:)``에 따라 결정됩니다. `.negative`에서만 강조 색으로 표시됩니다.
    public func message(_ text: String?) -> Self {
        modifying { $0.messageText = text }
    }

    /// Footer 우측(trailing)에 표시할 액세서리 뷰를 설정합니다.
    ///
    /// 글자 수 카운트, 타이머 등 입력 아래에 붙는 보조 요소를 자유롭게 구성할 수 있습니다.
    /// 스타일(타이포그래피·색)은 호출부에서 지정합니다.
    ///
    /// - Parameter accessory: 표시할 액세서리 뷰 빌더
    /// - Returns: 수정된 FormControl 컴포넌트
    public func accessory<Accessory: View>(@ViewBuilder _ accessory: () -> Accessory) -> Self {
        let view = AnyView(accessory())
        return modifying { $0.accessoryView = view }
    }

    /// leading 배치에서 이 컨트롤의 라벨 폭을 명시적으로 고정합니다.
    ///
    /// 주 용도는 두 가지입니다. (1) 단독 leading FormControl에서 라벨 폭을 스펙값으로 맞출 때, 그리고
    /// (2) ``FormControlGroup`` 안에서 특정 행 하나만 다른 폭으로 둘 때(per-control 값이 컨테이너 폭보다 우선).
    ///
    /// 컬럼 전체를 고정 폭으로 맞추려면 각 컨트롤에 반복하지 말고 ``FormControlGroup``의 `labelWidth`를 쓰세요.
    /// ``LabelPlacement/top`` 배치에는 영향이 없습니다.
    ///
    /// - Parameter width: 라벨 열 폭(pt).
    /// - Returns: 수정된 FormControl 컴포넌트
    public func labelWidth(_ width: CGFloat) -> Self {
        modifying { $0.explicitLabelWidth = width }
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        switch labelPlacement {
        case .top:
            topLayout
        case .leading:
            leadingLayout
        }
    }
}

// MARK: - Layout

private extension FormControl {
    /// 라벨을 입력 위에 두는 세로 레이아웃.
    var topLayout: some View {
        VStack(alignment: .leading, spacing: .spacing8) {
            if hasLabel {
                labelRow
            }
            accessibleInput
            if hasFooter {
                footer
            }
        }
    }

    /// 라벨을 입력의 leading 쪽에 두고, 라벨을 입력 슬롯의 세로 중앙에 맞추는 가로 레이아웃.
    @ViewBuilder
    var leadingLayout: some View {
        if hasLabel {
            // Figma 기준: Leading 배치에서 라벨(한 줄)은 입력 첫 줄 높이 영역(medium 40 / large 48)에 맞춘다.
            // - 입력 높이 ≤ 첫 줄 높이(예: TextField): 라벨을 입력 세로 중앙에 정렬
            // - 입력 높이 > 첫 줄 높이(예: 여러 줄 TextArea): 라벨을 입력 상단 첫 줄 중앙에 정렬
            HStack(alignment: .inputCenter, spacing: .spacing16) {
                leadingLabel
                    .alignmentGuide(.inputCenter) { $0[VerticalAlignment.center] }
                inputWrapper
            }
        } else {
            inputWrapper
        }
    }

    /// leading 배치용 라벨. 공유 라벨 컬럼 폭(있으면)에 맞춰 폭을 고정한다.
    ///
    /// 높이는 고정하지 않는다. 라벨은 ``styledLabel``에서 한 줄로 제한되며, Dynamic Type로
    /// 커진 글자가 잘리지 않도록 높이가 자연스럽게 늘어난다. (고정 높이 clip은 접근성 위반)
    ///
    /// 폭 우선순위: ``labelWidth(_:)`` 명시값 → ``FormControlGroup`` 주입값 → 없으면 본연 폭.
    /// 실제 적용 폭과 무관하게 라벨 **본연 폭**을 ``FormLabelWidthKey``로 보고해,
    /// ``FormControlGroup``이 최댓값(가장 긴 라벨)을 계산할 수 있게 한다.
    var leadingLabel: some View {
        labelRow
            .frame(width: resolvedLabelWidth, alignment: .leading)
            .background(alignment: .topLeading) {
                labelRow
                    .fixedSize(horizontal: true, vertical: false)
                    .hidden()
                    .background(GeometryReader { proxy in
                        SwiftUI.Color.clear.preference(key: FormLabelWidthKey.self, value: proxy.size.width)
                    })
            }
    }

    /// leading 배치에서 라벨에 적용할 폭. 명시값 > 컬럼 주입값 > `nil`(본연 폭) 순.
    var resolvedLabelWidth: CGFloat? {
        explicitLabelWidth ?? columnLabelWidth
    }

    /// 입력 슬롯과 Footer를 묶는 세로 래퍼. 입력 슬롯의 정렬 기준(``VerticalAlignment/inputCenter``)을 노출한다.
    ///
    /// 정렬 기준은 입력 높이의 중앙이 아니라 `min(높이, 입력 첫 줄 높이)/2`다. 입력이 첫 줄 높이 이하면 중앙이지만,
    /// 넘으면 `첫 줄 높이/2`로 고정되어 라벨이 입력 상단 첫 줄에 정렬된다. 첫 줄 높이(``inputFirstLineHeight``,
    /// 기본 medium 40 / large 48)는 Dynamic Type로 함께 커진다.
    var inputWrapper: some View {
        VStack(alignment: .leading, spacing: .spacing8) {
            accessibleInput
                .alignmentGuide(.inputCenter) { min($0.height, inputFirstLineHeight) / 2 }
            if hasFooter {
                footer
            }
        }
    }

    /// 라벨 + 필수(`*`) 행.
    var labelRow: some View {
        styledLabel
            .padding(.horizontal, .spacing2)
            // 라벨은 입력 슬롯의 accessibilityLabel로 연결되므로, 별도 요소로 중복 낭독되지 않게 숨긴다.
            .accessibilityHidden(true)
    }

    /// 라벨과 필수(`*`)를 렌더링한다.
    ///
    /// 라벨은 **한 줄**로 제한하고(`lineLimit(1)`), 넘치면 말줄임(`tail`)한다.
    /// 줄 수 기반 제한이라 Dynamic Type로 글자가 커져도 한 줄이 함께 커지며 잘리지 않는다.
    /// (고정 높이로 자르면 큰 글자에서 텍스트가 클립되므로 사용하지 않는다.)
    ///
    /// 필수(`*`)는 라벨 말줄임과 무관하게 끝에 항상 보이도록 **별도 요소**로 두고,
    /// 자신의 고유 크기를 유지(`fixedSize`)해 함께 잘리지 않게 한다.
    @ViewBuilder
    var styledLabel: some View {
        let labelPart = Text(labelText ?? "")
            .typography(variant: labelVariant, weight: .bold, semantic: .labelNeutral)
            .lineLimit(1)
            .truncationMode(.tail)

        if isRequired {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                labelPart
                Text(verbatim: " *")
                    .typography(variant: labelVariant, weight: .medium, semantic: .statusNegative)
                    .fixedSize()
            }
        } else {
            labelPart
        }
    }

    /// 메시지(좌) + 액세서리(우) Footer 행.
    ///
    /// 폭이 부족하면 액세서리가 자기 크기를 유지하고(레이아웃 우선), 메시지가 줄바꿈된다.
    /// 두 요소 사이 최소 간격은 `spacing8`이다.
    var footer: some View {
        HStack(alignment: .top, spacing: .spacing8) {
            if let messageText, !messageText.isEmpty {
                Text(messageText)
                    .typography(variant: .caption1, weight: .regular, semantic: messageColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // 메시지는 입력 슬롯의 accessibilityHint로 연결되므로 중복 낭독을 막는다.
                    .accessibilityHidden(true)
            } else {
                Spacer(minLength: 0)
            }
            if let accessoryView {
                accessoryView
                    .layoutPriority(1)
            }
        }
        .padding(.horizontal, .spacing2)
    }

    /// 라벨·메시지를 접근성으로 연결한 입력 슬롯. 현재 크기·상태를 슬롯 클로저에 전달한다.
    var accessibleInput: some View {
        input(Context(size: size, status: status)).modifier(
            FormControlAccessibility(
                label: hasLabel ? accessibilityLabelText : nil,
                hint: (messageText?.isEmpty == false) ? messageText : nil
            )
        )
    }
}

// MARK: - Derived values

private extension FormControl {
    var hasLabel: Bool {
        labelText?.isEmpty == false
    }

    var hasFooter: Bool {
        messageText?.isEmpty == false || accessoryView != nil
    }

    /// 크기에 따른 라벨 타이포그래피 변형.
    var labelVariant: Typography.Variant {
        switch size {
        case .large: .label1
        case .medium: .label2
        }
    }

    /// 크기에 따른 입력 슬롯 첫 줄 높이. leading 배치에서 라벨을 입력 첫 줄에 맞추는 세로 정렬 기준이 된다.
    ///
    /// 기준값은 슬롯 입력 컴포넌트(TextField/TextArea)의 첫 줄 높이와 맞춘 `.large` 48 / `.medium` 40이며,
    /// 입력 폰트가 Dynamic Type로 커지면 첫 줄도 함께 커지므로 ``scaledLargeFirstLineHeight`` /
    /// ``scaledMediumFirstLineHeight``로 같은 곡선을 따라 스케일한다. (고정값이면 큰 글자에서 라벨 정렬이 어긋남)
    var inputFirstLineHeight: CGFloat {
        switch size {
        case .large: scaledLargeFirstLineHeight
        case .medium: scaledMediumFirstLineHeight
        }
    }

    /// 상태에 따른 메시지 색. `.negative`에서만 강조 색을 사용한다.
    var messageColor: Color.Semantic {
        switch status {
        case .normal, .positive: .labelAlternative
        case .negative: .statusNegative
        }
    }

    /// 입력 슬롯에 연결할 접근성 라벨. 필수일 때 "필수"를 덧붙인다.
    var accessibilityLabelText: String? {
        guard let labelText, !labelText.isEmpty else { return nil }
        return isRequired ? "\(labelText), 필수" : labelText
    }
}

// MARK: - Helpers

private extension FormControl {
    /// 값 복사 후 일부 속성만 바꿔 새 인스턴스를 반환하는 빌더 헬퍼.
    func modifying(_ transform: (inout Self) -> Void) -> Self {
        var copy = self
        transform(&copy)
        return copy
    }
}

// MARK: - Alignment

private extension VerticalAlignment {
    /// Leading 배치에서 라벨을 입력 슬롯의 첫 줄(medium 40 / large 48 영역)에 맞추기 위한 정렬.
    ///
    /// 라벨은 자신의 세로 중앙을, 입력 슬롯은 `min(높이, 첫 줄 높이)/2` 지점을 이 가이드로 보고한다.
    /// 그 결과 입력이 첫 줄 높이 이하면 라벨이 입력 중앙에, 넘으면 입력 상단 첫 줄에 정렬된다.
    /// (Footer는 입력 아래로 흐르며 정렬 기준에서 제외된다.)
    enum InputCenter: AlignmentID {
        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            dimensions[VerticalAlignment.center]
        }
    }

    static let inputCenter = VerticalAlignment(InputCenter.self)
}

// MARK: - Label column coordination

/// leading 배치 라벨들의 **본연 폭 최댓값**을 모으는 PreferenceKey.
///
/// ``FormControlGroup``이 이 값을 읽어 ``EnvironmentValues/formLabelColumnWidth``로 재주입하고,
/// 각 ``FormControl``의 leading 라벨이 그 폭에 맞춰져 입력 시작 위치가 정렬된다.
struct FormLabelWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension EnvironmentValues {
    /// ``FormControlGroup``이 주입하는 공유 라벨 컬럼 폭. 컨테이너 밖(단독 사용)에서는 `nil`이다.
    var formLabelColumnWidth: CGFloat? {
        get { self[FormLabelColumnWidthKey.self] }
        set { self[FormLabelColumnWidthKey.self] = newValue }
    }
}

private struct FormLabelColumnWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

// MARK: - Status 편의 변환

extension FormControl.Status {
    /// 같은 의미의 TextField 상태 값으로 변환합니다.
    ///
    /// 슬롯에 ``TextField``를 둘 때 ``FormControl/Context/status``를 그대로 전달하기 위한 편의 변환입니다.
    public var textFieldStatus: TextField.Status {
        switch self {
        case .normal: .normal
        case .positive: .positive
        case .negative: .negative
        }
    }
}

/// 입력 슬롯에 접근성 라벨/힌트를 선택적으로 연결하는 모디파이어.
///
/// 값이 `nil`인 항목은 슬롯 입력 컴포넌트가 스스로 정의한 접근성 정보를 덮어쓰지 않도록 적용하지 않는다.
private struct FormControlAccessibility: ViewModifier {
    let label: String?
    let hint: String?

    func body(content: Content) -> some View {
        var result = AnyView(content)
        if let label {
            result = AnyView(result.accessibilityLabel(Text(label)))
        }
        if let hint {
            result = AnyView(result.accessibilityHint(Text(hint)))
        }
        return result
    }
}
