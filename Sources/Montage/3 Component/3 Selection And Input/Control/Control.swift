//
//  Control.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/07.
//

import SwiftUI

/// 체크박스, 체크마크, 라디오 버튼과 같은 선택 컨트롤을 제공하는 컴포넌트입니다.
///
/// 다양한 유형의 선택 컨트롤을 통일된 인터페이스로 제공합니다.
/// 선택 상태 변경 시 콜백을 받을 수 있으며, 크기와 스타일을 조정할 수 있습니다.
///
/// **사용 예시**:
/// ```swift
/// // 체크박스
/// Control.checkbox(checked: true) { isChecked in
///     print("체크박스 선택 상태: \(isChecked)")
/// }
///
/// // 라디오 버튼
/// Control.radio(checked: false)
///     .tight()
///     .size(.small)
///
/// // 바인딩 사용
/// @State private var isChecked = false
/// Control.checkmark($isChecked)
/// ```
///
/// - Note: 모든 컨트롤은 상태에 따라 적절한 시각적 피드백을 제공합니다.
public struct Control: View {
    // MARK: - Types
    
    /// 컨트롤의 종류를 정의하는 열거형입니다.
    ///
    /// - checkbox: 체크박스 (3가지 상태: 선택, 미선택, 중간 상태)
    /// - checkmark: 체크마크 (선택, 미선택 상태만 지원)
    /// - radio: 라디오 버튼 (선택, 미선택 상태만 지원)
    public enum Variant {
        case checkbox, checkmark, radio
    }
    
    /// 컨트롤의 크기를 정의하는 열거형입니다.
    ///
    /// - medium: 중간 크기 (24x24)
    /// - small: 작은 크기 (20x20)
    public enum Size {
        case medium, small
    }
    
    /// 컨트롤의 상태를 정의하는 열거형입니다.
    ///
    /// - unchecked: 선택되지 않은 상태
    /// - checked: 선택된 상태
    /// - indeterminate: 중간 상태 (checkbox에서만 지원)
    public enum State {
        case unchecked
        case checked
        case indeterminate
        
        internal var isUnchecked: Bool {
            self == .unchecked
        }
    }
    
    // MARK: - Initializer
    
    private let variant: Variant
    private let initializedState: State
    private let stateBinding: Binding<State>?
    private let checkedBinding: Binding<Bool>?
    private let size: Size
    private let onSelect: ((_ newValue: State) -> Void)?
    
    init(
        variant: Variant,
        state: State,
        size: Size = .medium,
        onSelect: ((_ newValue: State) -> Void)? = nil
    ) {
        self.variant = variant
        initializedState = state
        stateBinding = nil
        checkedBinding = nil
        self.size = size
        self.onSelect = onSelect
    }
    
    init(
        variant: Variant,
        checked: Bool,
        size: Size = .medium,
        onSelect: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.variant = variant
        initializedState = checked ? .checked : .unchecked
        stateBinding = nil
        checkedBinding = nil
        self.size = size
        self.onSelect = onSelect == nil ? nil : { onSelect?(!$0.isUnchecked) }
    }
    
    init(variant: Variant, stateBinding: Binding<State>, size: Size = .medium) {
        self.variant = variant
        initializedState = stateBinding.wrappedValue
        self.stateBinding = stateBinding
        checkedBinding = nil
        self.size = size
        onSelect = nil
    }
    
    init(variant: Variant, checkedBinding: Binding<Bool>, size: Size = .medium) {
        self.variant = variant
        initializedState = checkedBinding.wrappedValue ? .checked : .unchecked
        stateBinding = nil
        self.checkedBinding = checkedBinding
        self.size = size
        onSelect = nil
    }
    
    /// 상태 값을 이용해 체크박스를 생성합니다.
    ///
    /// - Parameters:
    ///   - state: 체크박스의 초기 상태
    ///   - size: 체크박스 크기 (기본값: .medium)
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 체크박스 컨트롤
    public static func checkbox(
        state: State, size: Size = .medium, onSelect: ((State) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkbox, state: state, size: size, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 체크박스를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크박스의 초기 선택 상태
    ///   - size: 체크박스 크기 (기본값: .medium)
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 체크박스 컨트롤
    public static func checkbox(
        checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkbox, checked: checked, size: size, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 체크마크를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크마크의 초기 선택 상태
    ///   - size: 체크마크 크기 (기본값: .medium)
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 체크마크 컨트롤
    public static func checkmark(
        checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkmark, checked: checked, size: size, onSelect: onSelect)
    }
    
    /// 불리언 값을 이용해 라디오 버튼을 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 라디오 버튼의 초기 선택 상태
    ///   - size: 라디오 버튼 크기 (기본값: .medium)
    ///   - onSelect: 선택 상태 변경 시 호출되는 클로저
    /// - Returns: 구성된 라디오 버튼 컨트롤
    public static func radio(
        checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(variant: .radio, checked: checked, size: size, onSelect: onSelect)
    }
    
    /// 상태 바인딩을 이용해 체크박스를 생성합니다.
    ///
    /// - Parameters:
    ///   - state: 체크박스 상태와 연결된 바인딩
    ///   - size: 체크박스 크기 (기본값: .medium)
    /// - Returns: 구성된 체크박스 컨트롤
    public static func checkbox(_ state: Binding<State>, size: Size = .medium) -> Self {
        .init(variant: .checkbox, stateBinding: state, size: size)
    }
    
    /// 불리언 바인딩을 이용해 체크박스를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크박스 선택 상태와 연결된 바인딩
    ///   - size: 체크박스 크기 (기본값: .medium)
    /// - Returns: 구성된 체크박스 컨트롤
    public static func checkbox(_ checked: Binding<Bool>, size: Size = .medium) -> Self {
        .init(variant: .checkbox, checkedBinding: checked, size: size)
    }
    
    /// 불리언 바인딩을 이용해 체크마크를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 체크마크 선택 상태와 연결된 바인딩
    ///   - size: 체크마크 크기 (기본값: .medium)
    /// - Returns: 구성된 체크마크 컨트롤
    public static func checkmark(_ checked: Binding<Bool>, size: Size = .medium) -> Self {
        .init(variant: .checkmark, checkedBinding: checked, size: size)
    }
    
    /// 불리언 바인딩을 이용해 라디오 버튼을 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 라디오 버튼 선택 상태와 연결된 바인딩
    ///   - size: 라디오 버튼 크기 (기본값: .medium)
    /// - Returns: 구성된 라디오 버튼 컨트롤
    public static func radio(_ checked: Binding<Bool>, size: Size = .medium) -> Self {
        .init(variant: .radio, checkedBinding: checked, size: size)
    }
    
    // MARK: - Body
    
    @SwiftUI.State private var isPressed = false
    
    public var body: some View {
        Group {
            if let icon {
                Image.montage(icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFill()
                    .foregroundStyle(iconColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            } else {
                SwiftUI.Color.clear
            }
        }
        .frame(width: boxSize.width, height: boxSize.height)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .frame(width: containerSize.width, height: containerSize.height)
        .background {
            Decorate.Interaction(
                state: isPressed ? .pressed : .normal,
                variant: .normal,
                color: .labelNormal
            )
            .clipShape(Circle())
            .frame(width: interactionSize.width, height: interactionSize.height)
        }
        .modifier(PressActionDetectingModifier(isPressed: $isPressed) {
            let newState: State = state.isUnchecked ? .checked : .unchecked
            stateBinding?.wrappedValue = newState
            checkedBinding?.wrappedValue = state.isUnchecked
            onSelect?(newState)
        })
        .disabled(disable)
    }
    
    // MARK: - Modifiers
    
    private var tight = false
    private var disable = false
    
    /// 컨트롤을 더 조밀한 레이아웃으로 표시합니다.
    ///
    /// 이 수정자를 적용하면 컨트롤의 가로 너비가 줄어듭니다.
    /// - medium: 24px → 20px
    /// - small: 20px → 16px
    ///
    /// - Parameter tight: 조밀한 레이아웃 적용 여부 (기본값: true)
    /// - Returns: 수정된 컨트롤 인스턴스
    public func tight(_ tight: Bool = true) -> Self {
        var zelf = self
        zelf.tight = tight
        return zelf
    }
    
    /// 컨트롤을 비활성화합니다.
    ///
    /// 비활성화된 컨트롤은 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.
    ///
    /// - Parameter disable: 비활성화 여부 (기본값: true)
    /// - Returns: 수정된 컨트롤 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
}

private extension Control {
    var state: State {
        stateBinding?.wrappedValue
            ?? checkedBinding.map { $0.wrappedValue ? .checked : .unchecked }
            ?? initializedState
    }
    
    var icon: Icon? {
        switch variant {
        case .checkbox:
            switch state {
            case .checked: .checkThick
            case .indeterminate: .lineHorizontalThick
            case .unchecked: nil
            }
        case .checkmark: .checkThick
        case .radio: state.isUnchecked ? nil : .dot
        }
    }
    
    var iconColor: SwiftUI.Color {
        switch variant {
        case .checkmark:
            .semantic(state.isUnchecked ? .labelAssistive : .primaryNormal)
                .opacity(disable ? 0.43 : 1)
        case .checkbox, .radio:
            .semantic(.staticWhite)
        }
    }
    
    var iconSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .medium: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        case .checkmark:
            switch size {
            case .medium: .init(width: 24, height: 24)
            case .small: .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .medium: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        }
    }
    
    var backgroundColor: SwiftUI.Color {
        variant == .checkmark || state.isUnchecked
            ? .clear
            : .semantic(.primaryNormal).opacity(disable ? 0.43 : 1)
    }
    
    var borderColor: SwiftUI.Color {
        switch variant {
        case .checkmark: .clear
        case .checkbox, .radio:
            .semantic(state.isUnchecked ? .lineNormal : .primaryNormal).opacity(disable ? 0.43 : 1)
        }
    }
    
    var borderWidth: CGFloat {
        variant == .checkmark || !state.isUnchecked ? 0 : 1.5
    }
    
    var containerSize: CGSize {
        switch size {
        case .medium:
            .init(width: tight ? 20 : 24, height: 24)
        case .small:
            .init(width: tight ? 16 : 20, height: 20)
        }
    }
    
    var boxSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .medium:
                .init(width: 18, height: 18)
            case .small:
                .init(width: 16, height: 16)
            }
        case .checkmark:
            switch size {
            case .medium:
                .init(width: 24, height: 24)
            case .small:
                .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .medium:
                .init(width: 20, height: 20)
            case .small:
                .init(width: 16, height: 16)
            }
        }
    }
    
    var cornerRadius: CGFloat {
        switch variant {
        case .checkbox:
            5
        case .checkmark:
            .zero
        case .radio:
            boxSize.width / 2
        }
    }
    
    var interactionSize: CGSize {
        switch size {
        case .medium:
            .init(width: 32, height: 32)
        case .small:
            .init(width: 28, height: 28)
        }
    }
}
