//
//  FormControl.swift
//  Montage
//
//  Created by 김삼열 on 6/30/26.
//

import SwiftUI

/// 입력 컨트롤(``TextField`` 등)에 제목(Label)과 도움말(Message)을 붙여 주고,
/// 라벨 ↔ 입력 ↔ 메시지의 접근성 연결을 자동으로 처리하는 래퍼(wrapper) 컴포넌트입니다.
///
/// FormControl은 단독으로 값을 입력받지 않습니다. 내부 슬롯(`input`)에 실제 입력 컴포넌트를
/// 조합해 사용하며, 라벨·필수 표시(`*`)·도움말/에러 메시지·글자 수 카운트를 일관된
/// 레이아웃과 색·타이포그래피로 감싸 줍니다.
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
/// .characterCount(current: email.count, limit: 100)
///
/// // 라벨을 입력 왼쪽에 배치
/// FormControl { _ in
///     TextField(text: $name)
/// }
/// .labelPlacement(.start)
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
        /// 라벨을 입력 왼쪽에 가로로 배치하고, 입력 슬롯의 세로 중앙에 맞춥니다.
        case start
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
    private var characterCountText: String?

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

    /// 글자 수 카운트 텍스트를 직접 설정합니다.
    ///
    /// - Parameter text: 표시할 글자 수 텍스트(예: `"12/100"`). `nil`이면 표시하지 않습니다.
    /// - Returns: 수정된 FormControl 컴포넌트
    public func characterCount(_ text: String?) -> Self {
        modifying { $0.characterCountText = text }
    }

    /// 현재 글자 수와 최대 글자 수로 글자 수 카운트를 설정합니다.
    ///
    /// - Parameters:
    ///   - current: 현재 입력된 글자 수
    ///   - limit: 최대 글자 수
    /// - Returns: 수정된 FormControl 컴포넌트
    public func characterCount(current: Int, limit: Int) -> Self {
        characterCount("\(current)/\(limit)")
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        switch labelPlacement {
        case .top:
            topLayout
        case .start:
            startLayout
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

    /// 라벨을 입력 왼쪽에 두고, 라벨을 입력 슬롯의 세로 중앙에 맞추는 가로 레이아웃.
    @ViewBuilder
    var startLayout: some View {
        if hasLabel {
            // 라벨의 세로 중앙을 입력 슬롯의 세로 중앙에 정렬한다(Footer는 입력 아래로 흐름).
            // Figma 기준: Start 배치에서 라벨은 입력 필드 높이의 중앙에 위치한다.
            HStack(alignment: .inputCenter, spacing: .spacing16) {
                labelRow
                    .alignmentGuide(.inputCenter) { $0[VerticalAlignment.center] }
                inputWrapper
            }
        } else {
            inputWrapper
        }
    }

    /// 입력 슬롯과 Footer를 묶는 세로 래퍼. 입력 슬롯의 세로 중앙을 ``VerticalAlignment/inputCenter``로 노출한다.
    var inputWrapper: some View {
        VStack(alignment: .leading, spacing: .spacing8) {
            accessibleInput
                .alignmentGuide(.inputCenter) { $0[VerticalAlignment.center] }
            if hasFooter {
                footer
            }
        }
    }

    /// 라벨 + 필수(`*`) 행.
    var labelRow: some View {
        HStack(spacing: .spacing4) {
            Text(labelText ?? "")
                .typography(variant: labelVariant, weight: .bold, semantic: .labelNeutral)
            if isRequired {
                Text(verbatim: "*")
                    .typography(variant: labelVariant, weight: .medium, semantic: .statusNegative)
            }
        }
        .padding(.horizontal, .spacing2)
        // 라벨은 입력 슬롯의 accessibilityLabel로 연결되므로, 별도 요소로 중복 낭독되지 않게 숨긴다.
        .accessibilityHidden(true)
    }

    /// 메시지(좌) + 글자 수 카운트(우) Footer 행.
    var footer: some View {
        HStack(alignment: .top, spacing: .spacing8) {
            if let messageText, !messageText.isEmpty {
                Text(messageText)
                    .typography(variant: .caption1, weight: .regular, semantic: messageColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // 메시지는 입력 슬롯의 accessibilityHint로 연결되므로 중복 낭독을 막는다.
                    .accessibilityHidden(true)
            } else {
                Spacer(minLength: 0)
            }
            if let characterCountText, !characterCountText.isEmpty {
                Text(characterCountText)
                    .typography(variant: .caption1, weight: .regular, semantic: .labelAlternative)
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
        messageText?.isEmpty == false || characterCountText?.isEmpty == false
    }

    /// 크기에 따른 라벨 타이포그래피 변형.
    var labelVariant: Typography.Variant {
        switch size {
        case .large: .label1
        case .medium: .label2
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
    /// Start 배치에서 라벨을 입력 슬롯의 세로 중앙에 맞추기 위한 정렬.
    ///
    /// 라벨과 입력 슬롯이 각각 이 가이드를 자신의 세로 중앙으로 보고하면, Footer가 입력 아래로
    /// 흐르더라도 라벨은 입력 슬롯(Footer 제외)의 중앙에 정렬된다.
    enum InputCenter: AlignmentID {
        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            dimensions[VerticalAlignment.center]
        }
    }

    static let inputCenter = VerticalAlignment(InputCenter.self)
}

// MARK: - Status 편의 변환

extension FormControl.Status {
    /// 같은 의미의 ``TextField/Status`` 값으로 변환합니다.
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
