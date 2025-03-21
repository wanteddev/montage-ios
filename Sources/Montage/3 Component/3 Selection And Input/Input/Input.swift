//
//  Input.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

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
    
    public static func checkbox(
        state: Control.State,
        text: String,
        onSelect: ((Control.State) -> Void)? = nil
    ) -> Self {
        .init(control: .checkbox, state: state, text: text, onSelect: onSelect)
    }
    
    public static func checkbox(
        checked: Bool,
        text: String,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(control: .checkbox, checked: checked, text: text, onSelect: onSelect)
    }
    
    public static func checkmark(
        checked: Bool,
        text: String,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(control: .checkmark, checked: checked, text: text, onSelect: onSelect)
    }
    
    public static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)? = nil) -> Self {
        .init(control: .radio, checked: checked, text: text, onSelect: onSelect)
    }
    
    public static func checkbox(_ state: Binding<Control.State>, text: String) -> Self {
        .init(control: .checkbox, stateBinding: state, text: text)
    }
    
    public static func checkbox(_ checked: Binding<Bool>, text: String) -> Self {
        .init(control: .checkbox, checkedBinding: checked, text: text)
    }
    
    public static func checkmark(_ checked: Binding<Bool>, text: String) -> Self {
        .init(control: .checkmark, checkedBinding: checked, text: text)
    }
    
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
                    .montage(
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
                    .montage(
                        variant: titleTypography.variant,
                        weight: isBold ? .bold : titleTypography.weight,
                        color: titleTypography.color
                    )
                    .paragraph(variant: titleTypography.variant)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, size == .meidum ? 1 : 0)
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
    private var size: Control.Size = .meidum
    private var isDisable = false
    private var titleVariant: Typography.Variant?
    private var titleWeight: Typography.Weight?
    private var titleColor: SwiftUI.Color?
    private var isBold = false
    private var tight = false

    /// 사이즈를 조정합니다. 기본값은 `.meidum`입니다.
    public func size(_ size: Control.Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// 비활성화합니다.
    public func disable(_ isDisable: Bool = true) -> Self {
        var zelf = self
        zelf.isDisable = isDisable
        return zelf
    }

    /// 타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.regular`, `.semantic(.labelNormal)`입니다.
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

    /// 타이틀을 볼드체로 변경합니다.
    public func bold(_ isBold: Bool = true) -> Self {
        var zelf = self
        zelf.isBold = isBold
        return zelf
    }
    
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
