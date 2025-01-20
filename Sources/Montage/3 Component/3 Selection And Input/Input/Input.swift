//
//  Input.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

public struct Input: View {
    public enum NestedControl: String, CaseIterable {
        case check, checkbox, radio
    }
    
    private let control: NestedControl
    private let state: MontageControlState
    private let text: String
    private let onSelect: () -> Void

    public init(
        control: NestedControl,
        state: MontageControlState,
        text: String,
        onSelect: @escaping () -> Void
    ) {
        self.control = control
        self.state = state
        self.text = text
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            nestedControl
                .frame(width: 24, height: 24)
            Text(text)
                .montage(
                    variant: titleTypography.variant,
                    weight: titleTypography.weight,
                    color: titleTypography.color
                )
                .bold(isBold)
                .multilineTextAlignment(.leading)
                .paragraph(variant: titleTypography.variant)
        }
    }
    
    private var nestedControl: some View {
        Group {
            switch control {
            case .check:
                Control.Check(state: state, size: size) { _ in
                    onSelect()
                }
                .disable(isDisable)
            case .checkbox:
                Control.Checkbox(state: state, size: size) { _ in
                    onSelect()
                }
                .disable(isDisable)
            case .radio:
                Control.Radio(state: state, size: size) { _ in
                    onSelect()
                }
                .disable(isDisable)
            }
        }
    }
    
    private var spacing: CGFloat {
        switch control {
        case .checkbox, .radio:
            return 8
        case .check:
            return 4
        }
    }
    
    // MARK: - Modifiers
    private var size: MontageControlSize = .normal {
        didSet {
            if size == .small {
                titleTypography = (.label1, titleTypography.weight, titleTypography.color)
            } else {
                titleTypography = (.body2, titleTypography.weight, titleTypography.color)
            }
        }
    }
    private var isDisable = false {
        didSet {
            if isDisable {
                titleTypography = (titleTypography.variant, titleTypography.weight, .alias(.labelDisable))
            } else {
                titleTypography = (titleTypography.variant, titleTypography.weight, titleTypography.color)
            }
        }
    }
    private var titleTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.body2, .regular, .alias(.labelNormal))
    private var isBold = false
    
    /// 사이즈를 조정합니다. 기본값은 `.normal`입니다.
    public func size(_ size: MontageControlSize) -> Self {
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
    
    /// 타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.regular`, `.alias(.labelNormal)`입니다.
    public func title(
        _ variant: Typography.Variant? = nil,
        weight: Typography.Weight = .regular,
        color: SwiftUI.Color = .alias(.labelNormal)
    ) -> Self {
        var zelf = self
        zelf.titleTypography.variant = variant ?? (size == .small ? .label1 : .body2)
        zelf.titleTypography.weight = weight
        zelf.titleTypography.color = color
        return zelf
    }
    
    /// 타이틀을 볼드체로 변경합니다.
    public func bold(_ isBold: Bool = true) -> Self {
        var zelf = self
        zelf.isBold = isBold
        return zelf
    }
}
