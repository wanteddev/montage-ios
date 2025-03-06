//
//  Control.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/07.
//

import SwiftUI

public struct Control: View {
    // MARK: - Types
    
    public enum Variant: String, CaseIterable {
        case checkbox, checkmark, radio
    }
    
    public enum Size: String, CaseIterable {
        case normal, small
    }
    
    public enum State: String, CaseIterable {
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
        size: Size = .normal,
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
        size: Size = .normal,
        onSelect: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.variant = variant
        initializedState = checked ? .checked : .unchecked
        stateBinding = nil
        checkedBinding = nil
        self.size = size
        self.onSelect = onSelect == nil ? nil : { onSelect?(!$0.isUnchecked) }
    }
    
    init(variant: Variant, stateBinding: Binding<State>, size: Size = .normal) {
        self.variant = variant
        initializedState = stateBinding.wrappedValue
        self.stateBinding = stateBinding
        checkedBinding = nil
        self.size = size
        onSelect = nil
    }
    
    init(variant: Variant, checkedBinding: Binding<Bool>, size: Size = .normal) {
        self.variant = variant
        initializedState = checkedBinding.wrappedValue ? .checked : .unchecked
        stateBinding = nil
        self.checkedBinding = checkedBinding
        self.size = size
        onSelect = nil
    }
    
    public static func checkbox(
        state: State,
        size: Size = .normal,
        onSelect: ((State) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkbox, state: state, size: size, onSelect: onSelect)
    }
    
    public static func checkbox(
        checked: Bool,
        size: Size = .normal,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkbox, checked: checked, size: size, onSelect: onSelect)
    }
    
    public static func checkmark(
        checked: Bool,
        size: Size = .normal,
        onSelect: ((Bool) -> Void)? = nil
    ) -> Self {
        .init(variant: .checkmark, checked: checked, size: size, onSelect: onSelect)
    }
    
    public static func radio(checked: Bool, size: Size = .normal, onSelect: ((Bool) -> Void)? = nil) -> Self {
        .init(variant: .radio, checked: checked, size: size, onSelect: onSelect)
    }
    
    public static func checkbox(_ state: Binding<State>, size: Size = .normal) -> Self {
        .init(variant: .checkbox, stateBinding: state, size: size)
    }
    
    public static func checkbox(_ checked: Binding<Bool>, size: Size = .normal) -> Self {
        .init(variant: .checkbox, checkedBinding: checked, size: size)
    }
    
    public static func checkmark(_ checked: Binding<Bool>, size: Size = .normal) -> Self {
        .init(variant: .checkmark, checkedBinding: checked, size: size)
    }
    
    public static func radio(_ checked: Binding<Bool>, size: Size = .normal) -> Self {
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
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = value.translation == .zero
                }
                .onEnded { value in
                    isPressed = false
                    if value.translation == .zero {
                        let newState: State = state.isUnchecked ? .checked : .unchecked
                        stateBinding?.wrappedValue = newState
                        checkedBinding?.wrappedValue = state.isUnchecked
                        onSelect?(newState)
                    }
                }
        )
        .disabled(disable)
    }
    
    // MARK: - Modifiers
    
    private var tight = false
    private var disable = false
    
    public func tight(_ tight: Bool = true) -> Self {
        var zelf = self
        zelf.tight = tight
        return zelf
    }
    
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
            .alias(state.isUnchecked ? .labelAssistive : .primaryNormal)
                .opacity(disable ? 0.43 : 1)
        case .checkbox, .radio:
            .alias(.staticWhite)
        }
    }
    
    var iconSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .normal: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        case .checkmark:
            switch size {
            case .normal: .init(width: 24, height: 24)
            case .small: .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .normal: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        }
    }
    
    var backgroundColor: SwiftUI.Color {
        variant == .checkmark || state.isUnchecked
            ? .clear
            : .alias(.primaryNormal).opacity(disable ? 0.43 : 1)
    }
    
    var borderColor: SwiftUI.Color {
        switch variant {
        case .checkmark: .clear
        case .checkbox, .radio:
            .alias(state.isUnchecked ? .lineNormal : .primaryNormal).opacity(disable ? 0.43 : 1)
        }
    }
    
    var borderWidth: CGFloat {
        variant == .checkmark || !state.isUnchecked ? 0 : 1.5
    }
    
    var containerSize: CGSize {
        switch size {
        case .normal:
            .init(width: tight ? 20 : 24, height: 24)
        case .small:
            .init(width: tight ? 16 : 20, height: 20)
        }
    }
    
    var boxSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .normal:
                .init(width: 18, height: 18)
            case .small:
                .init(width: 16, height: 16)
            }
        case .checkmark:
            switch size {
            case .normal:
                .init(width: 24, height: 24)
            case .small:
                .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .normal:
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
        case .normal:
            .init(width: 32, height: 32)
        case .small:
            .init(width: 28, height: 28)
        }
    }
}
