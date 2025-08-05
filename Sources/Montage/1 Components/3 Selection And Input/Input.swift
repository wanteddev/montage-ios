//
//  Input.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

/// 텍스트와 함께 표시되는 선택 컨트롤 컴포넌트입니다.
///
/// 체크박스, 체크마크, 라디오 버튼과 같은 컨트롤을 텍스트 레이블과 함께 표시합니다.
/// 사용자가 텍스트를 클릭하여 컨트롤의 상태를 변경할 수 있습니다.
///
/// ```swift
/// // 체크박스와 텍스트
/// Input.checkbox(checked: true, text: "이용약관에 동의합니다") { isChecked in
///     print("동의 상태: \(isChecked)")
/// }
///
/// // 라디오 버튼과 텍스트
/// Input.radio(checked: false, text: "옵션 1")
///     .bold()
///     .size(.small)
///
/// // 바인딩 사용
/// @State private var isChecked = false
/// Input.checkmark($isChecked, text: "완료됨")
/// ```
///
/// - Note: 컨트롤과 텍스트는 수직 정렬되어 표시됩니다.
public struct Input: View {
    // MARK: - Initializer
    
    private let control: Control.Variant
    private let initializedState: Control.State
    private let stateBinding: Binding<Control.State>?
    private let checkedBinding: Binding<Bool>?
    private let text: String
    private let onSelect: ((_ newValue: Control.State) -> Void)?

    init(
        control: Control.Variant,
        state: Control.State,
        text: String,
        onSelect: ((_ newValue: Control.State) -> Void)? = nil
    ) {
        self.control = control
        initializedState = state
        stateBinding = nil
        checkedBinding = nil
        self.text = text
        self.onSelect = onSelect
    }
    
    init(
        control: Control.Variant,
        checked: Bool,
        text: String,
        onSelect: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.control = control
        initializedState = checked ? .checked : .unchecked
        stateBinding = nil
        checkedBinding = nil
        self.text = text
        self.onSelect = onSelect == nil ? nil : { onSelect?(!$0.isUnchecked) }
    }

    init(
        control: Control.Variant,
        stateBinding: Binding<Control.State>,
        text: String,
        onSelect: ((_ newValue: Control.State) -> Void)? = nil
    ) {
        self.control = control
        initializedState = stateBinding.wrappedValue
        self.stateBinding = stateBinding
        checkedBinding = nil
        self.text = text
        self.onSelect = onSelect
    }
    
    init(
        control: Control.Variant,
        checkedBinding: Binding<Bool>,
        text: String,
        onSelect: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.control = control
        initializedState = checkedBinding.wrappedValue ? .checked : .unchecked
        stateBinding = nil
        self.checkedBinding = checkedBinding
        self.text = text
        self.onSelect = onSelect == nil ? nil : { onSelect?(!$0.isUnchecked) }
    }
    
    /// 상태 값을 이용해 체크박스와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - state: 체크박스의 초기 상태
    ///   - text: 표시할 텍스트
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkbox(
        state: Control.State,
        text: String,
        onSelect: ((Control.State) -> Void)? = nil
    ) -> Self {
        .init(control: .checkbox, state: state, text: text, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 체크박스와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크박스의 초기 선택 상태
    ///   - text: 표시할 텍스트
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkbox(
        checked: Bool,
        text: String,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(control: .checkbox, checked: checked, text: text, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 체크마크와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크마크의 초기 선택 상태
    ///   - text: 표시할 텍스트
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkmark(
        checked: Bool,
        text: String,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(control: .checkmark, checked: checked, text: text, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 라디오 버튼과 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 라디오 버튼의 초기 선택 상태
    ///   - text: 표시할 텍스트
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 입력 컴포넌트
    public static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)? = nil) -> Self {
        .init(control: .radio, checked: checked, text: text, onSelect: onSelect)
    }
    
    /// 상태 바인딩을 이용해 체크박스와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - state: 체크박스 상태와 연결된 바인딩
    ///   - text: 표시할 텍스트
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkbox(_ state: Binding<Control.State>, text: String) -> Self {
        .init(control: .checkbox, stateBinding: state, text: text)
    }
    
    /// 불리언 바인딩을 이용해 체크박스와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크박스 선택 상태와 연결된 바인딩
    ///   - text: 표시할 텍스트
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkbox(_ checked: Binding<Bool>, text: String) -> Self {
        .init(control: .checkbox, checkedBinding: checked, text: text)
    }
    
    /// 불리언 바인딩을 이용해 체크마크와 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크마크 선택 상태와 연결된 바인딩
    ///   - text: 표시할 텍스트
    /// - Returns: 구성된 입력 컴포넌트
    public static func checkmark(_ checked: Binding<Bool>, text: String) -> Self {
        .init(control: .checkmark, checkedBinding: checked, text: text)
    }
    
    /// 불리언 바인딩을 이용해 라디오 버튼과 텍스트를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 라디오 버튼 선택 상태와 연결된 바인딩
    ///   - text: 표시할 텍스트
    /// - Returns: 구성된 입력 컴포넌트
    public static func radio(_ checked: Binding<Bool>, text: String) -> Self {
        .init(control: .radio, checkedBinding: checked, text: text)
    }
    
    // MARK: - Body
    
    @State private var singleLineHeight: CGFloat = 0
    
    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            nestedControl
                .frame(height: singleLineHeight)

            ZStack {
                Text(text)
                    .typography(
                        variant: titleTypography.variant,
                        weight: isBold ? .bold : titleTypography.weight
                    )
                    .paragraph(variant: titleTypography.variant)
                    .lineLimit(1)
                    .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                        singleLineHeight = $0
                    })
                    .opacity(0)
                    
                Text(text)
                    .typography(
                        variant: titleTypography.variant,
                        weight: isBold ? .bold : titleTypography.weight,
                        color: titleTypography.color
                    )
                    .paragraph(variant: titleTypography.variant)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, size == .medium ? 1 : 0)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard isDisable == false else { return }
                        stateBinding?.wrappedValue = state.isUnchecked ? .checked : .unchecked
                        checkedBinding?.wrappedValue = state.isUnchecked
                        onSelect?(state.isUnchecked ? .checked : .unchecked)
                    }
            }
        }
    }

    // MARK: - Modifiers
    private var size: Control.Size = .medium
    private var isDisable = false
    private var titleVariant: Typography.Variant?
    private var titleWeight: Typography.Weight?
    private var titleColor: SwiftUI.Color?
    private var isBold = false
    private var tight = false

    /// 컨트롤 사이즈를 설정합니다.
    ///
    /// - Parameter size: 컨트롤 크기 (.medium 또는 .small)
    /// - Returns: 수정된 입력 컴포넌트
    public func size(_ size: Control.Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// 컴포넌트를 비활성화합니다.
    ///
    /// 비활성화된 컴포넌트는 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.
    ///
    /// - Parameter isDisable: 비활성화 여부 (기본값: true)
    /// - Returns: 수정된 입력 컴포넌트
    public func disable(_ isDisable: Bool = true) -> Self {
        var zelf = self
        zelf.isDisable = isDisable
        return zelf
    }

    /// 텍스트의 타이포그래피 속성을 설정합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형 (.body2 또는 .label1)
    ///   - weight: 텍스트 굵기
    ///   - color: 텍스트 색상
    /// - Returns: 수정된 입력 컴포넌트
    public func title(
        _ variant: Typography.Variant? = nil,
        weight: Typography.Weight? = nil,
        color: SwiftUI.Color? = nil
    ) -> Self {
        var zelf = self
        zelf.titleVariant = variant
        zelf.titleWeight = weight
        zelf.titleColor = color
        return zelf
    }

    /// 텍스트를 볼드체로 설정합니다.
    ///
    /// - Parameter isBold: 볼드 적용 여부 (기본값: true)
    /// - Returns: 수정된 입력 컴포넌트
    public func bold(_ isBold: Bool = true) -> Self {
        var zelf = self
        zelf.isBold = isBold
        return zelf
    }
    
    /// 컨트롤을 더 조밀한 레이아웃으로 표시합니다.
    ///
    /// - Parameter tight: 조밀한 레이아웃 적용 여부 (기본값: true)
    /// - Returns: 수정된 입력 컴포넌트
    public func tight(_ tight: Bool = true) -> Self {
        var zelf = self
        zelf.tight = tight
        return zelf
    }
}

// MARK: - Private

private extension Input {
    var state: Control.State {
        stateBinding?.wrappedValue
            ?? checkedBinding.map { $0.wrappedValue ? .checked : .unchecked }
            ?? initializedState
    }
    
    var nestedControl: some View {
        Group {
            switch control {
            case .checkbox:
                Control.checkbox(state: state, size: size) {
                    stateBinding?.wrappedValue = $0
                    checkedBinding?.wrappedValue = $0.isUnchecked
                    onSelect?($0)
                }
                .disable(isDisable)
                .tight(tight)
            case .checkmark:
                Control.checkmark(checked: !state.isUnchecked, size: size) {
                    stateBinding?.wrappedValue = $0 ? .checked : .unchecked
                    checkedBinding?.wrappedValue = $0
                    onSelect?($0 ? .checked : .unchecked)
                }
                .disable(isDisable)
                .tight(tight)
            case .radio:
                Control.radio(checked: !state.isUnchecked, size: size) {
                    stateBinding?.wrappedValue = $0 ? .checked : .unchecked
                    checkedBinding?.wrappedValue = $0
                    onSelect?($0 ? .checked : .unchecked)
                }
                .disable(isDisable)
                .tight(tight)
            }
        }
    }

    var titleTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) {
        (
            variant: titleVariant ?? (size == .small ? .label1 : .body2),
            weight: titleWeight ?? .regular,
            color: isDisable ? .semantic(.labelDisable) : titleColor ?? .semantic(.labelNormal)
        )
    }
    
    var spacing: CGFloat {
        switch control {
        case .checkbox, .radio:
            8 + (tight ? 2 : 0)
        case .checkmark:
            4 + (tight ? 2 : 0)
        }
    }
}
